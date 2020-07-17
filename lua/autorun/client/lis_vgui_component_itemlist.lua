local PANEL = {}

local icon_size = 120
local offset = 13

function PANEL:Init()

    self.page = 0
    self.size = 0
    self.lock = false
    self.Paint = function () end
    self.canvas = vgui.Create("DPanel", self)
    self.canvas:SetSize(width, height)
    self.canvas.Paint = function () end
    self.drop_callback = function () end
    self.data = {}
    self.onlyOnce = false

end

function PANEL:GetListAspectRatio()

    local rw, rh = ScrW()/1920, ScrH()/1080
    local width, height = self:GetSize()    

    return {rw*math.floor(width/(icon_size+offset)), rh*math.floor(height/(icon_size+offset))}
    
end

function PANEL:nextPage()

    local width, _ = self:GetSize()
    local x, y = self.canvas:GetPos()
    local w, h = self.canvas:GetSize()
    local AR = self:GetListAspectRatio()

    self.canvas:MoveTo(x-width, y, LIS.CONFIG.ScrollAnimationTime or 0.25, 0, -1)
    self.page = self.page + 1

end

function PANEL:prevPage()

    local width, _ = self:GetSize()
    local x, y = self.canvas:GetPos()

    self.canvas:MoveTo(x+width, y, LIS.CONFIG.ScrollAnimationTime or 0.25, 0, -1)
    self.page = self.page - 1

end

function PANEL:OnMouseWheeled(dt)

    if not self.lock then

        if dt == -1 and self.page < self.pages then
            self:nextPage()
        elseif dt == 1 and self.page > 0 then
            self:prevPage()
        end

        -- Input lock to prevent user from breaking the GUI during the animation
        self.lock = true
        timer.Simple(0.25+LIS.CONFIG.ScrollAnimationTime, function()
            self.lock = false
        end)

    end

end

function PANEL:AddItems(data)

    self.data = data

    -- Constants
    local SO = icon_size+offset 
    local rw, rh = ScrW()/1920, ScrH()/1080
    local AR = self:GetListAspectRatio()
    local width, height = self:GetSize()
    local max_columns = AR[1]+.000001

    self.page = 0

    local function resizeCanvas()

        local w, h = self.canvas:GetSize()

        self.size = #self.data
        self.pages = math.floor((self.size-1)/(AR[1]*AR[2]))
        self.canvas:SetSize(w+w*(self.pages+1), h)

    end

    local function restorePage()

        local x, y = self.canvas:GetPos()

        self.canvas:SetPos(x-width*self.page, y)

    end

    local function createItemList(state)

        self.canvas:Remove()
        self.canvas = vgui.Create("DPanel", self)
        self.canvas:SetSize(width, height)
        self.canvas.Paint = function () end
        resizeCanvas()
        
        if state then
            restorePage()
        else
            self.page = 0
        end

        if self.page > self.pages then
            self.lock = false
            self:prevPage()
        end

        local items = {}
        local page = 0
        local l_page_ind = 0
        local i = 1
        for _i, v in pairs(self.data) do

            local item = vgui.Create("DPanel", self.canvas)
            item:SetSize(rw*icon_size, rh*icon_size)

            local ind = i - AR[1]*AR[2] * page

            if ind > AR[1]*AR[2] then
                page = page + 1
            end

            ind = i - AR[1]*AR[2] * page

            local offset_x = (width-rw*(SO*AR[1]-offset))/2
            local offset_y = (height-rh*(SO*AR[2]-offset))/2
            
            item:SetPos(offset_x+rw*SO*(ind-max_columns*math.floor(ind/max_columns)-1)+rw*width*page, rh*SO+rh*SO*(math.floor(ind/max_columns)-1)+offset_y)

            local icon = vgui.Create("SpawnIcon", item)
            icon:SetSize(rw*icon_size, rh*icon_size)
            icon:SetModel(v[2])

            -- We can't access the current scope inside the icon:DoClick()
            local _self = self

            function icon:DoClick()

                if _self.lock then return end

                net.Start("LIS_DropInventoryItem")
                net.WriteUInt(_i, 16)
                net.SendToServer()
                table.remove(_self.data, _i)
                createItemList(true)

            end

            i = i + 1

        end

    end

    self.cb_drop_failed = function(data)
        self.data = data
        createItemList(true)
    end

    createItemList(self.onlyOnce)
    self.onlyOnce = true
end

vgui.Register("lis_itemlist", PANEL, "DPanel")