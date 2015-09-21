#!/usr/bin/env ruby
class Plate
    def initialize()
        @width = 0.0
        @height = 0.0
        @depth = 0.0
        @specific_gravity = 0.0
        @specific_heat = 0.0
        @temperature = 0.0
    end

    def set_width(width)
        @width = width
    end

    def set_height(height)
        @height = height
    end

    def set_depth(depth)
        @depth = depth
    end

    def set_specific_gravity(spec_g)
        @specific_gravity = spec_g
    end

    def set_specific_heat(spec_h)
        @specific_heat = spec_h
    end

    def set_temperature(temp)
        @temperature = temp
    end

    def get_specific_gravity()
        return @specific_gravity
    end

    def get_specific_heat()
        return @specific_heat
    end

    def get_temperature()
        return @temperature
    end

    def get_area()
        return @width * @height
    end

    def get_volume()
        return get_area() * @depth
    end

    def get_weight()
        return  get_volume() * @specific_gravity
    end

    def get_heat_capacity()
        return get_volume() * 100 ** 3 * get_specific_gravity() * get_specific_heat()
    end
end
