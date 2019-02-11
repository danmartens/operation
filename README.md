# Operation

## Getting Started

Add the gem to your Gemfile and then run `bundle install`:

```ruby
gem 'operation', github: 'danmartens/operation'
```

## Writing an Operation

The most basic operation is just a subclass of `Operation` with a `#perform` method:

```ruby
class MakeBreakfast < Operation
  def perform
    success(status: 'Ready to eat!')
  end
end
```

The operation can be performed by calling `.perform`:

```ruby
MakeBreakfast.perform
```

Note that is a static method on the operation which will instantiate the operation and call its `#perform` method, forwarding any arguments passed to it. _Operations should never be manually instantiated because they will lose almost all of the benefits they provide over a standard Ruby class._

The perform method of an operation must return either an `Operation::Result` instance or raise an exeception. Operations have two conveinence methods for creating `Operation::Result`s: `#success` and `#failure`. These methods both accept a hash and the object they return will respond to all keys in the hash, returning the value of that key (think of it as an immutable [OpenStruct](https://ruby-doc.org/stdlib-2.0.0/libdoc/ostruct/rdoc/OpenStruct.html) with a few extra features).

```ruby
result = MakeBreakfast.perform # => Operation::Result
result.success? # => true
result.status # => "Ready to eat!"
```

If `#perform` returns anything other than an `Operation::Result`, an `Operation::InvalidResult` error will be raised.

## Validating Arguments

Operations use the [dry-types](https://dry-rb.org/gems/dry-types) gem to validate arguments passed to `.perform`.

Arguments are specified using the `.argument` method:

```ruby
class MakeBreakfast < Operation
  argument :count, Operation::Types::Strict::Integer

  def perform(count:)
    count.times do
      # Logic for making breakfast
    end

    success(status: "Ready to eat!")
  end
end
```

`Strict` types should always be preferred over non-`Strict` types. Using `Strict` types will cause operations to fail if invalid arguments are passed in.

Symbols can be used as shorthand for common types. This is equivalent to the operation above:

```ruby
class MakeBreakfast < Operation
  argument :count, :integer

  def perform(count:)
    # ...
  end
end
```

See [types.rb](lib/operation/types.rb) for a full list of these symbols.

All arguments passed to `.perform` _must_ have an associated type. Extra arguments and missing, non-optional argumets will both cause an operation to fail.
