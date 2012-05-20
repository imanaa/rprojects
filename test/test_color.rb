require File.dirname(__FILE__) + '/test_helpers'

class ColorTest < Test::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_initialize_no_argument
    c = Color.new
    assert_equal(0, c.red, "Should be zero")
    assert_equal(0, c.green, "Should be zero")
    assert_equal(0, c.blue, "Should be zero")
  end

  def test_initialize_rgb_arguments
    rgb = Hash[*[:red, :green, :blue].collect { |k|
      [k, rand(256)]
    }.flatten]
    c = Color.new(rgb[:red],rgb[:green],rgb[:blue])
    rgb.each { |k, v|
      assert_equal(v, c.instance_variable_get("@"+k.to_s), "#{k.to_s} componenent should be #{v}")
    }
  end

  def test_initialize_hex_argument
    _colors = [
      ["FFFFFF", 255, 255, 255],
      ["FFffFF", 255, 255, 255],
      ["A0ff0F", 160, 255, 15]
    ]
    _colors.each { |v|
      c = Color.new(v[0])
      assert_equal(v[1], c.red, "Should be #{v[1]}")
      assert_equal(v[2], c.green, "Should be #{v[2]}")
      assert_equal(v[3], c.blue, "Should be #{v[3]}")
    }
  end

  def test_initialize_invalid_hex
    hex = rand(100000)+256**3

    assert_raise(ArgumentError) {
      c = Color.new(hex.to_s(16))
    }

    hex = -rand(100000)-1

    assert_raise(ArgumentError) {
      c = Color.new(hex.to_s(16))
    }
  end

  def test_initialize_invalid_number_arguments
    assert_raise(ArgumentError) {
      Color.new(1,2)      # Two Arguments
    }
    assert_raise(ArgumentError) {
      Color.new(3,2,5,7)  # Four Arguments
    }
  end

  def test_to_hex
    c = Color.new(255, 255, 255)
    assert_equal("ffffff", c.to_hex, "Should be ffffff")
    c = Color.new(0xb4, 10, 160)
    assert_equal("b40aa0", c.to_hex, "Should be b40aa0")
    c = Color.new(0)
    assert_equal("000000", c.to_hex, "Should be 000000")
  end

  def test_set_rgb
    c = Color.new(rand(256**3).to_s(16))

    [:red, :green, :blue].each { |v|
      _x = rand(256)
      c.instance_variable_set("@"+v.to_s,_x)
      assert_equal(_x, c.instance_variable_get("@"+v.to_s), "#{v} should be #{_x}")

      _x = rand(1000) + 256
      assert_raise(ArgumentError) {
        c.send(v.to_s+"=",_x)
      }

      _x = -rand(1000)-1
      assert_raise(ArgumentError) {
        c.send(v.to_s+"=",_x)
      }
    }
  end

  def test_available_name_sources
    hash = Color.available_name_sources
    # Mandatory name sources
    ["fr", "en"].each { |source|
      refute_nil(hash[source], "Name source '#{source}' should always exists")
    }
    # Other name sources
    hash.each { |source,filename|
      assert(File.exist?(filename),"Name Source '#{source}' not found")
    }
    assert_nil(hash["xxx"],"Name Source 'xxx' should not exist")
  end

  def test_distance_to
    c = Color.new(rand(256**3).to_s(16))
    assert_equal(0, c.distance_to(c), "Distance between the same color '#{c.to_hex}' should be zero")
    c1 = Color.new(12,12,12)
    c2 = Color.new(12,20,12)
    assert_equal(8, c1.distance_to(c2), "Should be 8")
  end

  def test_nearest_color
    c = Color.new(rand(256**3).to_s(16))
    assert_raise(ArgumentError) {
      c.nearest_color("xxx")
    }
    refute_nil(c.nearest_color("fr"), "Should not nil for Color #{c.to_hex}")
    #FIXME: should be no .to_hex call
    assert_equal(Color.new(67,10,140).nearest_color("en").to_hex, Color.new(68,10,140).nearest_color("en").to_hex, "Should be the same")
  end

  def test_name
    assert_equal("Black", Color.new(0).name("en"), "Should be Black")
    assert_equal("Red", Color.new("ff0000").name("en"), "Should be Red")
    assert_equal("Vert secondaire", Color.new("00ff00").name("fr"), "Should be Vert secondaire")
    assert_equal("Noiraud (teint, cheveux)", Color.new("2f1e0e").name("fr"), "Should be Noiraud (teint, cheveux)")
  end
end