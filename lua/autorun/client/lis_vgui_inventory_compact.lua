LIS = LIS or {}

function LIS.CreateCompactInventory(data)
    local ply = LocalPlayer()

    -- Constants
    local rw, rh = ScrW()/1920, ScrH()/1080
    local width, height = 960, 300
    local pos_x, pos_y = 480, 780
    local anim_time = LIS.CONFIG.AnimationTime or 0.25

    surface.CreateFont("Font", {font = "Arial",extended = false,size = 20})
    

    -- Base window
    local frame = vgui.Create("lis_window_base")
    frame:SetSize(rw*width, rh*height)
    frame:SetPos(rw*pos_x, rh*pos_y+height) -- Set window position/Add height for the animation
    frame:SetColor(LIS.CONFIG.PrimaryAccentColor)
    frame:UpdateRender()
    frame:MoveTo(rw*pos_x, rh*pos_y, anim_time) -- Animation - Move to the original position

    local base = frame:GetBase()
    local b_width, b_height = base:GetSize()

    local itemlist = vgui.Create("lis_itemlist", base)
    itemlist:SetSize(rw*b_width, rh*b_height)
    itemlist:AddItems(data)

    -- Item list constructor
    --[[local function createItemList(scroll_pos)

        -- Constants
        local size = 120
        local space = 13
        local max_columns = 7+.000001
        local max_rows = 2

        local items = {}
        local page = 1
        local l_page_ind = 0
        for i, v in pairs(data) do

            -- Responsive item list
            local item = vgui.Create("DPanel", frame)
            item:SetSize(rw*size, rh*size)
            local ind = i - l_page_ind * page
            if ind > max_columns*max_rows then
                page = page + 1
            end
            item:SetPos(rw*space*1.5+rw*(size+space)*(ind-7*math.floor(ind/max_columns)-1), rh*(size+space)*1.2+rh*(size+space)*(math.floor(ind/max_columns)-1))

            -- Item model
            local icon = vgui.Create("SpawnIcon", item)
            icon:SetSize(rw*size, rh*size)
            icon:SetModel(v[2])

            -- Handle click
            function icon:DoClick()
                net.Start("LIS_DropInventoryItem")
                net.WriteUInt(i, 16)
                net.SendToServer()
                table.remove(data, i)
                item:Remove()
                createItemList()
            end
        end
    end
    createItemList()]]

    -- Optional mouse toggle closing
    if LIS.CONFIG.MouseToggle then
        hook.Add("GUIMousePressed", "closeCompactInventory", function(cmd)
            if frame ~= nil then
                frame:MoveTo(rw*pos_x, rh*pos_y+height, anim_time, 0, -1, function()
                        frame:Close()
                        hook.Remove("GUIMousePressed", "closeCompactInventory")
                end)
            else
                hook.Remove("GUIMousePressed", "closeCompactInventory")
            end
        end)
    end
end