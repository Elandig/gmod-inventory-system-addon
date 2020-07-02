hook.Add( "Initialize", "LIS_CreateInventoryFolder", function()
	if not file.IsDir(LIS.CONFIG.SavePath, "DATA") then
        file.CreateDir(LIS.CONFIG.SavePath)
    end

    if not file.IsDir(LIS.CONFIG.SavePath.."/players", "DATA") then
        file.CreateDir(LIS.CONFIG.SavePath.."/players")
    end
end)

hook.Add("PlayerInitialSpawn", "LIS_CreateInventory", function(ply)
	ply:LIS_CreateInventory()
end)

hook.Add("PlayerDisconnected","LIS_SaveDisconnectedInventory", function(ply)
	ply:LIS_SaveInventory()
end)

hook.Add("ShutDown", "LIS_SaveIfServerShutdown", function()
	for _, ply in ipairs( player.GetAll() ) do
		ply:LIS_SaveInventory()
	end
end)

local meta = FindMetaTable("Player")

function meta:LIS_CreateInventory()
    local ID = string.Replace(self:SteamID(), ":", "_")
    local path = LIS.CONFIG.SavePath.."/players/"..ID..".txt"
    
	if file.Exists(path, "DATA") then
		self.LIS = {}
		self.LIS.Inventory = util.JSONToTable(file.Read(path))
	else
		self.LIS = {}
		self.LIS.Inventory = {}
		self:LIS_SaveInventory()
	end

	self.LIS.CanUse = true
end

function meta:LIS_GetInventory() return self.LIS.Inventory end

function meta:LIS_SaveInventory()
	if !(self.LIS) or !(self.LIS.Inventory) then self:LIS_CreateInventory() end

	local ID = string.Replace(self:SteamID(), ":", "_")
	file.Write(LIS.CONFIG.SavePath.."/players/"..ID..".txt", util.TableToJSON(self:LIS_GetInventory()))
end