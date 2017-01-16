module ShEx::Algebra
  ##
  class SemAct < Operator
    NAME = :semact

    ##
    # Creates an operator instance from a parsed ShExJ representation
    # @param (see Operator#from_shexj)
    # @return [Operator]
    def self.from_shexj(operator, options = {})
      raise ArgumentError unless operator.is_a?(Hash) && operator['type'] == "SemAct"
      raise ArgumentError, "missing name in #{operator.inspect}" unless operator.has_key?('name')
      code = operator.delete('code')
      operator['code'] = code if code # Reorders operands appropriately
      super
    end

    #
    # The evaluation semActsSatisfied on a list of SemActs returns success or failure. The evaluation of an individual SemAct is implementation-dependent.
    # @param [Array<RDF::Statement>] statements
    # @return [Boolean] `true` if satisfied, `false` if it does not apply
    # @raise [ShEx::NotSatisfied] if not satisfied
    def satisfies?(statements, depth: 0)
      # FIXME: should have a registry
      case operands.first.to_s
      when "http://shex.io/extensions/Test/"
        str = if md = /^ *(fail|print) *\( *(?:(\"(?:[^\\"]|\\")*\")|([spo])) *\) *$/.match(operands[1].to_s)
          md[2] || case md[3]
          when 's' then statements.first.subject
          when 'p' then statements.first.predicate
          when 'o' then statements.first.object
          else          statements.first.to_sxp
          end.to_s
        else
          statements.empty? ? 'no statement' : statements.first.to_sxp
        end
        $stdout.puts str
        status str
        not_satisfied "fail" if md && md[1] == 'fail'
        true
      else
        status("unknown SemAct name #{operands.first}", depth: depth) {"expression: #{self.to_sxp}"}
        false
      end
    end

    # Does This operator is SemAct
    def semact?; true; end
  end
end
