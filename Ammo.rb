include Gosu
class Ammo
	attr_reader :kill_me
	attr_reader :x
	attr_reader :y
	def initialize(window, x, y, size)
		@window = window
		@x = ((x-1)*32)
		@y = ((y-1)*32)-24
		@size = size
		@z = ZOrder::Bullet
		@image = Image.new(@window, "media/bullets.png", false)
		@kill_me = false
	end
	
	def in_hero_rect
		return true if @x >= @window.scene.hero.x - 25 and @x <= @window.scene.hero.x + @window.scene.hero.pose.width + 5 and @y >= @window.scene.hero.y - 20 and @y <= @window.scene.hero.y + @window.scene.hero.pose.height + 5
		return false
	end
	
	def update
		if in_hero_rect
			@kill_me = true
			@window.scene.magazines += @size
			@window.scene.get_ammo.play
		end
	end
	
	def draw
		@image.draw(@x - @window.scene.screen_x,@y - @window.scene.screen_y, @z)
	end
end