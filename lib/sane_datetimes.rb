require 'sane_datetime_input'

module SaneDatetimes
  def self.included(base)
    
    define_method :read_time_parameter_value_with_date_string_and_time_string do |name, values_hash_from_param|
      if values_hash_from_param.keys.size == 2 then
        # TODO: use the all important locale!
        parse_format = "%m/%d/%Y %I:%M %p"
      
        begin
          Time.strptime(values_hash_from_param.values.join(' '), parse_format)
        rescue ArgumentError
          nil # It was an invalid date. Another option is to raise something here.
        end
      else
        read_time_parameter_value_without_date_string_and_time_string(name, values_hash_from_param)
      end
    end
    
    base.alias_method_chain :read_time_parameter_value, :date_string_and_time_string
  end
end

ActiveRecord::Base.class_eval { include SaneDatetimes }