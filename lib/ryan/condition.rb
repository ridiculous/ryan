require 'set'
require 'ruby2ruby'

class Ryan::Condition

  attr_reader :nested_conditions, :sexp, :parts

  def initialize(sexp)
    @sexp = sexp
    @nested_conditions = create_nested_conditions
    @parts = load_parts
  end

  def full_statement
    @full_statement ||= Ruby2Ruby.new.process(sexp.deep_clone)
  end

  def statement
    edit_statement Ruby2Ruby.new.process(sexp[1].deep_clone)
  end

  def if_text
    edit_return_text Ruby2Ruby.new.process(if_sexp.deep_clone)
  end

  def else_text
    edit_return_text Ruby2Ruby.new.process(else_sexp.deep_clone)
  end

  def if_sexp
    if sexp[2].nil?
      sexp.last
    elsif sexp[2].first == :if
      nil
    elsif sexp[2].first == :block
      sexp[2].last
    elsif sexp[2].first == :rescue
      sexp[2][1].last
    else
      sexp[2]
    end
  end

  def else_sexp
    if sexp.compact[3].nil?
      nil
    elsif sexp[3].first == :block
      sexp[3].last
    elsif sexp[3].first == :if
      nil
    else
      sexp[3]
    end
  end

  #
  # Private
  #

  def edit_return_text(txt)
    txt = txt.to_s
    txt.sub! /^return\b/, 'returns'
    txt.sub! /^returns\s*$/, 'returns nil'
    if txt.include?(' = ')
      txt = "assigns #{txt}"
    elsif !txt.empty? and txt !~ /^return/
      txt = "returns #{txt.strip}"
    end
    txt.strip
  end

  def edit_statement(txt)
    txt = txt[/(.+)\n?/, 1] # take first line
    txt.prepend 'unless ' if sexp[2].nil? # this is an unless statement
    txt
  end

  # @description handles elsif
  def load_parts
    condition_parts = Set.new
    sexp.each_sexp do |s|
      if s.first == :if
        condition_parts << self.class.new(s)
      end
    end
    condition_parts.to_a
  end

  def create_nested_conditions
    nc = Set.new
    s = sexp.drop(1)
    s.flatten.include?(:if) && s.deep_each do |exp|
      Ryan::SexpDecorator.new(exp).each_sexp_condition do |node|
        nc << self.class.new(node)
      end
    end
    nc.to_a
  end

  #
  # Set comparison operators
  #

  def eql?(other)
    hash == other.hash
  end

  def hash
    sexp.object_id
  end
end
