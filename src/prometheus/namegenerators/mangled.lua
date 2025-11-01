-- This Script is Part of the Prometheus Obfuscator by Levno_710
--
-- namegenerators/mangled.lua
--
-- This Script provides a function for generation of mangled and confusing names

local util = require("prometheus.util");
local chararray = util.chararray;

local idGen = 0
local VarDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
local VarStartDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

local varNames = {
    "exploit",
    "Skidders",
    "data",
    "WeAreNation",
    "continue",
    "a", "b", "c", "i", "j", "k",
}

-- Mangled name generation (original)
local function generateMangledName(id, scope)
    local name = ''
    local d = id % #VarStartDigits
    id = (id - d) / #VarStartDigits
    name = name..VarStartDigits[d+1]
    while id > 0 do
        local d = id % #VarDigits
        id = (id - d) / #VarDigits
        name = name..VarDigits[d+1]
    end
    return name
end

-- Confusing name generation (from confuse.lua)
local function generateConfuseName(id, scope)
    local name = {};
    local d = id % #varNames
    id = (id - d) / #varNames
    table.insert(name, varNames[d + 1]);
    while id > 0 do
        local d = id % #varNames
        id = (id - d) / #varNames
        table.insert(name, varNames[d + 1]);
    end
    return table.concat(name, "_");
end

-- Hybrid: Mix both mangled and confusing names
local function generateName(id, scope)
    -- Use confusing names for 50% of variables
    if id % 2 == 0 then
        return generateConfuseName(id / 2, scope)
    else
        return generateMangledName(id, scope)
    end
end

local function prepare(ast)
    util.shuffle(varNames);
end

return {
    generateName = generateName,
    generateMangledName = generateMangledName,
    generateConfuseName = generateConfuseName,
    prepare = prepare
}
