class SimplexNoise
  def octave_noise_2d(octaves : Float, persisitance : Float, scale : Float, x : Float, y : Float) : Float
    total = 0.0
    frequency = scale
    amplitude = 1.0
    
    max_amplitude = 0.0
    octaves.times do
      total += raw_noise_2d(x * frequency, y * frequency) * amplitude
      frequency *= 2
      max_amplitude += amplitude
      amplitude *= persistance     
    end

    return total / max_amplitude
  end

  def octave_noise_3d(octaves : Float, persisitance : Float, scale : Float, x : Float, y : Float, z : Float) : Float
    total = 0.0
    frequency = scale
    amplitude = 1.0

    max_amplitude = 0.0
    octaves.times do
      total += raw_noise_3d(x * frequency, y * frequency, z * frequency) * amplitude
      frequency *= 2
      max_amplitude += amplitude
      amplitude *= persistance
    end

    return total / max_amplitude
  end
end
