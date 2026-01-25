--[[
Name: LibDataBroker-1.1
Revision: $Rev: 20 $
Author: tekkub (tekkub@gmail.com)
Website: http://www.wowace.com/projects/libdatabroker-1-1/
Description: A central registry for addons to announce their presence to data display addons
License: Public Domain
]]

assert(LibStub, "LibDataBroker-1.1 requires LibStub")
local lib, oldminor = LibStub:NewLibrary("LibDataBroker-1.1", 4)
if not lib then return end
oldminor = oldminor or 0


lib.callbacks = lib.callbacks or LibStub:GetLibrary("CallbackHandler-1.0"):New(lib)
lib.attributestorage, lib.namestorage, lib.proxystorage = lib.attributestorage or {}, lib.namestorage or {}, lib.proxystorage or {}
local attributestorage, namestorage, callbacks = lib.attributestorage, lib.namestorage, lib.callbacks

if oldminor < 2 then
	lib.domt = {
		__metatable = "access denied",
		__index = function(self, key) return attributestorage[self] and attributestorage[self][key] end,
	}
end

if oldminor < 3 then
	lib.domt.__newindex = function(self, key, value)
		if not attributestorage[self] then attributestorage[self] = {} end
		if attributestorage[self][key] == value then return end
		attributestorage[self][key] = value
		local name = namestorage[self]
		if not name then return end
		callbacks:Fire("LibDataBroker_AttributeChanged", name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged_"..name, name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged_"..name.."_"..key, name, key, value, self)
		callbacks:Fire("LibDataBroker_AttributeChanged__"..key, name, key, value, self)
	end
end

if oldminor < 2 then
	function lib:NewDataObject(name, dataobj)
		if namestorage[dataobj] then return end

		if not dataobj.type then error("dataobj.type is required") end
		if dataobj.icon and type(dataobj.icon) ~= "string" and type(dataobj.icon) ~= "number" then error("dataobj.icon must be a string or number") end
		if dataobj.OnClick and type(dataobj.OnClick) ~= "function" then error("dataobj.OnClick must be a function") end
		if dataobj.OnTooltipShow and type(dataobj.OnTooltipShow) ~= "function" then error("dataobj.OnTooltipShow must be a function") end
		if dataobj.OnEnter and type(dataobj.OnEnter) ~= "function" then error("dataobj.OnEnter must be a function") end
		if dataobj.OnLeave and type(dataobj.OnLeave) ~= "function" then error("dataobj.OnLeave must be a function") end

		namestorage[dataobj] = name
		attributestorage[dataobj] = {}
		for i,v in pairs(dataobj) do attributestorage[dataobj][i] = v end
		setmetatable(dataobj, lib.domt)

		callbacks:Fire("LibDataBroker_DataObjectCreated", name, dataobj)
		return dataobj
	end
end

if oldminor < 1 then
	function lib:DataObjectIterator()
		return pairs(attributestorage)
	end

	function lib:GetDataObjectByName(dataobjectname)
		for dataobj, name in pairs(namestorage) do
			if name == dataobjectname then return dataobj end
		end
	end

	function lib:GetNameByDataObject(dataobject)
		return namestorage[dataobject]
	end
end
