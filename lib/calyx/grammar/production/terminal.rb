module Calyx
  class Grammar
    module Production
      class Terminal
        def initialize(atom)
          @atom = atom
        end

        def evaluate
          @atom
        end
      end
    end
  end
end
