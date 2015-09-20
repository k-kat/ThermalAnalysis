#!/usr/bin/env ruby
class Plate
    def initialize()
        @width = 0.0
        @height = 0.0
        @depth = 0.0
        @specific_gravity = 0.0
        @specific_heat = 0.0
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

    def get_specific_gravity()
        return @specific_gravity
    end

    def get_specific_heat()
        return @specific_heat
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
        return get_volume() * @specific_heat
    end
end

class Thermal
    HEAT_QUANTITY_SUN = "sun"
    HEAT_QUANTITY_EARTH = "earth"
    HEAT_QUANTITY_ALBEDO = "albedo"
    HEAT_QUANTITY_HOUSE = "house"

    def initialize()
        @heat_quantities = {
            HEAT_QUANTITY_SUN => 0.0,
            HEAT_QUANTITY_EARTH => 0.0,
            HEAT_QUANTITY_ALBEDO => 0.0,
            HEAT_QUANTITY_HOUSE => 0.0,
        }
    end

    def print_quantities()
        @heat_quantities.each{|key, value|
            puts "%s => %f" % [key, value]
        }
    end

    # Calc quantity of heat.
    # This function uses keyword arguments.
    # @param [Float] coeff Coefficient for quantity of heat.
    # @param [Float] energy Radiant energy
    # @param [Float] surface_are Surface Area
    # @param [Float] theta Angle of object.
    # @param [Float] shape_factor Shape factor
    # @param [String] One of HEAT_QUANTITY.
    def set_quantity(coeff, energy, surface_area, shape_factor:1.0, form_theta:0.0, tag:"")
        if tag == ""
            raise ArgumentError.new()
        end
        @heat_quantities[tag] = calc_heat_quantity(coeff, energy,
            surface_area, shape_factor:shape_factor, form_theta:form_theta)
    end

    # Calc quantity of heat.
    # This function uses keyword arguments.
    # @param [Float] coeff Coefficient for quantity of heat.
    # @param [Float] energy Radiant energy
    # @param [Float] surface_are Surface Area
    # @param [Float] theta Angle of object.
    # @param [Float] shape_factor Shape factor
    # @return [Float] Quantity of heat
    private
    def calc_heat_quantity(coeff, energy, surface_area, shape_factor:1.0, form_theta:0.0)
        return coeff * energy * shape_factor * surface_area * Math.cos(form_theta)
    end

    def get_sum()
        sum = 0.0
        @heat_quantities.each{|key, value|
            sum += value
        }
        return sum
    end
end

if __FILE__ == $0
    thermal = Thermal.new()
    necessary_quantities = [
        Thermal::HEAT_QUANTITY_SUN
    ]
    quantity_param = {
        Thermal::HEAT_QUANTITY_SUN => {
            "coeff" => 0.30, "energy" => 1350, "surface_area" => 0.1**2, "form_theta" => 0}}
    plate_param = [
        {},
        {"width" => 0.1, "height" => 0.1, "depth" => 0.02,
            "specific_gravity" => 2.7, "specific_heat" => 0.88},
        {"width" => 0.1, "height" => 0.1, "depth" => 0.02,
            "specific_gravity" => 2.7, "specific_heat" => 0.88},
    ]
    graph = {
        "1" => ["2"],
    }
    heat_transfer_coeffs = Array.new(2).map{ Array.new(2) }
    heat_transfer_coeffs[0][1] = 200 * plate_param[1]["height"] * plate_param[1]["depth"]
    heat_transfer_coeffs[1][0] = 200 * plate_param[1]["height"] * plate_param[1]["depth"]

    for quantity in necessary_quantities do
        thermal.set_quantity(
            quantity_param[quantity]["coeff"],
            quantity_param[quantity]["energy"],
            quantity_param[quantity]["surface_area"],
            form_theta:quantity_param[quantity]["form_theta"],
            tag:quantity)
    end
    thermal.print_quantities()

    plates = Array.new(0)
    heat_capacities = Array.new(0)
    for i in 1..(plate_param.length-1) do
        plate = Plate.new()
        plate.set_width(plate_param[i]["width"])
        plate.set_height(plate_param[i]["height"])
        plate.set_depth(plate_param[i]["depth"])
        plate.set_specific_gravity(plate_param[i]["specific_gravity"])
        plate.set_specific_heat(plate_param[i]["specific_heat"])
        plates[i] = plate
        heat_capacities[i] = plate.get_volume() * 100 ** 3 * plate.get_specific_gravity() * plate.get_specific_heat()
    end

    # sum = [thermal.get_sum(), 0.0]
    # graph.each{|key, value|
    #     delta_t = 1.0
    #     for i in 1..4 do # 4th order Runge-Kutta method
    #         slopes = Array.new(0)
    #         for i in [key] + value do
    #             val = sum[i]
    #             val /= mc[i]
    #         end
    #     end
    # }
end
