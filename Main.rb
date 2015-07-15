 $: << "."
 begin
require 'rubygems'
require 'gosu'
require 'zlib'
rescue LoadError
require 'lib/gosu'
end
include Gosu
require 'Window.rb'
require 'ZOrder.rb'
require 'FPSCounter.rb'
require 'Tilemap.rb'
require 'Title.rb'
require 'GameOver.rb'
require 'Map.rb'
require 'Hero.rb'
require 'Zombie.rb'
require 'Bullet.rb'
require 'Blood.rb'   
require 'Ammo.rb'

#puts "fullscreen? y/n"
#case gets.chomp
#	when /(y|Y)/
#		fullscreen = true
#	when /(n|N)/
#		fullscreen = false
#end
window = Game_Window.new
window.show