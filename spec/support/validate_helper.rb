RSpec::Matchers.define :require_presence_of do |attrib, options = {}|
  match do |model|
    model.send(attrib.to_s + '=', nil)
    model.valid? options[:context]
    @errors = model.errors[attrib].count
    @expected_errors = (options[:errors] || 1)
    @errors == @expected_errors
  end

  failure_message_for_should do |model|
    attrib,options = expected
    message = "expected #{model} to have #{@expected_errors}" +
        " errors for #{attrib}, but it has #{@errors}."
  end

  description do
    "validates presence of attribute #{attrib}"
  end
end

RSpec::Matchers.define :require_confirmation_of do |attrib, options = {}|
  match do |model|
    model.send(attrib.to_s + '=', '1234567890')
    model.send(attrib.to_s + '_confirmation=', '1234567891')
    model.valid? options[:context]
    @errors = model.errors[attrib].count
    @expected_errors = (options[:errors] || 1)
    @errors == @expected_errors
  end

  failure_message_for_should do |model|
    attrib,options = expected
    message = "expected #{model} to have #{@expected_errors}" +
        " errors for #{attrib}, but it has #{@errors}."
  end

  description do
    "validates confirmation of attribute #{attrib}"
  end
end

RSpec::Matchers.define :require_valid do |attrib, options = {}|
  match do |model|
    @expected_errors = (options[:errors] || 1)
    model.send(attrib.to_s + '=', options[:invalid])
    model.valid? options[:context]
    @errors = model.errors[attrib].count
    return false unless @errors == @expected_errors

    @expected_errors = 0
    model.send(attrib.to_s + '=', options[:valid])
    model.valid? options[:context]
    @errors = model.errors[attrib].count
    @errors == @expected_errors
  end

  failure_message_for_should do |model|
    attrib,options = expected
    message = "expected #{model} to have #{@expected_errors}" +
        " errors for #{attrib}, but it has #{@errors}."
  end

  description do
    "validates attribute #{attrib} is valid"
  end
end
