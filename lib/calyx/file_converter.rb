require 'yaml'
require 'json'

module Calyx
  class Grammar
    class << self
      def load(filename)
        file = File.read(filename)
        extension = File.extname(filename)
        if extension == ".yml"
          load_yml(file)
        elsif extension == ".json"
          load_json(file)
        else
          raise "Cannot convert #{extension} files."
        end
      end

      def load_yml(file)
        yaml = YAML.load(file)
        build_grammar(yaml)
      end

      def load_json(file)
        json = JSON.parse(file)
        json.each do |key, value|
          if value[0] == ":"
            json[key] = convert_to_symbol(value)
          elsif value.is_a?(Array)
            json[key] = parse_array(value)
          end
        end
        build_grammar(json)
      end

      def build_grammar(hash)
        Calyx::Grammar.new do
          hash.each do |rule_name, rule_productions|
            rule(rule_name, *rule_productions)
          end
        end
      end

      def parse_array(array)
        array.map do |element|
          if element[0] == ":"
            convert_to_symbol(element)
          else
            element
          end
        end
      end

      def convert_to_symbol(value)
        value[1..-1].to_sym
      end
    end
  end
end
