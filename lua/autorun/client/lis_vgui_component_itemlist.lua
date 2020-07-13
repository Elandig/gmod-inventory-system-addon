local PANEL = {}

local icon_size = 120
local offset = 13

function PANEL:GetListAspectRatio()

    local rw, rh = ScrW()/1920, ScrH()/1080
    local width, height = self:GetSize()    

    return {rw*math.floor(width/(icon_size+offset)), rh*math.floor(height/(icon_size+offset))}
    
end

function PANEL:Init()

    self.page = 0
    self.Paint = function () end
    self.canvas = vgui.Create("DPanel", self)
    self.canvas:SetSize(width, height)
    self.canvas.Paint = function () end

end

function PANEL:AddItems(data)

    -- Constants
    local SO = icon_size+offset 
    local rw, rh = ScrW()/1920, ScrH()/1080
    local AR = self:GetListAspectRatio()
    local width, height = self:GetSize()
    local max_columns = AR[1]+.000001


    local function createItemList()

        self.canvas:Remove()
        self.canvas = vgui.Create("DPanel", self)
        self.canvas:SetSize(width, height)
        self.canvas.Paint = function () end

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
            
            item:SetPos(rw*offset*1.5+rw*SO*(ind-7*math.floor(ind/max_columns)-1)+rw*width*page, rh*SO*1.2+rh*SO*(math.floor(ind/max_columns)-1))

            local icon = vgui.Create("SpawnIcon", item)
            icon:SetSize(rw*icon_size, rh*icon_size)
            icon:SetModel(v[2])

            local function nextPage()
                local x, y = self.canvas:GetPos()
                local w, h = self.canvas:GetSize()
                self.canvas:SetSize(w+w*page, h)
                self.canvas:MoveTo(x-width, y, 0.25)
            end
            local function prevPage()
                local x, y = self.canvas:GetPos()
                self.canvas:MoveTo(x+width, y, 0.25)
            end

            function icon:DoClick()
                net.Start("LIS_DropInventoryItem")
                net.WriteUInt(i, 16)
                net.SendToServer()
                table.remove(data, i)
                nextPage()
                createItemList(page)
            end
        end
    end
    createItemList()
end


vgui.Register("lis_itemlist", PANEL, "DPanel")