# frozen_string_literal: true

class RequiredArguments < Operation
  argument :name, :string
  argument :age, :integer

  def perform(name:, age:)
    success
  end
end

class FailingAssertion < Operation
  def perform
    assert false, 'This should always fail.'

    success
  end
end

class PassingAssertion < Operation
  def perform
    assert true, 'This should always pass.'

    success
  end
end

class SuccessResult < Operation
  def perform
    success(
      name: 'Jane Doe',
      age: 42
    )
  end
end

class FailureResult < Operation
  def perform
    failure(
      name: 'Jane Doe',
      age: 42
    )
  end
end

class RescueFrom < Operation
  rescue_from RuntimeError

  def perform
    raise 'This should be rescued.'
  end
end

class ReportError < Operation
  rescue_from RuntimeError

  def self.report_error(error)
    ErrorReporter.report(error)
  end

  def perform
    raise 'This should be rescued and reported.'
  end
end

module ErrorReporter
  def self.report(error); end
end

class DelegateFromOperation < Operation
  def perform
    DelegateToOperation.perform!
  end
end

class DelegateToOperation < Operation
  def perform
    failure
  end
end

RSpec.describe Operation do
  it 'has a version number' do
    expect(Operation::VERSION).not_to be nil
  end

  it 'requires perform to be implemented' do
    expect do
      Operation.perform
    end.to raise_error(
      NotImplementedError,
      'Operation subclasses must implement #perform.'
    )
  end

  it 'validates arguments' do
    expect(
      RequiredArguments.perform!(name: 'Jane Doe', age: 42)
    ).to be_success

    expect do
      RequiredArguments.perform!(name: true, age: 42)
    end.to raise_error(Operation::InvalidArgument)

    expect(
      RequiredArguments.perform(name: true, age: 42)
    ).to_not be_success

    expect do
      RequiredArguments.perform!(name: 'Jane Doe')
    end.to raise_error(Operation::InvalidArgument)

    expect(
      RequiredArguments.perform(name: 'Jane Doe')
    ).to_not be_success

    expect do
      RequiredArguments.perform!
    end.to raise_error(Operation::InvalidArgument)

    expect(
      RequiredArguments.perform
    ).to_not be_success
  end

  it 'runs assertions' do
    expect do
      FailingAssertion.perform!
    end.to raise_error(Operation::AssertionFailed, 'This should always fail.')

    expect(FailingAssertion.perform).to_not be_success
    expect(PassingAssertion.perform).to be_success
  end

  it 'returns a success result' do
    expect(SuccessResult.perform).to be_success
    expect(SuccessResult.perform.name).to eq('Jane Doe')
    expect(SuccessResult.perform.age).to eq(42)

    expect do
      SuccessResult.perform.not_a_method
    end.to raise_error(NoMethodError)
  end

  it 'returns a failure result' do
    expect(FailureResult.perform).to_not be_success
    expect(FailureResult.perform.name).to eq('Jane Doe')
    expect(FailureResult.perform.age).to eq(42)

    expect do
      FailureResult.perform.not_a_method
    end.to raise_error(NoMethodError)
  end

  it 'rescues from errors when calling #perform' do
    expect(RescueFrom.perform).to_not be_success

    expect do
      RescueFrom.perform!
    end.to raise_error(RuntimeError)
  end

  it 'reports rescued errors when calling #perform' do
    expect(ErrorReporter).to receive(:report)

    expect(ReportError.perform).to_not be_success
  end

  it 'delegates to other operations' do
    expect(DelegateFromOperation.perform).to_not be_success

    expect { DelegateFromOperation.perform! }.to raise_error do |error|
      expect(error).to be_a(Operation::Failure)
      expect(error.result).to_not be_success
    end
  end
end
