# An RSpec matcher which works with FactoryGirl to assert that a factory can
# be saved without any errors. Useful to go one step further than testing
# validation to confirm that a model can actually _be persisted_.
#
# Examples:
#
#   describe User do
#     # Looks for a factory called "user"
#     it { should successfully_save }
#
#     # Looks for a factory called "admin"
#     it { should successfully_save(:admin) }
#   end

RSpec::Matchers.define :successfully_save do |*factory|
  match do |document|
    @factory  = factory.try(:first) || document.class.name.underscore.to_sym
    @instance = FactoryGirl.build(@factory)
    @instance.save
  end

  description do
    'be saved successfully'
  end

  failure_message_for_should do |*|
    errors = @instance.errors.map do |attr, message|
      "  - #{attr} #{message}"
    end.join("\n")

    "expected #{@factory} to be saved; got errors:\n#{errors}"
  end

  failure_message_for_should_not do |*|
    "expected #{@factory} to not be saved, but it was"
  end
end
