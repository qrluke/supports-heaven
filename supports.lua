script_name("supports")
script_author("rubbishman")


local sampev = require 'lib.samp.events'


function main()
  if not isSampfuncsLoaded() or not isSampLoaded() then return end
  while not isSampAvailable() do wait(100) end
  while true do
    wait(0)
  end
end


function sampev.onServerMessage(color, text)
  sampAddChatMessage(text .. ' Цвет: '.. color, -1)
  return false
end
