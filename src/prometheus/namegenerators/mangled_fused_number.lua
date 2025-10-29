-- This Script is Part of the Prometheus Obfuscator by Levno_710
--
-- namegenerators/mangled_fused_number.lua
--
-- This Script provides a function for generation of names combining ALL name generation strategies

local PREFIX = "_";
local MIN_CHARACTERS = 5;
local MAX_INITIAL_CHARACTERS = 10;

local util = require("prometheus.util");
local chararray = util.chararray;

-- Character arrays from mangled generators
local VarDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_");
local VarStartDigits = chararray("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

-- Character arrays from il generator
local IlDigits = chararray("Il1");
local IlStartDigits = chararray("Il");
local ilOffset = 0;

-- Variable names from confuse generator
local varNames = {
    "index", "iterator", "length", "size", "key", "value", "data", "count",
    "increment", "include", "string", "number", "type", "void", "int", "float",
    "bool", "char", "double", "long", "short", "unsigned", "signed", "program",
    "factory", "Factory", "new", "delete", "table", "array", "object", "class",
    "arr", "obj", "cls", "dir", "directory", "isWindows", "isLinux", "game",
    "roblox", "gmod", "gsub", "gmatch", "gfind", "onload", "load", "loadstring",
    "loadfile", "dofile", "require", "parse", "byte", "code", "bytecode", "idx",
    "const", "loader", "loaders", "module", "export", "exports", "import",
    "imports", "package", "packages", "_G", "math", "os", "io", "write", "print",
    "read", "readline", "readlines", "close", "flush", "open", "popen", "tmpfile",
    "tmpname", "rename", "remove", "seek", "setvbuf", "lines", "call", "apply",
    "raise", "pcall", "xpcall", "coroutine", "create", "resume", "status", "wrap",
    "yield", "debug", "traceback", "getinfo", "getlocal", "setlocal", "getupvalue",
    "setupvalue", "getuservalue", "setuservalue", "upvalueid", "upvaluejoin",
    "sethook", "gethook", "hookfunction", "hooks", "error", "setmetatable",
    "getmetatable", "rand", "randomseed", "next", "ipairs", "hasnext", "loadlib",
    "searchpath", "oldpath", "newpath", "path", "rawequal", "rawset", "rawget",
    "rawnew", "rawlen", "select", "tonumber", "tostring", "assert", "collectgarbage",
    "a", "b", "c", "i", "j", "m",
}

-- Generate mangled name component
local function generateMangled(id)
	local name = ''
	local d = id % #VarStartDigits
	id = (id - d) / #VarStartDigits
	name = name .. VarStartDigits[d + 1]
	while id > 0 do
		local d = id % #VarDigits
		id = (id - d) / #VarDigits
		name = name .. VarDigits[d + 1]
	end
	return name
end

-- Generate Il1 name component
local function generateIl(id)
	local name = ''
	id = id + ilOffset
	local d = id % #IlStartDigits
	id = (id - d) / #IlStartDigits
	name = name .. IlStartDigits[d + 1]
	while id > 0 do
		local d = id % #IlDigits
		id = (id - d) / #IlDigits
		name = name .. IlDigits[d + 1]
	end
	return name
end

-- Generate confuse name component
local function generateConfuse(id)
	local name = {}
	local d = id % #varNames
	id = (id - d) / #varNames
	table.insert(name, varNames[d + 1])
	while id > 0 do
		local d = id % #varNames
		id = (id - d) / #varNames
		table.insert(name, varNames[d + 1])
	end
	return table.concat(name, "_")
end

-- Main name generator combining all strategies
local function generateName(id, scope)
	-- Choose strategy based on id modulo
	local strategy = id % 4
	
	if strategy == 0 then
		-- Pure number with prefix
		return PREFIX .. tostring(id)
	elseif strategy == 1 then
		-- Mangled + number
		local mangled = generateMangled(id)
		return mangled .. PREFIX .. tostring(id)
	elseif strategy == 2 then
		-- Il1 style + number
		local il = generateIl(id)
		return il .. PREFIX .. tostring(id)
	else
		-- Confuse + number
		local confuse = generateConfuse(id)
		return confuse .. PREFIX .. tostring(id)
	end
end

local function prepare(ast)
	-- Shuffle all character arrays
	util.shuffle(VarDigits)
	util.shuffle(VarStartDigits)
	util.shuffle(IlDigits)
	util.shuffle(IlStartDigits)
	util.shuffle(varNames)
	
	-- Set random offset for Il generator
	ilOffset = math.random(3 ^ MIN_CHARACTERS, 3 ^ MAX_INITIAL_CHARACTERS)
end

return {
	generateName = generateName,
	prepare = prepare
}
