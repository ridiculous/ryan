class Ryan
  class Assignment
    attr_reader :sexp

    def initialize(sexp)
      @sexp = sexp
    end

    def to_s
      "assigns #{name}"
    end

    # @example s(:iasgn, :@duder, s(:if, ...)
    # @example s(:op_asgn_or, s(:ivar, :@report), ...)
    def name
      if sexp.first == :iasgn
        sexp[1]
      elsif sexp.first == :op_asgn_or
        sexp[1][1]
      end
    end
  end
end
