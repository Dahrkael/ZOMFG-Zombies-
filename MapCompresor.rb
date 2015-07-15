puts "creating temp file"
@file = File.open("map.txt", 'w')
puts "writing header"
@file.puts("ZMAP")
height_floor = File.readlines("mapa.floor").size
height_objects = File.readlines("mapa.objects").size
height_tops = File.readlines("mapa.tops").size
@file.puts(height_floor.to_s+";"+height_objects.to_s+";"+height_tops.to_s)
puts "writing layers"
File.open("mapa.floor", 'r') do |f|
	@file.puts(f.read)
end

File.open("mapa.objects", 'r') do |f|
	@file.puts(f.read)
end

File.open("mapa.tops", 'r') do |f|
	@file.puts(f.read)
end
@file.close
puts "creating map"
File.open("mapa.zmap", 'w') do |f|
	File.open("map.txt", 'r') do |e|
		data = Zlib::Deflate.deflate(e.read)
		Marshal.dump(data, f)
	end
end
File.delete("map.txt")
puts "map creation sucess"


       