require 'pathname'

module Calyx
  # Helper methods for loading and initializing grammars from static files
  # on disk.
  module Format
    class Trace
      def initialize(match_symbol, filename, contents)
        @match_symbol = match_symbol
        @filename = Pathname.new(filename)
        @contents = contents
      end

      def path
        @filename.basename
      end

      def absolute_path
        @filename.expand_path
      end

      def lineno
        line_number = 0
        @contents.each_line do |line|
          line_number += 1
          return line_number if line =~ @match_symbol
        end
      end
    end

    class JSONGrammar
      def initialize(filename)
        require 'json'
        @filename = filename
        @contents = File.read(@filename)
        @rules = JSON.parse(@contents)
      end

      def each_rule(&block)
        @rules.each do |rule, productions|
          yield rule, productions, Trace.new(/("#{rule}")(\s*)(:)/, @filename, @contents)
        end
      end
    end

    class YAMLGrammar
      def initialize(filename)
        require 'yaml'
        @filename = filename
        @contents = File.read(@filename)
        @rules = YAML.load(@contents)
      end

      def each_rule(&block)
        @rules.each do |rule, productions|
          yield rule, productions, Trace.new(/#{rule}:/, @filename, @contents)
        end
      end
    end

    # Reads a file and parses its format, based on the given extension.
    #
    # Accepts a JSON or YAML file path, identified by its extension (`.json`
    # or `.yml`).
    #
    # @param [String] filename
    # @return [Calyx::Grammar]
    def self.load(filename)
      extension = File.extname(filename)

      if extension == ".yml"
        self.load_yml(filename)
      elsif extension == ".json"
        self.load_json(filename)
      else
        raise Errors::UnsupportedFormat.new(filename)
      end
    end

    # Converts the given string of YAML data to a grammar instance.
    #
    # @param [String] filename
    # @return [Calyx::Format::YAMLGrammar]
    def self.load_yml(filename)
      self.build_grammar(YAMLGrammar.new(filename))
    end

    # Converts the given string of JSON data to a grammar instance.
    #
    # @param [String] filename
    # @return [Calyx::Format::JSONGrammar]
    def self.load_json(filename)
      self.build_grammar(JSONGrammar.new(filename))
    end

    private

    def self.build_grammar(grammar_format)
      Calyx::Grammar.new do
        grammar_format.each_rule do |label, productions, trace|
          productions = [productions] unless productions.is_a?(Enumerable)
          define_rule(label, trace, productions)
        end
      end
    end
  end
end
