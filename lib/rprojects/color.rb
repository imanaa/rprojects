module Rprojects
  class Color
    attr_reader :red, :green, :blue
    @@color_names = {}

    # 3 forms of parameters:
    # * no argument: color is set to rgb(0,0,0) i.e. black
    # * one argument: color is set to the hexadecimal representation of the color
    # * three arguments: the three RGB component
    def initialize(*args)
      case args.length
      when 0 then
        self.red = 0
        self.green = 0
        self.blue = 0
      when 1 then
        color = args[0].to_s.hex
        self.blue = color % 256
        color /= 256
        self.green = color % 256
        self.red = color / 256
      when 3 then
        self.red = args[0]
        self.green = args[1]
        self.blue = args[2]
      else
        raise ArgumentError, "Wrong number of arguments (#{args.length})"
      end
    end

    # gives the hexadecimal representation of the color
    def to_hex
      ((red*256+green)*256+blue).to_s(16).rjust(6,"0")
    end

    # set the Red component of the color
    def red=(red)
      raise ArgumentError, "Red value (#{red}) outside range 0 to 255" unless (0..255).include? red
      @red = red
    end

    # set the Green component of the color
    def green=(green)
      raise ArgumentError, "Green value (#{green}) outside range 0 to 255" unless (0..255).include? green
      @green = green
    end

    # set the Blue component of the color
    def blue=(blue)
      raise ArgumentError, "Blue value (#{blue}) outside range 0 to 255" unless (0..255).include? blue
      @blue = blue
    end

    # Returns available name sources for colors
    def Color.available_name_sources
      hash = {}
      Dir.chdir(File.join(File.dirname(__FILE__),"..","..","data")) {
        Dir["colors_name_*.yaml"].each { |filename|
          index = File.basename(filename, ".yaml")[12..-1]
          hash[index] = File.expand_path(filename)
        }
      }
      return hash
    end

    # Distance bewteen two colors (Euclididan Distance)
    def distance_to(color)
      Math.sqrt((self.red-color.red)**2+(self.green-color.green)**2+(self.blue-color.blue)**2)
    end

    # Finds the nearest color in a given name source
    def nearest_color(source)
      sources = Color.available_name_sources
      raise(ArgumentError, "Unknow name source") unless sources.key?(source)

      color = nil
      distance = 256**3             # Max distance
      Color.color_names(source).each { |hex,name|
        #YAML::load(File.open(sources[source])).each { |hex,name|
        _color = Color.new(hex)
        _distance = _color.distance_to(self)
        if _distance < distance
          color = _color
          distance = _distance
        end
      }
      return color
    end

    # Returns the name of the color according to the given name source
    def name(source)
      Color.color_names(source)[nearest_color(source).to_hex]
    end
    
    # Algorithm from : Darel Rex Finley
    # Return a number in the rage of 0 (black) to 255 (White) 
    def brightness
      Math.sqrt( 0.299 * @red**2 + 0.587 * @green**2 + 0.114 * @blue**2 )
    end

    private

    def Color.color_names(source)
      # This a Lazy loading implementation
      unless @@color_names.key? source
        sources = available_name_sources
        raise(ArgumentError, "Unknow name source") unless sources.key?(source)

        @@color_names[source] = YAML::load(File.open(sources[source]))
      end
      return @@color_names[source]
    end
  end
end