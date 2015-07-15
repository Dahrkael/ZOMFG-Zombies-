
include Gosu

class Zombie
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z
	attr_accessor :direccion
	attr_accessor :life
	attr_reader :pose
	def initialize(window, x, y)
		@window = window
		@x = ((x-1)*32)
		@y = ((y-1)*32)-24
		@z = ZOrder::Zombie
		@poses = Image.load_tiles(@window, "media/zoomby"+rand(3).to_s+".png", 40, 56, false)
		#@poses = Image.load_tiles(@window, "media/zoom.png", 40, 56, false)
		@pose = @poses[0]
		@direccion = :standing
		@speed = 1.5
		@delay = 30
		@sounds ||= [Sample.new(@window, "media/zombie_attack1.ogg"), Sample.new(@window, "media/zombie_attack2.ogg")]
		@hit ||= Sample.new(@window, "media/hit.ogg")
		@life = 7
	end
	def walk
			case @direccion
				when :up
						@y -= @speed
				when :down
						@y += @speed
				when :left
						@x -= @speed
				when :right
						@x += @speed
			end
		return #[@x, @y]
	end
	
	def in_hero_rect
		return true if @x >= @window.scene.hero.x - 25 and @x <= @window.scene.hero.x + @window.scene.hero.pose.width + 5 and @y >= @window.scene.hero.y - 20 and @y <= @window.scene.hero.y + @window.scene.hero.pose.height - 5
		return false
	end
	
	def attack_hero
		if in_hero_rect and @delay <= 0
			@window.scene.hero.life -= 1
			@hit.play
			@sounds[rand(@sounds.size)].play(0.3)
			@delay = 30
			return true
		end
		return false
	end
	
	def draw
		if @direccion == :left
			if milliseconds / 175 % 4 == 0
				@pose = @poses[4]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[5]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[6]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[7]
			end
		elsif @direccion == :right
				if milliseconds / 175 % 4 == 0
					@pose = @poses[8]
				elsif milliseconds / 175 % 4 == 1
					@pose = @poses[9]
				elsif milliseconds / 175 % 4 == 2
					@pose = @poses[10]
				elsif milliseconds / 175 % 4 == 3
					@pose = @poses[11]
				end
		elsif @direccion == :up
			if milliseconds / 175 % 4 == 0
					@pose = @poses[12]
				elsif milliseconds / 175 % 4 == 1
					@pose = @poses[13]
				elsif milliseconds / 175 % 4 == 2
					@pose = @poses[14]
				elsif milliseconds / 175 % 4 == 3
					@pose = @poses[15]
				end
		elsif @direccion == :down
			if milliseconds / 175 % 4 == 0
					@pose = @poses[0]
				elsif milliseconds / 175 % 4 == 1
					@pose = @poses[1]
				elsif milliseconds / 175 % 4 == 2
					@pose = @poses[2]
				elsif milliseconds / 175 % 4 == 3
					@pose = @poses[3]
				end
		end
		@pose.draw(@x - @window.scene.screen_x,@y - @window.scene.screen_y, @z)
	end
	
	def update
		@delay -= 1
		@x_pies = @x + (@pose.width/2)
		@y_pies = @y + @pose.height
		if @window.scene.hero.x < @x
			@direccion = :left
			if not @window.scene.spriteset.solid(@x_pies-16, @y_pies)
				if not @window.scene.zombie_or_hero_infront?(self)
					walk 
				else
					attack_hero
				end
				
			end
		end
		if @window.scene.hero.x > @x
			@direccion = :right
			if not @window.scene.spriteset.solid(@x_pies+16, @y_pies)
				if not @window.scene.zombie_or_hero_infront?(self)
					walk 
				else
					attack_hero
				end
			end
		end
		if @window.scene.hero.y < @y
			@direccion = :up
			if not @window.scene.spriteset.solid(@x_pies, @y_pies-16)
				if not @window.scene.zombie_or_hero_infront?(self)
					walk 
				else
					attack_hero
				end
			end 
		end
		if @window.scene.hero.y > @y
			@direccion = :down
			if not @window.scene.spriteset.solid(@x_pies, @y_pies+6)
				if not @window.scene.zombie_or_hero_infront?(self)
					walk 
				else
					attack_hero
				end
			end
		end
	end
end