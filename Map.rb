include Gosu

class Map
	attr_reader :screen_x
	attr_reader :screen_y
	attr_reader :spriteset
	attr_reader :width
	attr_reader :height
	attr_reader :hero
	attr_accessor :zombies
	attr_accessor :bullets
	attr_accessor :ammos
	attr_accessor :magazines
	attr_accessor :bloods
	attr_reader :blood_image
	attr_reader :blood_image2
	attr_accessor :initial_position
	attr_reader :get_ammo
	def initialize(window,map, tileset)
		@window = window
		@map = map
		@tileset = tileset
		@screen_x = 0
		@screen_y = 0
		@spriteset = Tilemap.new(@window, @map, @tileset)
		@width = @spriteset.capas[:suelo][:width]
		@height = @spriteset.capas[:suelo][:height]
		@initial_position = @window.initial_position
		@hero = Hero.new(@window, @initial_position[1], @initial_position[0])
		
		@font = Font.new(@window, "Arial", 22)
		@font2 = Font.new(@window, "Arial", 30)
		@image_life = Image.new(@window, "media/life.png", false)
		@image_bullets = Image.new(@window, "media/smg.png", false)
		@image_magazines = Image.new(@window, "media/magazines.png", false)
		@image_bullet = Image.new(@window, "media/bullet.png", false)
		@blood_image = Image.load_tiles(@window, "media/sangre.png", 32, 32, false)
		@blood_image2 = Image.load_tiles(@window, "media/sangre2.png", 32, 32, false)
		
		@bullets = []
		@zombies = []
		@bloods = []
		@magazines = 10
		@delay = 0
		@muerto = false
		@bcharge = 20
		
		@ammos = @window.initial_ammos
		@window.initial_ammos = nil
		@zombies = @window.initial_zombies
		@window.initial_zombies = nil
		
		#@ambiente ||= Song.new(@window, "media/ambience.ogg")
		#@ambiente.play(true)
		@action ||= Song.new(@window, "media/action.ogg")
		#@action.play(true)
		@peace ||= Song.new(@window, "media/peace.ogg")
		@reload ||= Sample.new(@window, "media/reload.ogg")
		@shoot ||= Sample.new(@window, "media/machinegun.ogg")
		@empty ||= Sample.new(@window, "media/noammo.ogg")
		@get_ammo ||= Sample.new(@window, "media/getammo.ogg")
	end
	
	def zombie_or_hero_infront?(character)
		case character.direccion
			when :left
				for i in 0...@zombies.size
					next if not in_screen?(@zombies[i])
					return true if @zombies[i].x == character.x - 24 and character.y >= @zombies[i].y - 20 and character.y <= @zombies[i].y + 20
				end
				return true if @hero.x == character.x - 24 and character.y >= @hero.y and character.y <= @hero.y + 20
				return false
			when :right
				for i in 0...@zombies.size
					next if not in_screen?(@zombies[i])
					return true if @zombies[i].x == character.x + 24 and character.y >= @zombies[i].y - 20 and character.y <= @zombies[i].y + 20
				end
				return true if @hero.x == character.x + 24 and character.y >= @hero.y - 20 and character.y <= @hero.y + 20
				return false
			when :up
				for i in 0...@zombies.size
					next if not in_screen?(@zombies[i])
					return true if @zombies[i].y == character.y - 16 and character.x >= @zombies[i].x - 20 and character.x <= @zombies[i].x + 20
				end
				return true if @hero.y == character.y - 16 and character.x >= @hero.x - 20 and character.x <= @hero.x + 20
				return false
			when :down
				for i in 0...@zombies.size
					next if not in_screen?(@zombies[i])
					return true if @zombies[i].y == character.y + 16 and character.x >= @zombies[i].x - 20 and character.x <= @zombies[i].x + 20
				end
				return true if @hero.y == character.y + 16 and character.x >= @hero.x - 20 and character.x <= @hero.x + 20
				return false
		end
	end
	
	def button_down(id)
		if id == KbR and @magazines >= 1
			@delay = 60
			@reload.play
			@bcharge = 20
			@magazines -= 1
		end
		if id = KbSpace and @bcharge <= 0
			@empty.play
		end
	end
	
	def update
		@moment = 0
		for i in 0...@zombies.size
			if in_screen?(@zombies[i])
				@moment += 1
			end
		end
		if @moment >= 10
			@peace.pause if @peace.playing?
			@action.play(true) unless @action.playing?	
			else
			@action.pause if @action.playing?
			@peace.play(true) unless @peace.playing?	
		end
		
		if @window.button_down?(Button::KbSpace) and @delay <= 0 and @bcharge >= 1
			@bullets.push(Bullet.new(@window, @hero.direccion))
			@shoot.play
			@delay = 6
			@bcharge -= 1
		end
		
		@delay -= 1 unless @delay <= 0
		
		#if @bcharge <= 0
		#	@delay = 60
		#	@reload.play
		#	@bcharge = 20
		#end
		
		@screen_x = [[@hero.x - 400, 0].max, @width * 32 - 800].min
		@screen_y = [[@hero.y - 300, 0].max, @height * 32 - 600].min
		
		@hero.update
		@bloods.each { |blood| blood.update if in_screen?(blood)
					@bloods.delete(blood) if blood.kill_me }
		@ammos.each { |ammo| ammo.update if in_screen?(ammo)
					@ammos.delete(ammo) if ammo.kill_me }
		@zombies.each { |zombie| if @hero.y > zombie.y then zombie.z = 5 else zombie.z = 7 end }
		@zombies.each { |zombie| zombie.update if in_screen?(zombie)
					if zombie.life <= 0
						@bloods << Blood.new(@window, zombie.x, zombie.y, :kill)
						@zombies.delete(zombie)
					end	}
		@bullets.each { |bullet| bullet.update
					@bullets.delete(bullet) if bullet.kill_me }
					
		if @hero.life <= 0 and @muerto == false
			@window.scene = GameOver.new(@window)
		end
	end
	
	def draw
		@spriteset.draw
		@hero.draw
		
		@bloods.each { |blood| blood.draw if in_screen?(blood) }
		@ammos.each { |ammo| ammo.draw if in_screen?(ammo) }
		@zombies.each { |zombie| zombie.draw if in_screen?(zombie) }
		@bullets.each { |bullet| bullet.draw }
					
		@image_life.draw(0, 0, ZOrder::GUI)
		@font.draw("Health: "+@hero.life.to_s, 55, 15, ZOrder::GUI) 
		
		@image_magazines.draw(400, 500, ZOrder::GUI)
		@font2.draw("x"+@magazines.to_s, 455, 510, ZOrder::GUI) 
		
		@image_bullets.draw(400, 550, ZOrder::GUI)
		for i in 0...@bcharge
			@image_bullet.draw(468+(i*15), 550, ZOrder::GUI)
		end
	end
	def in_screen?(target)
		if target.x  < @window.scene.screen_x + 800 and target.x > @window.scene.screen_x - 32 and target.y < @window.scene.screen_y + 600 and target.y > @window.scene.screen_y - 32
			return true
		end
			return false
	end
end
