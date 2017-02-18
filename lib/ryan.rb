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
    current_file_name = __FILE__
    path_to_current_file = File.expand_path(current_file_name)
    root_path = Pathname.new(path_to_current_file) + "../.."

    return root_path
  end

  # @param [Pathname, String] file
  def initialize(file, mode=:file)
    parsable_code = case mode
    when :text
      file
    else # for :default :file and fallback
      File.read(file)
    end

    @sexp = RubyParser.new.parse(parsable_code)
    @const = Const.new(sexp)
  end

end
