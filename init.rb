$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'sane_datetimes'
ActiveRecord::Base.class_eval { include SaneDatetimes }