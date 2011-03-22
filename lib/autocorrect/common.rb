require 'text/levenshtein'

module Autocorrect
  module Common
    private
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

    def print_method_with_args(method, args)
      "#{method.to_s}(#{args.map { |arg| arg.inspect }.join(", ")})"
    end

    def raise_method_missing_with_mismatched_args_warning_for(guessed_method, called_method, args, block_present, with_caller = nil)
      message = "You have called a method that doesn't exist.\n"
      message << "You tried to call '#{print_method_with_args(called_method, args)}'.\n"
      message << "We suspect you meant '#{guessed_method}' but you got the number of arguments wrong too (#{method(guessed_method).arity} expected, got #{args.length})."
      raise NoMethodError, message, with_caller || caller
    end
  end
end
