class Blood
  attr_reader :x
  attr_reader :y
  attr_reader :kill_me
  
  def initialize(window, x, y, type)    
    @window = window
    @x = x + rand(10)
    @y = y + 48
    @angle = Gosu::random(0, 360) 
	if type == :kill
		@image = @window.scene.blood_image[rand(@window.scene.blood_image.size)]
	elsif type == :shot
		@image = @window.scene.blood_image2[rand(@window.scene.blood_image2.size)]
	end
    @z = ZOrder::Blood
    @life = 1800
    @kill_me = false
  end
  
  def update
	  @life -= 1
	  if @life <= 0
		  @kill_me = true
	  end
  end
  
  def draw
	  #@image.draw(@x - @window.scene.screen_x,@y - @window.scene.screen_y, ZOrder::Blood)
	  @image.draw_rot(@x - @window.scene.screen_x,@y - @window.scene.screen_y, ZOrder::Blood, @angle.to_f, 0.5, 0.5, 1, 1, 0xffffffff, :default) 
  end

end