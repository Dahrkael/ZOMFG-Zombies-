require 'zlib'

@file = File.open("map.txt", 'w')
@file.puts("ZMAP")
height_floor = File.readlines("map.floor").size
height_objects = File.readlines("map.objects").size
height_tops = File.readlines("map.tops").size
@file.puts(height_floor.to_s+";"+height_objects.to_s+";"+height_tops.to_s)

File.open("map.floor", 'r') do |f|
	@file.puts(f.read)
end

File.open("map.objects", 'r') do |f|
	@file.puts(f.read)
end

File.open("map.tops", 'r') do |f|
	@file.puts(f.read)
end
@file.close

File.open("map.zmap", 'w') do |f|
	File.open("map.txt", 'r') do |e|
		data = Zlib::Deflate.deflate(e.read)
		Marshal.dump(data, f)
	end
end
File.delete("map.txt")
#Escribir
#	File.open("mapa.zmap", 'w') do |f1|
#		File.open("mapa.txt", 'r') do |f2|
#			data = Zlib::Deflate.deflate(f2.read)
#			Marshal.dump(data, f1)
#		end
#	end

       