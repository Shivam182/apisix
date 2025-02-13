--
-- Licensed to the Apache Software Foundation (ASF) under one or more
-- contributor license agreements.  See the NOTICE file distributed with
-- this work for additional information regarding copyright ownership.
-- The ASF licenses this file to You under the Apache License, Version 2.0
-- (the "License"); you may not use this file except in compliance with
-- the License.  You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

local util   = require("apisix.plugins.grpc-transcode.util")
local core   = require("apisix.core")
local pb     = require("pb")
local bit    = require("bit")
local ngx    = ngx
local string = string
local table  = table
local pcall = pcall
local tonumber = tonumber
local req_read_body = ngx.req.read_body

return function (proto, service, method, pb_option, deadline, default_values)
    core.log.info("proto: ", core.json.delay_encode(proto, true))
    local m = util.find_method(proto, service, method)
    if not m then
        return false, "Undefined service method: " .. service .. "/" .. method
                      .. " end", 503
    end

    req_read_body()

<<<<<<< HEAD
<<<<<<< HEAD
    local pb_old_state = pb.state(proto.pb_state)
=======
>>>>>>> adcf6951c7baedf949108bfd37f46d078afe1143
=======
    local pb_old_state = pb.state(proto.pb_state)
>>>>>>> 7ec3c0f583510ebcdf9c414f83792e1ac247a5b9
    util.set_options(proto, pb_option)

    local map_message = util.map_message(m.input_type, default_values or {})
    local ok, encoded = pcall(pb.encode, m.input_type, map_message)
<<<<<<< HEAD
<<<<<<< HEAD
    pb.state(pb_old_state)
=======
>>>>>>> adcf6951c7baedf949108bfd37f46d078afe1143
=======
    pb.state(pb_old_state)
>>>>>>> 7ec3c0f583510ebcdf9c414f83792e1ac247a5b9

    if not ok or not encoded then
        return false, "failed to encode request data to protobuf", 400
    end

    local size = #encoded
    local prefix = {
        string.char(0),
        string.char(bit.band(bit.rshift(size, 24), 0xFF)),
        string.char(bit.band(bit.rshift(size, 16), 0xFF)),
        string.char(bit.band(bit.rshift(size, 8), 0xFF)),
        string.char(bit.band(size, 0xFF))
    }

    local message = table.concat(prefix, "") .. encoded

    ngx.req.set_method(ngx.HTTP_POST)
    ngx.req.set_uri("/" .. service .. "/" .. method, false)
    ngx.req.set_uri_args({})
    ngx.req.set_body_data(message)

    local dl = tonumber(deadline)
    if dl~= nil and dl > 0 then
        ngx.req.set_header("grpc-timeout",  dl .. "m")
    end

    return true
end
