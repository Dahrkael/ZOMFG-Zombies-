include Gosu

class Game_Window < Gosu::Window
	attr_accessor :scene
	attr_accessor :initial_position
	attr_accessor :initial_zombies
	attr_accessor :initial_ammos
	def initialize
		width = 800
		height = 600
		#fullscreen = Fullscreen::Enabled
		super(width, height, false)#fullscreen)
		self.caption = "ZOMFG!!! ZOMBIEEEEES!!!!!11!oneone!1"
		
		@fpscounter = FPSCounter.new(self)
		@initial_position = []
		@initial_zombies = []
		@initial_ammos = []
		@scene = Title.new(self)
	end
	
	def button_down(id)
		@scene.button_down(id)
		if id == Button::KbF
			@fpscounter.show_fps = !@fpscounter.show_fps
		end
	end
	

	def update
		@fpscounter.update
		@scene.update
	end
	
	def draw
		@scene.draw
	end
	
end
