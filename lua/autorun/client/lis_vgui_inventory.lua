local function createCompactInventory(data)
    local rw, rh = ScrW()/1920, ScrH()/1080
    local ply = LocalPlayer()

    surface.CreateFont("Font", {font = "Arial",extended = false,size = 20,})
    
    local frame = vgui.Create("DFrame")
    frame:SetTitle("")
    frame:SetSize(rw*LIS.CONFIG.CompactInventoryWidth, rh*LIS.CONFIG.CompactInventoryHeight)
    frame:SetPos(0, rh*40)
    frame:MakePopup()
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame.Paint = function(self, w, h)
        draw.RoundedBoxEx(20, 0, 0, w, h, Color(255,255,255,200), false, true, false, true)
    end
    hook.Add("GUIMousePressed", "closeCompactInventory", function(cmd)
        frame:Close()
    end)

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)

    local item_list = vgui.Create("DIconLayout", scroll)
    item_list:Dock(FILL)
    item_list:SetSpaceY(rh*18)
    for i, v in pairs(data) do
        local item = item_list:Add("DPanel")
        item:SetSize(rw*LIS.CONFIG.CompactInventoryWidth, 120*rh)

        local icon = vgui.Create( "SpawnIcon" , item)
        icon:SetSize(rw*LIS.CONFIG.CompactInventoryWidth,rh*LIS.CONFIG.CompactInventoryWidth/2)
        icon:SetModel(v[2])

        function icon:DoClick()
            net.Start("LIS_DropInventoryItem")
            net.WriteUInt(i, 16)
            net.SendToServer()
            frame:Close()
        end
    end
end

net.Receive("LIS_DrawPlayerInventory", function()

    local style,data = net.ReadString(), net.ReadTable()

    if LIS.CONFIG.InventoryType == "compact" then
        createCompactInventory(data)
    else
        -- todo
    end
end)
