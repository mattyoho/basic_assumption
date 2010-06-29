Spec::Matchers.define :assume do |assumption|
  match do |controller|
    controller.respond_to?(assumption) && controller.respond_to?(:"#{assumption}=")
  end

  failure_message_for_should do |controller|
    "expected #{controller.class.name} to assume '#{assumption}'"
  end

  failure_message_for_should_not do |controller|
    "expected #{controller.class.name} not to assume '#{assumption}'"
  end
end
