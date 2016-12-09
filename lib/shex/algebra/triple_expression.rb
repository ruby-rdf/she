require 'sparql/algebra'
require 'sparql/extensions'

module ShEx::Algebra
  # Implements `neigh`, `arcs_out`, `args_in` and `matches`
  module TripleExpression

    ##
    # `matches`: asserts that a triple expression is matched by a set of triples that come from the neighbourhood of a node in an RDF graph. The expression `matches(T, expr, m)` indicates that a set of triples `T` can satisfy these rules...
    #
    # Behavior should be overridden in subclasses, which end by calling this through `super`.
    #
    # @param [Array<RDF::Statement>] t
    # @return [Array<RDF::Statement>]
    # @raise NotMatched, ShEx::NotSatisfied
    def matches(t)
      raise NotImplementedError, "#matches Not implemented in #{self.class}"
      # FIXME: cardinatlity
    end

    ##
    # Included TripleConstraints
    # @return [Array<TripleConstraints>]
    def triple_constraints
      operands.select {|o| o.is_a?(TripleExpression)}.map(&:triple_constraints).flatten.uniq
    end

    ##
    # Minimum constraint (defaults to 1)
    # @return [Integer]
    def minimum
      op = operands.detect {|o| o.is_a?(Array) && o.first == :min} || [:min, 1]
      op[1]
    end

    ##
    # Maximum constraint (defaults to 1)
    # @return [Integer, Float::INFINITY]
    def maximum
      op = operands.detect {|o| o.is_a?(Array) && o.first == :max} || [:max, 1]
      op[1] == '*' ? Float::INFINITY : op[1]
    end

    # This operator includes TripleExpression
    def triple_expression?; true; end
  end
end
