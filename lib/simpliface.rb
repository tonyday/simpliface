# frozen_string_literal: true

require 'simpliface/version'

require 'active_support'
require 'active_support/core_ext/string/inflections'

# Add simple class-level interface to _service_ objects and hide the default
# creation method (`new`) so that clients must use the exposed API.
module Simpliface
  extend ActiveSupport::Concern

  class_methods do
    def call(**args)
      new(**args).send(:call)
    end

    attr_writer :mandatory_arguments, :optional_arguments

    def arguments(*mandatory_arguments, **optional_arguments)
      self.mandatory_arguments = mandatory_arguments
      self.optional_arguments = optional_arguments
      all_argument_names.each { |name| attr_accessor name }
    end

    def mandatory_arguments
      @mandatory_arguments ||= []
    end

    def optional_arguments
      @optional_arguments ||= {}
    end

    def all_argument_names
      mandatory_arguments + optional_arguments.keys
    end
  end

  included do
    # Prevent direct instantiation of instances (must be used via `call` API)
    class << self
      private :new # rubocop:disable Style/AccessModifierDeclarations
    end

    def initialize(*args, **kwargs)
      check_no_positional_arguments(args)
      check_no_extra_keyword_arguments(kwargs)
      check_all_mandatory_keyword_arguments(kwargs)
      assign_values(kwargs)
    end

    def check_no_positional_arguments(args)
      return if args.empty?

      raise ArgumentError,
            'Positional arguments not permitted'
    end

    def check_no_extra_keyword_arguments(kwargs)
      extras = kwargs.keys - self.class.all_argument_names
      return if extras.empty?

      raise ArgumentError,
            "Unexpected keyword #{'argument'.pluralize(extras.count)} #{extras}"
    end

    def check_all_mandatory_keyword_arguments(kwargs)
      missing = self.class.mandatory_arguments - kwargs.keys
      return if missing.empty?

      raise ArgumentError,
            "Missing keyword #{'argument'.pluralize(missing.count)} #{missing}"
    end

    def assign_values(kwargs)
      self.class.optional_arguments.merge(kwargs).each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end
