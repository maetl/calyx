module Calyx
  class Mapping
    def initialize
      @key = "key"
      @value = "value"
    end

    def call(input)
      if @key == input then @value
      else
        ""
      end
    end
  end
end
