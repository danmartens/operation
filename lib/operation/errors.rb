# frozen_string_literal: true

class Operation
  class OperationError < StandardError; end
  class InvalidArgument < OperationError; end
  class AssertionFailed < OperationError; end
  class InvalidResult < OperationError; end

  class Failure < OperationError
    attr_reader :result

    def initialize(result)
      @result = result
    end
  end
end
