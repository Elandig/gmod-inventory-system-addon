include("shared.lua")

ENT.TextColors = {
    OtherToSelf = Color(0, 255, 0, 255),
    SelfToSelf = Color(255, 255, 0, 255),
    SelfToOther = Color(0, 0, 255, 255),
    OtherToOther = Color(255, 0, 0, 255)
}

function ENT:Draw()
    self:DrawModel()
    --[=[local ply = LocalPlayer()

    local Pos = self:GetPos()
    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(self:GetAngles():Forward(), self.AngForward)
    Ang:RotateAroundAxis(self:GetAngles():Up(), self.AngUp)
    local Up = Ang:Up()
    local Right = Ang:Right()
    local Forward = Ang:Forward()
    Up:Mul(self.UpMul)
    Right:Mul(self.RightMul)
    Forward:Mul(self.ForwardMul)
    Pos:Add(Right)
    Pos:Add(Up)
    Pos:Add(Forward)

    surface.SetFont("ChatFont")
    local text = self.Resource.."/"..self.MaxResource

    cam.Start3D2D(Pos, Ang, 0.1)
        draw.DrawText(text, "ChatFont", 0, 0, Color(255,255,255,255),1)
    cam.End3D2D()]=]
end