require 'text/levenshtein'

module Autocorrect
  module Whiny
    def method_missing(method, *args, &block)
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

    def guess_callable_method_for(method, arity)
      nearest_methods(method).find { |possible_method| [arity, -1].include? method(possible_method).arity }
    end

    def guess_closest_matched_name_method_for(method)
      nearest_methods(method)[0]
    end

    def nearest_methods(method)
      potential_methods = methods_grouped_by_distance(method)
      nearest_distance = potential_methods.keys.sort[0]
      potential_methods[nearest_distance]
    end

    def methods_grouped_by_distance(method)
      methods.group_by { |potential_method| Text::Levenshtein.distance(potential_method.to_s, method.to_s) }
    end

    def raise_method_missing_warning_for(guessed_method, called_method, args, with_caller = nil)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call '#{print_method_with_args(called_method, args)}'.\n"
      message << "We suspect you meant '#{print_method_with_args(guessed_method, args)}'.\n"
      raise NoMethodError, message, with_caller || caller
    end

    def raise_method_missing_with_mismatched_args_warning_for(guessed_method, called_method, args, block_present, with_caller = nil)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call '#{print_method_with_args(called_method, args)}'.\n"
      message << "We suspect you meant '#{guessed_method}' but you got the number of arguments wrong too (#{method(guessed_method).arity} expected, got #{args.length}).\n"
      raise NoMethodError, message, with_caller || caller
    end

    def print_method_with_args(method, args)
      "#{method.to_s}(#{args.map { |arg| arg.inspect }.join(", ")})"
    end
  end
end

Object.send :include, Autocorrect::Whiny
