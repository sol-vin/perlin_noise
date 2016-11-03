# perlin_noise

A Shard written for using Perlin Noise. Pretty much ripped word for word from (Spooner's perlin_noise)[https://github.com/Spooner/ruby-perlin/] gem's C extension.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  perlin_noise:
    github: redcodefinal/perlin_noise
```


## Usage

```crystal
require "perlin_noise"

p = PerlinNoise.new(1234) #Seed the generator

#You can change the step, persistance, octave, offsets, etc
p.step = 0.4 #default is 0.123456
p.persistance = 0.4 # Default is 0.2
p.octave = 2.0 # Default is 1.0

#Generator can be used for a number of operations

#Simple Noise
p.noise(0)       #1d
p.noise(0, 1)    #2d
p.noise(0, 1, 2) #3d

#Height
p.height(0, 0, 10) #2d only, 3rd argument is maximum height

#Integer
#  Gets a random integer that can be gotten again with the same parameters.
p.int(0, 10, 20)       #1d, last two arguments are the lowest number and the highest number
p.int(0, 1, 10, 20)    #2d
p.int(0, 1, 2, 10, 20) #3d

#Float
#  Same as int but with floats instead.
p.float(0, 0.0, 1.0)
p.float(0, 1, 0.0, 5.0)
p.float(0, 1, 2, 1.0, 10.0)

#Bool
#  Gets you a boolean with controllable chance for a true.
#  bool(x, y, z, chance, outof)
p.bool(0, 1, 2, 1, 100) #Give a 1 out of 100 chance of being true.

#Item
#  Grabs an item out of an array. If the array changes, the output of this function may change.
a = [1, 2, 3, 4, 5, 6, 7, 8, "Bacon", "Taco", "Cat"]
p.item(0, a)
p.item(0, 1, a)
p.item(0, 1, 2, a)
```




## Contributing

1. Fork it ( https://github.com/redcodefinal/perlin_noise/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [redcodefinal](https://github.com/redcodefinal) Ian Rash - creator, maintainer
- [Spooner](https://github.com/spooner) Bil Bas - Writter of the original rubygem, whose code he graciously let me rip off. Thanks man.
