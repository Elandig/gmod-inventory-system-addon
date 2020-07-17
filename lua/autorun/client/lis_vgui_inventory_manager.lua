LIS = LIS or {}

local cb_drop_failed

net.Receive("LIS_DrawPlayerInventory", function()

    local style,data = net.ReadString(), net.ReadTable()

    cb_drop_failed = LIS.CreateCompactInventory(data)
end)

net.Receive("LIS_InventoryItemDropFailed", function()

    local data = net.ReadTable()

    -- Callback from the server to refresh the item list if something went wrong
    cb_drop_failed(data)

end)