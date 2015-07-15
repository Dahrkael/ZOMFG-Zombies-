
include Gosu
class Title
	
	def initialize(window)
		@window = window
		@background = Image.new(@window, "media/title.png", false)
		#@cursor = Image.new(@window, "media/cursor.png", false)
		@loading = Image.new(@window, "media/loading.png", false)
		@cursor_play = Image.new(@window, "media/play.png", false)
		@cursor_exit = Image.new(@window, "media/exit.png", false)
		@alpha_color = Color.new(100, 255, 255, 255)
		@bgm ||= Song.new(@window, "media/title.ogg")
		@bgm.play(true)
		@cursor_position = :play
		@letsgo = 0
	end
	
	def button_down(id)
		if id == KbDown and @cursor_position == :play
			@cursor_position = :exit
		end
		if id == KbUp and @cursor_position == :exit
			@cursor_position = :play
		end
		if id == KbReturn
			if @cursor_position == :play
				@letsgo = 1
				@window.initial_ammos = []
				@window.initial_zombies = []
				@initial_ammos = []
			else
				exit
			end
		end
	end
	
	def update
		@letsgo += 1 if @letsgo != 0
		@window.scene = Map.new(@window,"prueba", "tileset.png") if @letsgo ==  60
	end
	
	def draw
		@background.draw(0,0,ZOrder::Suelo)
		case @cursor_position
			when :play
			#@cursor.draw(500,330,ZOrder::Suelo)
			@cursor_play.draw(25, 244, ZOrder::Suelo, 1, 1, @alpha_color, :default) 
			when :exit
			#@cursor.draw(60,540,ZOrder::Suelo)
			@cursor_exit.draw(454, 433, ZOrder::Suelo, 1, 1, @alpha_color, :default) 
		end
		@loading.draw(300,350,ZOrder::GUI) if @letsgo != 0
	end
	
end
