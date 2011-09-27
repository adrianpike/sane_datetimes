class SaneDatetimeInput
  include Formtastic::Inputs::Base
  include Formtastic::Inputs::Base::Timeish

  def fragments
    [:date, :time]
  end
  
  def positions
    { :date => 1, :time => 2 }
  end
  
  # So close to being able to just reuse Timish, unfortunately there's no label_html used in their fragment block
  def to_html
    input_wrapping do
      label_html <<
      fragments_wrapping do
        hidden_fragments <<
        fragments_label <<
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
        decoded_date = datetime.strftime('%I:%M %p') rescue nil

        # include_blank?
        template.select_tag(object_name + '[' + fragment_name(fragment) + ']', template.options_for_select(select_options, value.strftime('%I:%M %p')), input_html_options.merge(:id => fragment_id(fragment)))
      when :date
        template.text_field_tag(object_name + '[' + fragment_name(fragment) + ']', I18n.l(value.to_date, :format => :short), input_html_options.merge(:id => fragment_id(fragment)))
        #template.text_field_tag("#{@object_name}[#{field_name}]", datetime ? I18n.l(datetime.to_date, :format => :short) : '', this_html_options.merge(:id => html_id))
    end
  end
    
  # TODO: push this back up to Formtastic
  def fragment_id(fragment)
    "#{input_html_options[:id]}_#{position(fragment)}s"
  end
  
  def fragment_name(fragment)
    "#{method}(#{position(fragment)}s)"
  end
  
  
  #   # Gets the datetime object. It can be a Fixnum, Date or Time, or nil.
  #   datetime     = @object ? @object.send(method) : nil
  #   html_options = (options.delete(:input_html) || {}).with_indifferent_access
  #   
  #   inputs.each_index do |index|
  #     input = inputs[index]
  #     html_id    = generate_html_id(method, "#{index}s")
  #     field_name = "#{method}(#{index}s)"

  #       this_html_options = html_options[input] ? html_options.merge(html_options.delete(input)) : html_options
  #         
  #         case input
  #           when :time
  #             select_options = (0..23).to_a.collect{|i|
  #               if i==0
  #                 ['12:00 AM','12:30 AM']
  #               else
  #                 am = i/12.0 < 1
  #                 if am then
  #                   ["#{"%02d" % (i)}:00 AM", "#{"%02d" % (i)}:30 AM"]
  #                 else
  #                   if i == 12
  #                     ["12:00 PM", "12:30 PM"] 
  #                   else
  #                     ["#{"%02d" % (i-12)}:00 PM", "#{"%02d" % (i-12)}:30 PM"]
  #                   end
  #                 end
  #               end
  #               }.flatten
  #             decoded_date = datetime.strftime('%I:%M %p') rescue nil
  # 
  #             inputs_capture << template.select_tag("#{@object_name}[#{field_name}]", template.options_for_select(select_options,decoded_date), this_html_options.merge(:id => html_id))
  # 
  #           when :date
  #             inputs_capture << template.text_field_tag("#{@object_name}[#{field_name}]", datetime ? I18n.l(datetime.to_date, :format => :short) : '', this_html_options.merge(:id => html_id))
  #         end

  #   end
  # end
  
end