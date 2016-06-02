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
        require 'yaml'
        yaml = YAML.load(file)
        build_grammar(yaml)
      end

      def load_json(file)
        require 'json'
        json = JSON.parse(file)
        build_grammar(json)
      end

      private

      def build_grammar(rules)
        Calyx::Grammar.new do
          rules.each do |label, productions|
            rule(label, *productions)
          end
        end
      end
    end
  end
end
