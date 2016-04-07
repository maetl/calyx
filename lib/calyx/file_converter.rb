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
        create_calyx_class(yaml)
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
        create_calyx_class(json)
      end

      def create_calyx_class(hash)
        klass = Class.new(Calyx::Grammar)
        hash.each do |rule_name, rule_productions|
          klass.send(rule_name, *rule_productions)
        end
        klass.new
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