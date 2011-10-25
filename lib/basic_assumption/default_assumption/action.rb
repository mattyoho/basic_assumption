module BasicAssumption
  module DefaultAssumption
    class Action
      attr_reader :request, :callbacks

      def initialize(request, &block)
        @request   = request
        @callbacks = {}

        block.yield self
      end

      %w(new update find index).each do |name|
        class_eval <<-MET, __FILE__, __LINE__
          def #{name}(&block)
            if block_given?
              callbacks[:#{name}] = block
            else
              (callbacks[:#{name}] || callbacks[:default]).call
            end
          end
        MET
      end

      def default(&block)
        callbacks[:default] = block
      end

      def outcome
        return index  if index?
        return new    if make?
        return update if update?
        find
      end

      private

      def index?
        action == 'index'
      end

      def make? #:nodoc:
        %w(new create).include?(action)
      end

      def update?
        %w(update edit).include?(action)
      end

      def action
        request.params['action']
      end

    end
  end
end
