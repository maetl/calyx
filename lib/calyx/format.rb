module Calyx
  # Helper methods for loading and initializing grammars from static files
  # on disk.
  module Format
    # Reads a file and parses its format, based on the given extension.
    #
    # Accepts a JSON or YAML file path, identified by its extension (`.json`
    # or `.yml`).
    #
    # @param [String] filename
    # @return [Calyx::Grammar]
    def self.load(filename)
      file = File.read(filename)
      extension = File.extname(filename)
      if extension == ".yml"
        self.load_yml(file)
      elsif extension == ".json"
        self.load_json(file)
      else
        raise Errors::UnsupportedFormat.new(filename)
      end
    end

    # Converts the given string of YAML data to a grammar instance.
    #
    # @param [String] data
    # @return [Calyx::Grammar]
    def self.load_yml(data)
      require 'yaml'
      self.build_grammar(YAML.load(data))
    end

    # Converts the given string of JSON data to a grammar instance.
    #
    # @param [String] data
    # @return [Calyx::Grammar]
    def self.load_json(data)
      require 'json'
      self.build_grammar(JSON.parse(data))
    end

    private

    def self.build_grammar(rules)
      Calyx::Grammar.new do
        rules.each do |label, productions|
          productions = [productions] unless productions.is_a?(Enumerable)
          define_rule(label, "Format#build_grammar", productions)
        end
      end
    end
  end
end
