module Calyx
  # Provides access to configuration options while evaluating a grammar.
  class Options
    # These options are used by default if not explicitly provided during
    # initialization of the grammar.
    DEFAULTS = {
      strict: true
    }

    # Constructs a new options instance, merging the passed in options with the
    # defaults.
    #
    # @param [Hash, Calyx::Options] options
    def initialize(options={})
      @options = DEFAULTS.merge(options)
    end

    # Returns the internal random number generator instance. If a seed or random
    # instance is not passed-in directly, a new instance of `Random` is
    # initialized by default.
    #
    # @return [Random]
    def rng
      unless @options[:rng]
        @options[:rng] = if @options[:seed]
          Random.new(@options[:seed])
        else
          Random.new
        end
      end

      @options[:rng]
    end

    # Returns the next pseudo-random number in the sequence defined by the
    # internal random number generator state.
    #
    # The value returned is a floating point number between 0.0 and 1.0,
    # including 0.0 and excluding 1.0.
    #
    # @return [Float]
    def rand
      rng.rand
    end

    # True if the strict mode option is enabled. This option defines whether or
    # not to raise an error on missing rules. When set to false, missing rules
    # are skipped over when the production is concatenated.
    #
    # @return [TrueClass, FalseClass]
    def strict?
      @options[:strict]
    end

    # Merges two instances together and returns a new instance.
    #
    # @param [Calyx::Options] options
    # @return [Calyx::Options]
    def merge(options)
      Options.new(@options.merge(options.to_h))
    end

    # Serializes instance data to a hash.
    #
    # @return [Hash]
    def to_h
      @options.dup
    end
  end
end
