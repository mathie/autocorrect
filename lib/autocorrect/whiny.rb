require 'autocorrect/common'

module Autocorrect
  module Whiny
    include Autocorrect::Common

    def method_missing(method, *args, &block)
      # Cargo-culted from whiny_nil.rb
      if method == :to_ary || method == :to_str
        super
      elsif guessed_method = guess_callable_method_for(method, args.length)
        raise_method_missing_warning_for guessed_method, method, args, caller
      elsif guessed_method = guess_closest_matched_name_method_for(method)
        raise_method_missing_with_mismatched_args_warning_for guessed_method, method, args, caller
      else
        super
      end
    end

    private
    def raise_method_missing_warning_for(guessed_method, called_method, args, with_caller = nil)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call '#{print_method_with_args(called_method, args)}'.\n"
      message << "We suspect you meant '#{print_method_with_args(guessed_method, args)}'.\n"
      raise NoMethodError, message, with_caller || caller
    end
  end
end

Object.send :include, Autocorrect::Whiny
