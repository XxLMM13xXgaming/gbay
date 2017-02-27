ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.PrintName = "Mail NPC"
ENT.Category = "GBay"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
