require 'ruby_parser'
require 'forwardable'

class Ryan
  autoload :Version, 'ryan/version'
  autoload :Const, 'ryan/const'
  autoload :Condition, 'ryan/condition'
  autoload :Func, 'ryan/func'
  autoload :ClassFunc, 'ryan/class_func'
  autoload :InstanceFunc, 'ryan/instance_func'
  autoload :Assignment, 'ryan/assignment'
  autoload :SexpDecorator, 'ryan/sexp_decorator'

  attr_reader :sexp, :const

  extend Forwardable

  def_delegators :const,
    :name, :funcs, :type, :initialization_args, :func_by_name, :class?, :module?

  def self.root
    Pathname.new File.expand_path('../..', __FILE__)
  end

  # @note Attempts to read a file if a path is given, otherwise threats input as ruby code string
  # @param [Pathname, String] input
  def initialize(input)
    input = File.read(input) if File.file?(input)
    @sexp = RubyParser.new.parse(input)
    @const = Const.new(sexp)
  end
end
