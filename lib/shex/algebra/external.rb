module ShEx::Algebra
  ##
  class External < Operator
    include Satisfiable
    NAME = :external

    #
    # S is a ShapeRef and the Schema's shapes maps reference to a shape expression se2 and satisfies(n, se2, G, m).
    def satisfies?(focus, depth: 0)
      extern_shape = nil

      # Find the label for this external
      label = schema.shapes.key(self)
      not_satisfied("Can't find label for this extern", depth: depth) unless label

      schema.external_schemas.each do |schema|
        extern_shape ||= schema.shapes[label]
      end

      not_satisfied("External not configured for this shape", depth: depth) unless extern_shape
      extern_shape.satisfies?(focus, depth: depth + 1)
    end

    def json_type
      "ShapeExternal"
    end
  end
end
