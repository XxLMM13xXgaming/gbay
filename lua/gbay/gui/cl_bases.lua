local PANEL = {};

AccessorFunc(PANEL, "vertices", "Vertices", FORCE_NUMBER) -- so you can call panel:SetVertices and panel:GetRotation
AccessorFunc(PANEL, "rotation", "Rotation", FORCE_NUMBER) -- so you can call panel:SetRotation and panel:GetRotation

function PANEL:Init()
  self.rotation = 0;
  self.vertices = 32;
  self.avatar = vgui.Create("AvatarImage", self);
  self.avatar:SetPaintedManually(true);
end

function PANEL:CalculatePoly(w, h)
  local poly = {};

  local x = w / 2;
  local y = h / 2;
  local radius = h / 2;

  table.insert(poly, { x = x, y = y });

  for i = 0, self.vertices do
    local a = math.rad((i / self.vertices) * -360) + self.rotation;
    table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius })
  end

  local a = math.rad(0)
  table.insert(poly, { x = x + math.sin(a) * radius, y = y + math.cos(a) * radius })
  self.data = poly;
end

function PANEL:PerformLayout()
  self.avatar:SetSize(self:GetWide(), self:GetTall());
  self:CalculatePoly(self:GetWide(), self:GetTall());
end

function PANEL:SetPlayer(ply, size)
  self.avatar:SetPlayer(ply, size);
end

function PANEL:SetSteamID(ply, size)
    self.avatar:SetSteamID(ply, size);
end

function PANEL:DrawPoly( w, h )
  if (!self.data) then
    self:CalculatePoly(w, h);
  end

  surface.DrawPoly(self.data);
end

function PANEL:Paint(w, h)
  render.ClearStencil();
  render.SetStencilEnable(true);

  render.SetStencilWriteMask(1);
  render.SetStencilTestMask(1);

  render.SetStencilFailOperation(STENCILOPERATION_REPLACE);
  render.SetStencilPassOperation(STENCILOPERATION_ZERO);
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER);
  render.SetStencilReferenceValue(1);

  draw.NoTexture();
  surface.SetDrawColor(color_white);
  self:DrawPoly(w, h);

  render.SetStencilFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilPassOperation(STENCILOPERATION_REPLACE);
  render.SetStencilZFailOperation(STENCILOPERATION_ZERO);
  render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL);
  render.SetStencilReferenceValue(1);

  self.avatar:PaintManual();

  render.SetStencilEnable(false);
  render.ClearStencil();
end
vgui.Register("EnhancedAvatarImage", PANEL);

moat_fireworks = {}
mf = moat_fireworks
mf.fireworks = {}
mf.peak = {min = 2, max = 5}
mf.particlepeak = {min = -40, max = 40}
mf.fireworkamt = {min = 70, max = 100}
mf.speed = 4
mf.particlespeed = 10
mf.color = Color(255, 255, 255)
mf.size = 6
mf.particlesize = 2
mf.explosionsize = 150

function mf.newfirework(p, x, y)
  local firework = {}
  firework.pos = {x, y, {}}
  firework.peak = math.Rand(mf.peak.min, mf.peak.max)
  firework.particlesize = math.random(40, mf.explosionsize)
  firework.particlenum = firework.particlesize
  firework.particles = {}
  firework.color = HSVToColor(math.random(360), 1, 1)
  firework.peaked = false
  table.insert(mf.fireworks, firework)
end

function mf.newparticle(f, x, y)
  local particle = {}
  local a = math.rad(math.random(360))
  particle.pos = {x, y, math.sin(a) * math.random(10, f.particlesize), math.cos(a) * math.random(10, f.particlesize)}
  particle.peaked = false
  table.insert(f.particles, particle)
end

net.Receive("GBayOpenCreateServer", function()
    local DFrame = vgui.Create( "DFrame" )
    DFrame:SetSize( 1000, 700 )
    DFrame:Center()
    DFrame:SetDraggable( false )
    DFrame:MakePopup()
    DFrame:SetTitle( "" )
    DFrame:ShowCloseButton( false )
    DFrame.Paint = function(s, w, h)
        surface.SetDrawColor(247,247,247)
        surface.DrawRect(0, 0, w, h)
    end

    local DFrameClose = vgui.Create("DButton", DFrame)
    DFrameClose:SetPos(DFrame:GetWide() - 40, 10)
    DFrameClose:SetSize(25, 25)
    DFrameClose:SetText("X")
    DFrameClose:SetFont("GBayCloseFont")
    DFrameClose:SetTextColor(Color(214, 214, 214))
    DFrameClose.DoClick = function()
        DFrame:Close()
    end
    DFrameClose.Paint = function(s, w, h)
    end

    local DFrameMin = vgui.Create("DButton", DFrame)
    DFrameMin:SetPos(DFrame:GetWide() - 60, 10)
    DFrameMin:SetSize(25, 25)
    DFrameMin:SetText("_")
    DFrameMin:SetFont("GBayCloseFont")
    DFrameMin:SetTextColor(Color(214, 214, 214))
    DFrameMin.DoClick = function()
        GBayMenuMin(DFrame)
    end
    DFrameMin.Paint = function(s, w, h)
    end

    GBaySideBarOpened(DFrame, "Settings", false, {}, true)
end)
