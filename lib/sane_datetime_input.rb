class SaneDatetimeInput
  include Formtastic::Inputs::Base
  include Formtastic::Inputs::Base::Timeish

  def fragments
    [:date, :time]
  end
  
  def positions
    { :date => 1, :time => 2 }
  end
  
  # So close to being able to just reuse core Timeish, unfortunately there's no label_html used in their fragment block
  def to_html
    input_wrapping do
      label_html <<
      fragments_wrapping do
        hidden_fragments <<
        template.content_tag(:ol,
          fragments.map do |fragment|
            fragment_wrapping do
              fragment_label_html(fragment) <<
              fragment_input_html(fragment)
            end
          end.join.html_safe, # TODO is this safe?
          { :class => 'fragments-group' } # TODO refactor to fragments_group_wrapping
        )
      end
    end
  end
  
  def fragment_label_html(fragment)
    ''.html_safe
  end
  
  def fragment_input_html(fragment)
    case fragment
      when :time
        select_options = (0..23).to_a.collect{|i|
          if i==0
            ['12:00 AM','12:30 AM']
          else
            am = i/12.0 < 1
            if am then
              ["#{"%02d" % (i)}:00 AM", "#{"%02d" % (i)}:30 AM"]
            else
              if i == 12
                ["12:00 PM", "12:30 PM"] 
              else
                ["#{"%02d" % (i-12)}:00 PM", "#{"%02d" % (i-12)}:30 PM"]
              end
            end
          end
          }.flatten
        formatted_value = value.strftime('%I:%M %p') rescue nil
        select_options.unshift(formatted_value) if formatted_value

        template.select_tag(object_name + '[' + fragment_name(fragment) + ']', template.options_for_select(select_options, formatted_value), input_html_options.merge(:id => fragment_id(fragment)))
      when :date
        template.text_field_tag(object_name + '[' + fragment_name(fragment) + ']', value ? (I18n.l(value.to_date)) : '', input_html_options.merge(:id => fragment_id(fragment)))
    end
  end
    
  # TODO: push this back up to Formtastic
  def fragment_id(fragment)
    "#{input_html_options[:id]}_#{position(fragment)}s"
  end
  
  def fragment_name(fragment)
    "#{method}(#{position(fragment)}s)"
  end
  
end