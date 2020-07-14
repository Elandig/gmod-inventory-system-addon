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

    self.canvas:MoveTo(x-width, y, 0.25, 0, -1)
    self.page = self.page + 1

end

function PANEL:prevPage()

    local width, _ = self:GetSize()
    local x, y = self.canvas:GetPos()

    self.canvas:MoveTo(x+width, y, 0.25, 0, -1)
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
        timer.Simple(0.5, function()
            self.lock = false
        end)

    end

end

function PANEL:AddItems(data)

    -- Constants
    local SO = icon_size+offset 
    local rw, rh = ScrW()/1920, ScrH()/1080
    local AR = self:GetListAspectRatio()
    local width, height = self:GetSize()
    local max_columns = AR[1]+.000001

    self.page = 0
    self.size = #data
    self.pages = math.floor(self.size/(AR[1]*AR[2]))

    local function resizeCanvas()

        local w, h = self.canvas:GetSize()
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

        local items = {}
        local page = 0
        local l_page_ind = 0
        for i, v in pairs(data) do

            local item = vgui.Create("DPanel", self.canvas)
            item:SetSize(rw*icon_size, rh*icon_size)

            local ind = i - AR[1]*AR[2] * page

            if ind > AR[1]*AR[2] then
                page = page + 1
            end

            ind = i - AR[1]*AR[2] * page

            item:SetPos(rw*offset*1.5+rw*SO*(ind-max_columns*math.floor(ind/max_columns)-1)+rw*width*page, rh*SO*1.2+rh*SO*(math.floor(ind/max_columns)-1)-rh*offset)

            local icon = vgui.Create("SpawnIcon", item)
            icon:SetSize(rw*icon_size, rh*icon_size)
            icon:SetModel(v[2])

            function icon:DoClick()

                if self.lock then return end

                net.Start("LIS_DropInventoryItem")
                net.WriteUInt(i, 16)
                net.SendToServer()
                table.remove(data, i)
                createItemList(true)

            end

        end

    end

    createItemList()

end


vgui.Register("lis_itemlist", PANEL, "DPanel")