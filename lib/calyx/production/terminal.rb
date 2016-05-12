module Calyx
  module Production
    class Terminal
      def initialize(atom)
        @atom = atom
      end

      def evaluate
        [:atom, @atom]
      end
    end
  end
end
