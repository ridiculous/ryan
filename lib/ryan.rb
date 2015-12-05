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

  # @param [Pathname, String] file
  def initialize(file)
    @sexp = RubyParser.new.parse File.read(file)
    @const = Const.new(sexp)
  end
end
