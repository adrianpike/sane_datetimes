module FormtasticHacks
  def sane_datetime_input(method, options)

    inputs = [ :date, :time ]

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
				
				case input
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

						inputs_capture << template.select_tag("#{@object_name}[#{field_name}]", template.options_for_select(select_options,decoded_date), this_html_options.merge(:id => html_id))

					when :date
						inputs_capture << template.text_field_tag("#{@object_name}[#{field_name}]", datetime.to_date, this_html_options.merge(:id => html_id))
				end
      end
    end

    self.label(method, options_for_label(options)) + hidden_fields_capture.html_safe + inputs_capture.html_safe
  end
end
