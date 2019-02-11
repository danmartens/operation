# frozen_string_literal: true

class Operation
  class Result
    def self.success(attributes)
      new(true, attributes)
    end

    def self.failure(attributes)
      new(false, attributes)
    end

    def initialize(success, attributes)
      @success = success
      @attributes = attributes.transform_keys(&:to_sym)
    end

    def success?
      @success
    end

    def method_missing(method_name, *_args)
      if @attributes.key?(method_name)
        @attributes[method_name]
      else
        super
      end
    end

    def respond_to_missing?(method_name, _include_private = false)
      @attributes.key?(method_name) || super
    end
  end
end