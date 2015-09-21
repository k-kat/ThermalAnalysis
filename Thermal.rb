#!/usr/bin/env ruby

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

    def get_sum()
        sum = 0.0
        @heat_quantities.each{|key, value|
            sum += value
        }
        return sum
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

    private

    # Calc quantity of heat.
    # This function uses keyword arguments.
    # @param [Float] coeff Coefficient for quantity of heat.
    # @param [Float] energy Radiant energy
    # @param [Float] surface_are Surface Area
    # @param [Float] theta Angle of object.
    # @param [Float] shape_factor Shape factor
    # @return [Float] Quantity of heat
    def calc_heat_quantity(coeff, energy, surface_area, shape_factor:1.0, form_theta:0.0)
        return coeff * energy * shape_factor * surface_area * Math.cos(form_theta)
    end
end
