module Calyx
  class Modifiers
    def extend_with(name)
      extend name
    end

    def transform(name, value)
      if respond_to?(name)
        send(name, value)
      elsif value.respond_to?(name)
        value.send(name)
      else
        value
      end
    end
  end
end
