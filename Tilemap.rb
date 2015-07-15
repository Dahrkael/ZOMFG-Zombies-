
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
	
	def draw
		for capa in [:suelo, :objetos, :tops]
			max_y = (@window.scene.screen_y + 600) / 32
			if max_y > @capas[capa][:height]-1 then max_y = @capas[capa][:height]-1 end
			max_x = (@window.scene.screen_x + 800) / 32
			if max_x > @capas[capa][:width]-1 then max_x = @capas[capa][:width]-1 end
			(@window.scene.screen_y/32).upto(max_y) do |y|
				(@window.scene.screen_x/32).upto(max_x) do |x|
			#@capas[capa][:height].times do |y|
				#@capas[capa][:width].times do |x|
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
				array = self.read_map(filename)
				@capas[:suelo][:mapa] = array[0]
				@capas[:suelo][:height] = array[1]
				@capas[:suelo][:width] = array[2]
				@capas[:objetos][:mapa] = array[3]
				@capas[:objetos][:height] = array[4]
				@capas[:objetos][:width] = array[5]
				@capas[:tops][:mapa] = array[6]
				@capas[:tops][:height] = array[7]
				@capas[:tops][:width] =  array[8]
				array = nil
				 
				
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
		suelo = []
		objects = []
		tops = []
		zmap = File.open("maps/"+filename+".zmap", 'r')
		data = Zlib::Inflate.inflate(Marshal.load(zmap))
		zmap.close
		map = data.split("\n")
		map.each { |s| s.chomp }

		if map[0] == /ZMAP(\r)?/
			print "ZMAP incorrect"
			exit
		end
		sizes = map[1].split(';')
		
		for line in 2...map.size
			map2[line] = map[line].gsub!(' ','')
		end
		for a in 2...sizes[0].to_i + 2
			suelo << map2[a]
		end
		
		for e in sizes[0].to_i+2...sizes[0].to_i+sizes[1].to_i+2
			objects << map2[e]
		end

		for i in sizes[0].to_i+sizes[1].to_i+2...sizes[2].to_i+sizes[0].to_i+sizes[1].to_i+2
			tops << map2[i]
		end
		array = [suelo,suelo.size,suelo[0].size/3, objects,objects.size,objects[0].size/3, tops,tops.size,tops[0].size/3]
		return array
	end
	
end #module