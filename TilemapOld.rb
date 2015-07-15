
include Gosu

class Tilemap
	attr_reader :capas
	attr_reader :filename
	attr_reader :tileset_filename
	def initialize(window, filename, tileset)
		@window = window
		@filename = filename
		@tileset_filename = tileset
		@tileset = Image.load_tiles(@window, "media/"+tileset, 32, 32, true)
		@capas = Tileset::load_map(@window, filename)
	end
	
	def update
		for capa in [:suelo, :objetos, :tops]
			@capas[capa][:height].times do |y|
				@capas[capa][:width].times do |x|
					next if x * 32 > @window.scene.screen_x + 800
					next if x * 32 < @window.scene.screen_x - 32
					next if y * 32 > @window.scene.screen_y + 600
					next if y * 32 < @window.scene.screen_y - 32
					tile = @capas[capa][:tiles][x][y]
					if tile
						@tileset[tile].draw(x * 32 - @window.scene.screen_x, y * 32- @window.scene.screen_y, ZOrder::Tops) if capa == :tops
						@tileset[tile].draw(x * 32 - @window.scene.screen_x, y * 32- @window.scene.screen_y, ZOrder::Suelo) if capa == :suelo or capa == :objetos
					end
				end
			end
		end
	end
	def solid(x, y)
		begin
			return true if @capas[:objetos][:tiles][x/32][y/32]
		rescue
		return false
		end
	end
end



module Tileset
	def self.load_map(window, filename)
		@window = window
		@capas = {  :suelo => {      :mapa => true,
						         :width => true,
						         :height => true
							 },
							 
				   :objetos => {   :mapa => true,
							 :width => true,
							 :height => true
							 },
				   :tops => {       :mapa => true,
							 :width => true,
							 :height => true
							 },
				}	
				@capas[:suelo][:mapa],@capas[:suelo][:height],@capas[:suelo][:width] = *self.read_map(filename+".map")
				@capas[:objetos][:mapa],@capas[:objetos][:height],@capas[:objetos][:width] = *self.read_map(filename+".objects")
				@capas[:tops][:mapa],@capas[:tops][:height],@capas[:tops][:width] = *self.read_map(filename+".tops")
		for capa in [:suelo, :objetos, :tops]
			@capas[capa][:tiles] = Array.new(@capas[capa][:width]) do |x|
				Array.new(@capas[capa][:height]) do |y|
					case @capas[capa][:mapa][y][x*3, 3]
					when 'POS'
						@window.initial_position.push(y+1) 
						@window.initial_position.push(x)
						nil
					when '###'
						nil
					when 'ZOM'
					@window.initial_zombies << Zombie.new(@window, x, y+1)
						nil
					when /AM./
						@window.initial_ammos << Ammo.new(@window, x, y+1, @capas[capa][:mapa][y][x*3, 3].gsub!('AM','').to_i)
						nil
					else
						@capas[capa][:mapa][y][x*3, 3].to_i
					end #case
				end # y
			end # x
		end # for
		return @capas
	end # def
	
	def self.read_map(filename)
		map2 = []
		map = File.readlines(filename).map {|line| line.chomp}
		for line in 0...map.size
			map2[line] = map[line].gsub!(' ','')
		end
		return map2,map2.size,map2[0].size/3
	end
	
end #module