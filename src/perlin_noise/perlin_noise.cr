class PerlinNoise

  getter seed : Int32
  
  property step : Float32 = 0.123456_f32
  property persistance : Float32 = 0.2_f32
  property octave : Float32 = 1.0_f32
  
  property x_offset : Float32 = 0.0_f32
  property y_offset : Float32 = 0.0_f32
  property z_offset : Float32 = 0.0_f32

  def initialize(@seed = 1)
  end

  def noise(x : Int) : Float
    perlin_octaves_2d((x + x_offset) * step, y_offset, persistance, octave)
  end

  def noise(x : Int, y : Int) : Float
    perlin_octaves_2d((x + x_offset) * step, (y + y_offset) * step, persistance, octave)
  end

  def noise(x : Int, y : Int, z : Int) : Float
    perlin_octaves_3d((x + x_offset) * step, (y + y_offset) * step, (z + z_offset) * step, persistance, octave)    
  end

  def height(x : Int, y : Int, max_height : Int = 10) : Int
    ((noise(x ,y) + 1.0 / 2.0) * max_height).to_i64
  end

  def int(x : Int, low : Int, high : Int) : Int
    raise "low must be lower than high" if low >= high
    ((noise(x).to_s.split('.').last.reverse.to_i64 % (high + 1 - low)) + low)
  end

  def int(x : Int, y : Int, low : Int, high : Int) : Int
    raise "low must be lower than high" if low >= high
    (noise(x, y).to_s.split('.').last.reverse.to_i64 % (high+1 - low)) + low
  end

  def int(x : Int, y : Int, z : Int, low : Int, high : Int) : Int
    raise "low must be lower than high" if low >= high
    (noise(x, y, z).to_s.split('.').last.reverse.to_i64 % (high+1 - low)) + low
  end
  
  def float(x : Int, low : Float, high : Float) : Float
    raise "low must be lower than high" if low >= high
    (noise(x).to_s.split('.').last.reverse.insert(0, '.').to_f * (high-low)) + low
  end

  def float(x : Int, y : Int, low : Float, high : Float) : Float
    raise "low must be lower than high" if low >= high
    (noise(x, y).to_s.split('.').last.reverse.insert(0, '.').to_f * (high-low)) + low
  end

  def float(x : Int, y : Int, z : Int, low : Float, high : Float) : Float
    raise "low must be lower than high" if low >= high
    (noise(x, y, z).to_s.split('.').last.reverse.insert(0, '.').to_f * (high-low)) + low
  end

  def bool(x : Int, chance : Int, outof : Int)
    raise "chance must be less than out of" if outof >= chance
    int(x, 1, outof) <= chance
  end
  
  def bool(x : Int, y : Int, chance : Int, outof : Int)
    raise "chance must be less than out of" if outof >= chance
    int(x, y, 1, outof) <= chance
  end

  def bool(x : Int, y : Int, z : Int, chance : Int, outof : Int)
    raise "chance must be less than out of" if outof >= chance
    int(x, y, z, 1, outof) <= chance
  end

  def item(x : Int, array : Indexable(T)) : T forall T
    array[int(x, 0, array.size-1)]
  end

  def item(x : Int, y : Int, array : Indexable(T)) : T forall T
    array[int(x, y, 0, array.size-1)]
  end
 
  def item(x : Int, y : Int, z : Int, array : Indexable(T)) : T forall T
    array[int(x, y, z, 0, array.size-1)]
  end


  private def perlin_interpolate(a : Float, b : Float, x : Float) : Float
    ft = x * Math::PI
    f = (1 - Math.cos(ft)) * 0.5
    return a * (1.0 - f) + b * f
  end

  private def perlin_noise_2d(x : Int, y : Int) : Float
    n = x + y * 57_i32
    n = (n << 13) ^ n
    return (1.0 - ((n * (n * n * 15731*seed + 789221*seed) + 1376312589*seed) & 0x7fffffff) / 1073741824.0)
  end

  private def perlin_noise_3d(x : Int, y : Int, z : Int) : Float
    n = x + y + z * 57_i32
    n = (n << 13) ^ n
    return (1.0 - ((n * (n * n * 15731*seed + 789221*seed) + 1376312589*seed) & 0x7fffffff) / 1073741824.0)
  end

  private def perlin_smooth_noise_2d(x : Int, y : Int) : Float
    corners = (
      perlin_noise_2d(x - 1, y - 1) +
      perlin_noise_2d(x + 1, y - 1) +
      perlin_noise_2d(x - 1, y + 1) +
      perlin_noise_2d(x + 1, y + 1)) / 4.0

    sides = (
      perlin_noise_2d(x - 1, y) +
      perlin_noise_2d(x + 1, y) +
      perlin_noise_2d(x, y - 1) +
      perlin_noise_2d(x, y + 1)) / 4.0

    center = perlin_noise_2d(x, y) / 4.0
    return corners + sides + center
  end

  private def perlin_interpolated_noise_2d(x : Float, y : Float) : Float
    integer_x = x.to_i
    fractional_x = x.to_f - integer_x

    integer_y = y.to_i
    fractional_y = y - integer_y

    v1 = perlin_smooth_noise_2d(integer_x, integer_y)
    v2 = perlin_smooth_noise_2d(integer_x + 1, integer_y)
    v3 = perlin_smooth_noise_2d(integer_x, integer_y + 1)
    v4 = perlin_smooth_noise_2d(integer_x + 1, integer_y + 1)
    
    i1 = perlin_interpolate(v1, v2, fractional_x)
    i2 = perlin_interpolate(v3, v4, fractional_x)
    
    return perlin_interpolate(i1, i2, fractional_y)
  end

  private def perlin_octaves_2d(x : Float, y : Float, p : Float, n : Float) : Float
    total = 0.0
    frequency = 1.0
    amplitude = 1.0

    n.to_i.times do
      total += perlin_interpolated_noise_2d(x * frequency, y * frequency) * amplitude
      frequency *= 2
      amplitude *= p
    end    
    return total
  end

  private def perlin_smooth_noise_3d(x : Int, y : Int, z : Int) : Float
    corners = (
      perlin_noise_3d(x - 1, y - 1, z + 1) +
      perlin_noise_3d(x + 1, y - 1, z + 1) +
      perlin_noise_3d(x - 1, y + 1, z + 1) +
      perlin_noise_3d(x + 1, y + 1, z + 1) +
      perlin_noise_3d(x - 1, y - 1, z - 1) +
      perlin_noise_3d(x + 1, y - 1, z - 1) +
      perlin_noise_3d(x - 1, y + 1, z - 1) +
      perlin_noise_3d(x + 1, y + 1, z - 1)) / 16.0

    sides = (
      perlin_noise_3d(x - 1, y, z + 1) +
      perlin_noise_3d(x + 1, y, z + 1) +
      perlin_noise_3d(x, y - 1, z + 1) +
      perlin_noise_3d(x, y + 1, z + 1) +
      perlin_noise_3d(x - 1, y, z - 1) +
      perlin_noise_3d(x + 1, y, z - 1) +
      perlin_noise_3d(x, y - 1, z - 1) +
      perlin_noise_3d(x, y + 1, z - 1) +
      perlin_noise_3d(x - 1, y - 1, z) +
      perlin_noise_3d(x + 1, y - 1, z) +
      perlin_noise_3d(x + 1, y + 1, z) +
      perlin_noise_3d(x - 1, y + 1, z)) / 8.0

    center = perlin_noise_2d(x, y) / 12
    return corners + sides + center
  end

  private def perlin_interpolated_noise_3d(x : Float, y : Float, z : Float) : Float
    integer_x = x.to_i
    fractional_x = x - integer_x
   
    integer_y = y.to_i
    fractional_y = y - integer_y
    
    integer_z = z.to_i
    fractional_z = z - integer_z

    a = perlin_smooth_noise_3d(integer_x, integer_y, integer_z)
    b = perlin_smooth_noise_3d(integer_x + 1, integer_y, integer_z)
    c = perlin_smooth_noise_3d(integer_x, integer_y + 1, integer_z)
    d = perlin_smooth_noise_3d(integer_x, integer_y, integer_z + 1)
    e = perlin_smooth_noise_3d(integer_x + 1, integer_y + 1, integer_z)
    f = perlin_smooth_noise_3d(integer_x, integer_y + 1, integer_z + 1)
    g = perlin_smooth_noise_3d(integer_x + 1, integer_y, integer_z + 1)
    h = perlin_smooth_noise_3d(integer_x + 1, integer_y + 1, integer_z + 1)

    i1 = perlin_interpolate(a, b, fractional_x)
    i2 = perlin_interpolate(c, d, fractional_x)
    i3 = perlin_interpolate(e, f, fractional_x)
    i4 = perlin_interpolate(g, h, fractional_x)

    y1 = perlin_interpolate(i1, i2, fractional_y)
    y2 = perlin_interpolate(i3, i4, fractional_y)

    return perlin_interpolate(y1, y2, fractional_z)
  end  

  private def perlin_octaves_3d(x : Float, y : Float, z : Float, p : Float, n : Float) : Float
    total = 0.0
    frequency = 1.0
    amplitude = 1.0

    n.to_i.times do
      total += perlin_interpolated_noise_3d(x * frequency, y * frequency, z * frequency) * amplitude
      frequency *= 2
      amplitude *= p
    end
    return total    
  end
end
