module ShEx::Algebra
  ##
  class Start < Operator::Unary
    NAME = :start

    #
    # @param [RDF::Resource] focus
    # @return [Boolean] `true` if satisfied
    # @raise [ShEx::NotSatisfied] if not satisfied
    def satisfies?(focus)
      status ""
      operands.first.satisfies?(focus)
      status("satisfied")
      true
    rescue ShEx::NotSatisfied => e
      not_satisfied e.message
      raise
    end
  end
end
