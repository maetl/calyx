module Calyx
  class Modifiers
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
