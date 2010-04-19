module BasicAssumption
  def assume(name, &block)
    define_method(name) do
      @basic_assumptions ||= {}
      @basic_assumptions[name] ||= instance_eval(&block)
    end
    hide_action name
    helper_method name
  end
end
