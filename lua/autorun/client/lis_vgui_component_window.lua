local PANEL = {}

function PANEL:Init()

    -- Initialization
	self:SetTitle( "" )
	self:ShowCloseButton( false )
    self:SetDraggable( false )
    self:MakePopup()
    self.Paint = function () end
    
    self.accent_color = {66, 66, 72}

    self.background_canvas = vgui.Create("DPanel", self)
    self.bar_canvas = vgui.Create("DPanel", self)

    if LIS.CONFIG.EnableSwitchButton then
        self.switch_button = vgui.Create("DImageButton", self.bar_canvas)
    end
    
    if LIS.CONFIG.ShowCloseButton then
        self.close_button = vgui.Create("DImageButton", self.bar_canvas)
        self.close_button:SetImage("vgui/lis_vgui_close.png")
        local c = LIS.CONFIG.BaseWindowCloseButtonColor or LIS.CONFIG.SecondaryAccentColor or {143, 174, 191, 170}
        self.close_button:SetColor(Color(c[1], c[2], c[3], c[4]))
        self.close_button.DoClick = function()
            hook.Remove("GUIMousePressed", "LIS_closeCompactInventory")
            self:Close()
        end
    end

    self:UpdateRender()

end

function PANEL:EnableWindowSwitchButton(mode)

    if !(mode == "compact" or mode == "regular") then return end
    if !LIS.CONFIG.EnableSwitchButton then return end

    if mode == "compact" then
        self.switch_button:SetImage("vgui/lis_vgui_maximize.png")
    elseif mode == "regular" then
        self.switch_button:SetImage("vgui/lis_vgui_restore.png")
    end

    local c = LIS.CONFIG.BaseWindowCloseButtonColor or LIS.CONFIG.SecondaryAccentColor or {143, 174, 191, 170}
    self.switch_button:SetColor(Color(c[1], c[2], c[3], c[4]))
    
end

function PANEL:UpdateRender()

    local rw, rh = ScrW()/1920, ScrH()/1080
    local w, h = self:GetSize()
    
    self.bar_canvas:SetSize(w, rh*27)
    self.background_canvas:SetSize(w, h-rh*27)

    self.bar_canvas:SetPos(0,0)
    self.background_canvas:SetPos(0, rh*27)

    if LIS.CONFIG.ShowCloseButton then
        self.close_button:SetSize(rw*12,rh*12)
        self.close_button:SetPos(rw*w-21, rh*7)
        if LIS.CONFIG.EnableSwitchButton then
            self.switch_button:SetSize(rw*12,rh*12)
            self.switch_button:SetPos(rw*w-42,rh*7)
        end
    else
        if LIS.CONFIG.EnableSwitchButton then
            self.switch_button:SetSize(rw*12,rh*12)
            self.switch_button:SetPos(rw*w-21,rh*7)
        end
    end
    

    local br_color
    if LIS.CONFIG.BaseWindowBarColor then
        local c = LIS.CONFIG.BaseWindowBarColor
        br_color = Color(c[1], c[2], c[3], c[4])
    else
        local c = self.accent_color
        br_color = Color(c[1], c[2], c[3], 255)
    end

    self.bar_canvas.Paint = function(self, _w, _h)
        draw.RoundedBoxEx(10, 0, 0, _w, _h, br_color, true, true, false, false)
    end

    local bg_color
    if LIS.CONFIG.BaseWindowBackgroundColor then
        local c = LIS.CONFIG.BaseWindowBackgroundColor
        bg_color = Color(c[1], c[2], c[3], c[4])
    else
        local c = self.accent_color
        bg_color = Color(c[1], c[2], c[3], 217)
    end

    self.background_canvas.Paint = function(self, _w, _h)
        draw.RoundedBox(0, 0, 0, _w, _h, bg_color)
    end

end

function PANEL:SetColor(c)
    
    if #c < 4 then return Error("Lucid Inventory System: Invalid accent color") end
    self.accent_color = c
    self:UpdateRender()

end

vgui.Register("lis_window_base", PANEL, "DFrame")