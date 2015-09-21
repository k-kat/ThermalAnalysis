#!/usr/bin/env ruby
require "./Plate.rb"
require "./Thermal.rb"

if __FILE__ == $0
    thermal = Thermal.new()
    necessary_quantities = [
        Thermal::HEAT_QUANTITY_SUN
    ]
    quantity_param = {
        Thermal::HEAT_QUANTITY_SUN => {
            "coeff" => 0.30, "energy" => 1350, "surface_area" => 0.166*2, "form_theta" => 0}}
    plate_param = [
        {},
        {"width" => 0.1, "height" => 0.1, "depth" => 0.02,
            "specific_gravity" => 2.7, "specific_heat" => 0.88, "temperature" => 0.0},
        {"width" => 0.1, "height" => 0.1, "depth" => 0.02,
            "specific_gravity" => 2.7, "specific_heat" => 0.88, "temperature" => 0.0},
    ]
    graph = {
        "1" => ["2"],
        "2" => ["1"],
    }
    heat_transfer_coeffs = Array.new(3).map{ Array.new(3) }
    heat_transfer_coeffs[1][2] = 200 * plate_param[1]["height"] * plate_param[1]["depth"]
    heat_transfer_coeffs[2][1] = 200 * plate_param[1]["height"] * plate_param[1]["depth"]

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
        plate.set_temperature(plate_param[i]["temperature"])
        plates[i] = plate
        heat_capacities[i] = plate.get_heat_capacity()
    end

    # sum is tentative
    sum = Array.new(0)
    sum[1] = thermal.get_sum()
    sum[2] = 0
    slopes = Array.new(5).map{ Array.new(3) }
    slopes[0][1] = 0.0
    slopes[0][2] = 0.0
    for num in 1..10 do
        for i in 1..4 do # 4th order Runge-Kutta method
            graph.each{|key, value|
                slopes[i][key.to_i] = 0.0
                for j in value do
                    slopes[i][key.to_i] -= heat_transfer_coeffs[key.to_i][j.to_i] *
                        ((plates[key.to_i].get_temperature() + slopes[i - 1][1]/2)
                         - (plates[j.to_i].get_temperature() + slopes[i - 1][2]/2))
                end
                slopes[i][key.to_i] += sum[key.to_i]
                slopes[i][key.to_i] /= heat_capacities[key.to_i]
            }
        end

        puts("Temprature[%d]" % num)
        for i in 1..2 do
            plates[i].set_temperature(plates[i].get_temperature() +
                (slopes[1][i] + 2 * slopes[2][i] + 2 * slopes[3][i] + 3 * slopes[4][i]))
            puts("plate%d : %f" % [i, plates[i].get_temperature()])
        end
    end

end
