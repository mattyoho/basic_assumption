module BasicAssumption
  class Configuration
    class ActiveRecord #:nodoc:
      SETTINGS = [:find_on_id, :raise_error]

      SETTINGS.each do |setting|
        attr_accessor setting
      end

      def settings_hash
        SETTINGS.inject({}) do |hash, setting|
          hash[setting] = self.send setting
          hash
        end
      end
    end
  end
end

