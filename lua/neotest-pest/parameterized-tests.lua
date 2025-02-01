local pest_control = require("neotest-pest.pest-control")

local M = {}

function M.get_parameterized_test_positions(positions)
    local parameterized_test_positions = {}

    for _, value in positions:iter_nodes() do
        local data = value:data()

        if data.type == "test" and data.is_parameterized == true then
            parameterized_test_positions[#parameterized_test_positions + 1] = value
        end
    end

    return parameterized_test_positions
end

function M.enrich_positions_with_parameterized_tests(
    file_path,
    parsed_parameterized_test_positions
)
    local pest_test_discovery_output = pest_control.run_pest_test_discovery(file_path)

    -- if pest_test_discovery_output == nil then
    --     return
    -- end

    -- for _, value in pairs(parsed_parameterized_test_positions) do
    --     local data = value:data()

    --     local parameterized_test_results_for_position =
    --         get_test_ids_at_position(pest_test_discovery_output, data.range)

    --     for _, test_result in ipairs(parameterized_test_results_for_position) do
    --         local new_data = {
    --             id = test_result.keyid,
    --             name = test_result.name,
    --             path = data.path,
    --         }
    --         new_data.range = nil

    --         local new_pos = value:new(new_data, {}, value._key, {}, {})
    --         value:add_child(new_data.id, new_pos)
    --     end
    -- end
end

return M
