net.Receive("LIS_DrawPlayerInventory", function()

	local rw, rh = ScrW()/1920, ScrH()/1080
    local ply = LocalPlayer()

    local style = net.ReadString() 
    local data = net.ReadTable()

    PrintTable(data)
end)