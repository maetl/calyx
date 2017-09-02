module Calyx
  class Options
    DEFAULTS = {
      strict: true
    }

    def initialize(opts={})
      @options = DEFAULTS.merge(opts)
    end

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

    def rand
      rng.rand
    end

    def strict?
      @options[:strict]
    end

    def merge(opts)
      Options.new(@options.merge(opts.to_h))
    end

    def to_h
      @options
    end
  end
end
