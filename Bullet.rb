include Gosu
class Bullet
	attr_reader :kill_me
	attr_reader :x
	attr_reader :y
	attr_reader :direccion
	def initialize(window, direction)
		@window = window
		@direccion = direction
		@x = @window.scene.hero.x + 10 if direction == :up
		@x = @window.scene.hero.x + 20 if direction == :down
		@x = @window.scene.hero.x + 15 if direction != :up and direction != :down
		@y = @window.scene.hero.y + 24
		@z = ZOrder::Bullet
		@color = Color.new(255, 252, 255, 0)
		@speed = 16
		@kill_me = false
	end
	
	def in_zombie_rect(zombie)
		return true if @x >= zombie.x and @x <= zombie.x + zombie.pose.width and @y >= zombie.y and @y <= zombie.y + zombie.pose.height
		return false
	end
	def zombie_collision
		for i in 0...@window.scene.zombies.size
			next if not @window.scene.in_screen?(@window.scene.zombies[i])
			if in_zombie_rect(@window.scene.zombies[i])
				@window.scene.bloods << Blood.new(@window, @window.scene.zombies[i].x, @window.scene.zombies[i].y, :shot)
				@window.scene.zombies[i].life -= 1
				return i
			end
		end
			
		return false
	end
	
	def update
		if not (@window.scene.screen_x..@window.scene.screen_x+800).include? @x or not (@window.scene.screen_y..@window.scene.screen_y+600).include? @y
			@kill_me = true 
			return
		end
		case @direccion
			when :left
				for i in 0...@speed
					if zombie_collision != false or @window.scene.spriteset.solid(@x, @y)
						@kill_me = true
						return
					else
						@x -= 1
					end
				end
			when :right
				for i in 0...@speed
					if zombie_collision != false or @window.scene.spriteset.solid(@x, @y)
						@kill_me = true
						return
					else
						@x += 1
					end
				end
			when :up
				for i in 0...@speed
					if zombie_collision != false or @window.scene.spriteset.solid(@x, @y)
						@kill_me = true
						return
					else
						@y -= 1
					end
				end
			when :down
				for i in 0...@speed
					if zombie_collision != false or @window.scene.spriteset.solid(@x, @y)
						@kill_me = true
						return
					else
						@y += 1
					end
				end
		end
	end
	
	def draw
		@window.draw_line(@x-@window.scene.screen_x, @y-@window.scene.screen_y, @color, @x-@window.scene.screen_x+1, @y-@window.scene.screen_y+1, @color, @z)
	end

end