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