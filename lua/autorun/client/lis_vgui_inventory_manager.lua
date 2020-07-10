LIS = LIS or {}

net.Receive("LIS_DrawPlayerInventory", function()

    local style,data = net.ReadString(), net.ReadTable()

    LIS.CreateCompactInventory(data)
end)
