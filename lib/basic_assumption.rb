require 'basic_assumption/configuration'

module BasicAssumption
  def self.extended(base)
    base.default_assumption {}
  end

  def default_assumption(&block)
    define_method(:default_assumption) do
      block
    end
  end

  def assume(name, &block)
    define_method(name) do
      @basic_assumptions       ||= {}
      @basic_assumptions[name] ||= if block_given?
        instance_eval(&block)
      else
        instance_exec(name, &default_assumption)
      end
    end
    after_assumption(name)
  end

  def after_assumption(name); end
end
