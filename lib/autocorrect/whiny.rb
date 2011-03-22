module Autocorrect
  module Whiny
    def method_missing(method, *args, &block)
      if method == :to_ary || method == :to_str
        super
      elsif guessed_method = guess_callable_method_for(method, args.length, block_given?)
        raise_method_missing_warning_for guessed_method, method, caller, args.empty? ? nil : args, block_given?
      elsif guessed_method = guess_closest_matched_name_method_for(method)
        raise_method_missing_warning_for guessed_method, method, caller
      else
        super
      end
    end

    def guess_callable_method_for(method, arity, block_supplied)
      "horses"
    end

    def guess_closest_matched_name_method_for(method)
      "kangaroos"
    end

    def raise_method_missing_warning_for(guessed_method, called_method, with_caller = nil, args = nil, block_present = false)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call #{print_method_with_args(called_method, args, block_present)}.\n"
      message << "We suspect you meant #{print_method_with_args(guessed_method, args, block_present)}.\n"
      raise NoMethodError, message, with_caller || caller
    end

    def print_method_with_args(method, args = nil, block_present = false)
      "#{method.to_s}(#{args.nil? ? '' : args.map { |arg| arg.inspect }.join(", ")}#{block_present ? ", &block" : ""})"
    end
  end
end

Object.send :include, Autocorrect::Whiny
