require 'roda'
require 'calyx'

class AnyGradient < Calyx::Grammar
  html '<body style="margin:0; padding:0">{svg}</body>'
  xml '<?xml version="1.0" encoding="utf-8"?>{svg}'
  svg '
    <svg width="100%"
         height="100%"
         version="1.1"
         xmlns="http://www.w3.org/2000/svg"
         xmlns:xlink="http://www.w3.org/1999/xlink">
      {defs}
      {rect}
    </svg>
  '
  defs '
    <defs>
      {linear_gradient}
    </defs>
  '
  linear_gradient '
    <linearGradient id="linearGradient-1">
      {stop_fixed}
      {stop_offset}
    </linearGradient>
  '
  stop_fixed '<stop stop-color="{stop_color}" offset="0%"></stop>'
  stop_offset '<stop stop-color="{stop_color}" offset="{offset}"></stop>'
  stop_color '#{hex_num}{hex_num}{hex_num}'
  hex_num '{hex_val}{hex_val}'
  hex_val '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
  offset '{tens}{ones}%'
  tens 3,4,5,6
  ones 1,2,3,4,5,6,7,8,9,0
  rect '
    <rect id="gradient"
          stroke="none"
          fill="url(#linearGradient-1)"
          fill-rule="evenodd"
          x="0"
          y="0"
          width="100%"
          height="100%"></rect>
  '
end

class Server < Roda
  route do |r|
    r.root do
      AnyGradient.new.generate(:html)
    end
  end
end

if STDOUT.tty?
  Rack::Server.start :app => Server
else
  STDOUT.puts AnyGradient.new.generate(:xml)
end
