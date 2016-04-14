require "calyx"

tiny_woodland = Calyx::Grammar.new do
  start :field
  field (0..7).map { "{row}{br}" }.join
  row (0..18).map { "{point}" }.join
  point [:trees, 0.2], [:foliage, 0.25], [:flowers, 0.05], [:space, 0.5]
  trees "🌲", "🌳"
  foliage "🌿", "🌱"
  flowers "🌷", "🌻", "🌼"
  space " "
  br "\n"
end

puts tiny_woodland.generate
