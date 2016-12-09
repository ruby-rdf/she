require 'sparql/algebra'
require 'sparql/extensions'

module ShEx::Algebra
  # Implements `satisfies?` and `not_satisfies?`
  module Satisfiable
    ##
    # Satisfies method
    # @param [RDF::Resource] n
    # @return [Boolean] `true` if satisfied, `false` if it does not apply
    # @raise [ShEx::NotSatisfied] if not satisfied
    # @see [https://shexspec.github.io/spec/#shape-expression-semantics]
    def satisfies?(n)
      raise NotImplementedError, "#satisfies? Not implemented in #{self.class}"
    end

    ##
    # Satisfies method
    # @param [RDF::Resource] n
    # @return [Boolean] `true` if not satisfied, `false` if it does not apply
    # @raise [ShEx::NotSatisfied] if satisfied
    # @see [https://shexspec.github.io/spec/#shape-expression-semantics]
    def not_satisfies?(n)
      begin
        satisfies?(n)
      rescue ShEx::NotSatisfied => e
        log_recover(self.class.const_get(:NAME), "ignore error: #{e.message}", depth: options.fetch(:depth, 0))
        return true  # Expected it to not satisfy
      end
      not_satisfied "Expression should not have matched"
    end
    alias_method :notSatisfies?, :not_satisfies?

    # This operator includes Satisfiable
    def satisfiable?; true; end
  end
end
