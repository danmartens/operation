# frozen_string_literal: true

require 'dry-types'

class Operation
  module Types
    include Dry::Types.module
  end

  ARGUMENT_TYPES = {
    symbol: Operation::Types::Strict::Symbol,
    bool: Operation::Types::Strict::Bool,
    integer: Operation::Types::Strict::Integer,
    float: Operation::Types::Strict::Float,
    decimal: Operation::Types::Strict::Decimal,
    string: Operation::Types::Strict::String,
    date: Operation::Types::Strict::Date,
    date_time: Operation::Types::Strict::DateTime,
    time: Operation::Types::Strict::Time,
    array: Operation::Types::Strict::Array,
    hash: Operation::Types::Strict::Hash,
    enumerable: Operation::Types.Instance(::Enumerable),
    optional_symbol: Operation::Types::Strict::Symbol.optional,
    optional_bool: Operation::Types::Strict::Bool.optional,
    optional_integer: Operation::Types::Strict::Integer.optional,
    optional_float: Operation::Types::Strict::Float.optional,
    optional_decimal: Operation::Types::Strict::Decimal.optional,
    optional_string: Operation::Types::Strict::String.optional,
    optional_date: Operation::Types::Strict::Date.optional,
    optional_date_time: Operation::Types::Strict::DateTime.optional,
    optional_time: Operation::Types::Strict::Time.optional,
    optional_array: Operation::Types::Strict::Array.optional,
    optional_hash: Operation::Types::Strict::Hash.optional,
    optional_enumerable: Operation::Types.Instance(::Enumerable).optional
  }.freeze
end