module FormtasticHacks
  def sane_datetime_input(method, options)

    inputs = [ :date, :hour, :separator, :minute, :ampm ]

    inputs_capture = ''
    hidden_fields_capture = ''

    # Gets the datetime object. It can be a Fixnum, Date or Time, or nil.
    datetime     = @object ? @object.send(method) : nil
    html_options = (options.delete(:input_html) || {}).with_indifferent_access

    inputs.each_index do |index|
			input = inputs[index]
      html_id    = generate_html_id(method, "#{index}s")
      field_name = "#{method}(#{index}s)"
      if options["discard_#{input}".intern]
        break if time_inputs.include?(input)

        hidden_value = datetime.respond_to?(input) ? datetime.send(input) : datetime
        hidden_fields_capture << template.hidden_field_tag("#{@object_name}[#{field_name}]", (hidden_value || 1), :id => html_id)
      else
        this_html_options = html_options[input] ? html_options.merge(html_options.delete(input)) : html_options
        # item_label_text = I18n.t(input.to_s, :default => input.to_s.humanize, :scope => [:datetime, :prompts])
				
				case input
					when :separator
						inputs_capture << template.hidden_field_tag("#{@object_name}[#{field_name}]", ':')
					when :hour
						hour = (datetime.hour % 12)
						hour = 12 if hour == 0
						inputs_capture << template.select_tag("#{@object_name}[#{field_name}]", template.options_for_select((1..12).to_a,hour), this_html_options.merge(:id => html_id))
					when :minute
						inputs_capture << template.select_tag("#{@object_name}[#{field_name}]", template.options_for_select((0..59).to_a.collect{|i| "%02d" % i },datetime.min), this_html_options.merge(:id => html_id))
					when :ampm
						am_pm = (datetime.hour >= 12) ? 'PM' : 'AM'
		       inputs_capture << template.select_tag("#{@object_name}[#{field_name}]", template.options_for_select(['AM','PM'],am_pm), this_html_options.merge(:id => html_id))
					when :date
						inputs_capture << template.text_field_tag("#{@object_name}[#{field_name}]", datetime.to_date, this_html_options.merge(:id => html_id))
				end
      end
    end

    self.label(method, options_for_label(options)) + hidden_fields_capture + inputs_capture
  end
end
