
include Gosu

class Hero
	attr_accessor :x
	attr_accessor :y
	attr_accessor :z
	attr_accessor :direccion
	attr_reader :pose
	attr_accessor :life
	def initialize(window, x, y)
		@window = window
		@x = ((x-1)*32)
		@y = ((y-1)*32)-24
		@z = ZOrder::Hero
		@poses = Image.load_tiles(@window, "media/hero2.png", 32, 48, false)
		@pose = @poses[0]
		@direccion = :down
		@speed = 4
		@life = 10
		@step_delay = 20
		@step ||= Sample.new(@window, "media/step.ogg")
	end
	def walk
		case @direccion
			when :up
				for i in 0...@speed
					@y -= 1 if not @window.scene.zombie_or_hero_infront?(self)
				end
			when :down
				for i in 0...@speed
					@y += 1 if not @window.scene.zombie_or_hero_infront?(self)
				end
			when :left
				for i in 0...@speed
					@x -= 1 if not @window.scene.zombie_or_hero_infront?(self)
				end
			when :right
				for i in 0...@speed
					@x += 1 if not @window.scene.zombie_or_hero_infront?(self)
				end
		end
		return [@x, @y]
	end
	
	def draw
		if @direccion == :left and @window.button_down?(Button::KbLeft)
			if milliseconds / 175 % 4 == 0
				@pose = @poses[4]
			elsif milliseconds / 175 % 4 == 1
				@pose = @poses[5]
			elsif milliseconds / 175 % 4 == 2
				@pose = @poses[6]
			elsif milliseconds / 175 % 4 == 3
				@pose = @poses[7]
			end
		elsif @direccion == :right and @window.button_down?(Button::KbRight)
				if milliseconds / 175 % 4 == 0
					@pose = @poses[8]
				elsif milliseconds / 175 % 4 == 1
					@pose = @poses[9]
				elsif milliseconds / 175 % 4 == 2
					@pose = @poses[10]
				elsif milliseconds / 175 % 4 == 3
					@pose = @poses[11]
				end
		elsif @direccion == :up and @window.button_down?(Button::KbUp)
			if milliseconds / 175 % 4 == 0
					@pose = @poses[12]
				elsif milliseconds / 175 % 4 == 1
					@pose = @poses[13]
				elsif milliseconds / 175 % 4 == 2
					@pose = @poses[14]
				elsif milliseconds / 175 % 4 == 3
					@pose = @poses[15]
				end
		elsif @direccion == :down and @window.button_down?(Button::KbDown)
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
		@step_delay -= 1
		@x_pies = @x + (@pose.width/2)
		@y_pies = @y + @pose.height
		if @window.button_down?(Button::KbLeft) and @x > 0 - @window.scene.screen_x
			@direccion = :left
			if not @window.scene.spriteset.solid(@x_pies-16, @y_pies)
				walk
				if @step_delay <= 0
					@step.play
					@step_delay = 20
				end
			end
		elsif @window.button_down?(Button::KbRight) and @x < (@window.scene.width * 32) - @pose.width
			@direccion = :right
			if not @window.scene.spriteset.solid(@x_pies+16, @y_pies)
				walk
				if @step_delay <= 0
					@step.play
					@step_delay = 20
				end
			end
		elsif @window.button_down?(Button::KbUp) and @y > 0 - @window.scene.screen_y
			@direccion = :up
			if not @window.scene.spriteset.solid(@x_pies, @y_pies-16)
				walk
				if @step_delay <= 0
					@step.play
					@step_delay = 20
				end
			end
		elsif @window.button_down?(Button::KbDown) and @y < (@window.scene.height * 32) - @pose.height
			@direccion = :down
			if not @window.scene.spriteset.solid(@x_pies, @y_pies+6)
				walk
				if @step_delay <= 0
					@step.play
					@step_delay = 20
				end
			end
		else 
			case @direccion
				when :left
					@pose = @poses[4]
				when :right
					@pose = @poses[9]
				when :up
					@pose = @poses[12]
				when :down
					@pose = @poses[0]
			end
			#@direccion = :standing
		end
	end
end