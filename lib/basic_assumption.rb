require 'basic_assumption/configuration'
require 'basic_assumption/default_assumption'

module BasicAssumption
  def default_assumption(symbol=nil, &block)
    default = block_given? ? block : symbol
    BasicAssumption::DefaultAssumption.register(self, default)
  end

  def assume(name, &block)
    define_method(name) do
      @basic_assumptions       ||= {}
      @basic_assumptions[name] ||= if block_given?
        instance_eval(&block)
      else
        block = BasicAssumption::DefaultAssumption.resolve(self.class)
        instance_exec(name, &block)
      end
    end
    after_assumption(name)
  end

  def after_assumption(name); end
end
