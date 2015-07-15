
include Gosu
class GameOver
	
	def initialize(window)
		@window = window
		@background = Image.new(@window, "media/gameover.png", false)
		Gosu::Song.current_song().stop
		@muerto= Sample.new(@window, "media/dead.ogg")
		@muerto.play
	end
	
	def button_down(id)
		if id == KbReturn
			@window.scene = Title.new(@window)
		end
	end
	
	def update
	end
	
	def draw
		@background.draw(0,0,ZOrder::Suelo)
	end
	
end
