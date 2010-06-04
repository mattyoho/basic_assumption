require 'basic_assumption/configuration'
require 'basic_assumption/default_assumption'

# == BasicAssumption
#
# A module that allows for a declaritive idiom that maps a name to behavior
# inside your application. It uses memoization, blocks, and the ability to
# set default behavior to clean up certain kinds of code, particularly Rails'
# controllers and views.
module BasicAssumption
  # Changes the default behavior for methods created by +assume+ in the
  # current class and its descendants. If a block is given, that block
  # will be used as the new default. Otherwise, if +name+ is provided,
  # +BasicAssumption+ will assume it refers to a snake-cased class name
  # that will provide the default behavior. For details on custom defaults,
  # please see the documentation for +DefaultAssumption+.
  #
  # === Example
  #
  #  class WidgetController
  #    extend BasicAssumption
  #
  #    default_assumption do
  #      Widget.find_by_id(params[:widget_id])
  #      log_request(current_user, params[:widget_id])
  #    end
  #
  #    assume(:widget)
  #  end
  def default_assumption(name=nil, &block)
    default = block_given? ? block : name
    DefaultAssumption.register(self, default)
  end

  # Declares a resource at the instance level by creating an instance method
  # called +name+ that returns the result of +block+ if it is given or the
  # default if it is not.
  #
  # === Example
  #
  #  class Foo
  #    extend BasicAssumption
  #
  #    assume(:cute) { 'Fuzzy kittens.' }
  #    assume 'assumption'
  #  end
  #
  #  foo = Foo.new
  #  foo.cute         #=> 'Fuzzy kittens.'
  #  foo.assumption   #=> nil
  #
  # The first call to +assume+ creates an instance method +cute+ that
  # returns the result of evaluating the block passed to it. The second call
  # creates a method +assumption+ that returns the default result, which
  # will be +nil+ unless the default has been overridden. See
  # +default_assumption+ for details on overriding the default behavior.
  #
  # In both cases, the result is memoized and returned directly for
  # subsequent calls.
  #
  # +assume+ will also create an attribute writer method that will allow the
  # value returned by the instance method (the reader, from this point of view)
  # to be overriden.
  def assume(name, strategy={}, &block)
    define_method(name) do
      @basic_assumptions       ||= {}
      @basic_assumptions[name] ||= if block_given?
        instance_eval(&block)
      else
        which = strategy[:using] || self.class
        block = DefaultAssumption.resolve(which)
        instance_exec(name, &block)
      end
    end
    define_method("#{name}=") do |value|
      @basic_assumptions       ||= {}
      @basic_assumptions[name] = value
    end
    after_assumption(name)
  end

  # Callback that is invoked once +assume+ has created a new method.
  # When BasicAssumption is used in the context of ActionController, for
  # example, this callback is used to prevent the new method from being a
  # visible action and to make it available in views. (See the documentation
  # for +Railtie+.)
  #
  #   class ActionController::Base
  #     extend BasicAssumption
  #     def after_assumption(name)
  #       helper_method(name)
  #       hide_action(name)
  #     end
  #   end
  def after_assumption(name); end
end
