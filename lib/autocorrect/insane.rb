require 'autocorrect/common'

module Autocorrect
  module Insane
    include Autocorrect::Common

    def method_missing(method, *args, &block)
      # Cargo-culted from whiny_nil.rb
      if method == :to_ary || method == :to_str
        super
      elsif guessed_method = guess_callable_method_for(method, args.length)
        method_missing_warning_for guessed_method, method, args
        send guessed_method, *args, &block
      elsif guessed_method = guess_closest_matched_name_method_for(method)
        raise_method_missing_with_mismatched_args_warning_for guessed_method, method, args, caller
      else
        super
      end
    end

    private
    def method_missing_warning_for(guessed_method, called_method, args)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call '#{print_method_with_args(called_method, args)}'.\n"
      message << "We suspect you meant '#{print_method_with_args(guessed_method, args)}' and so we're calling it on your behalf."
      STDERR.puts message
    end
  end
end

Object.send :include, Autocorrect::Insane
