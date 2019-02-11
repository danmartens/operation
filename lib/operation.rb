# frozen_string_literal: true

require 'operation/version'
require 'operation/types'
require 'operation/errors'
require 'operation/result'

class Operation
  class << self
    def argument_types
      @argument_types || {}
    end

    def argument(name, type)
      type = type.is_a?(Symbol) ? ARGUMENT_TYPES[type] : type

      unless type.respond_to?(:[])
        raise(
          ArgumentError,
          "Invalid type provided for argument \"#{name}\"."
        )
      end

      @argument_types ||= {}
      @argument_types[name.to_sym] = type
    end

    def rescue_from(*error_classes)
      @rescue_from ||= []
      @rescue_from += error_classes
    end

    def perform!(**args)
      validate_arguments!(**args)

      new.perform(**args).tap do |result|
        case result
        when Operation::Result
          raise Operation::Failure.new(result) unless result.success?
        else
          raise(
            Operation::InvalidResult,
            'Operations must return either a success or a failure result.'
          )
        end
      end
    end

    def perform(**args)
      error_classes = [Operation::OperationError] + (@rescue_from || [])

      perform!(**args)
    rescue *error_classes => error
      send(:report_error, error) if respond_to?(:report_error)

      return error.result if error.is_a?(Operation::Failure)

      Result.failure(error: error)
    end

    def validate_arguments!(**args)
      names = (argument_types.keys + args.keys).uniq

      names.each_with_object({}) do |name, hash|
        type = argument_types[name]

        if type.nil?
          raise(
            Operation::InvalidArgument,
            "Missing type for argument \"#{name}\" on operation \"#{self.name}\"."
          )
        end

        hash[name] = type.send(:[], args[name])
      rescue Dry::Types::ConstraintError
        raise(
          Operation::InvalidArgument,
          "Invalid value provided for argument \"#{name}\" on operation \"#{self.name}\"."
        )
      end
    end
  end

  def perform
    raise(
      NotImplementedError,
      'Operation subclasses must implement #perform.'
    )
  end

  private

  def assert(condition, message)
    raise(AssertionFailed, message) unless condition
  end

  def success(attributes = {})
    Result.success(attributes)
  end

  def failure(attributes = {})
    Result.failure(attributes)
  end
end