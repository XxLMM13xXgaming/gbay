include("gbay/gui/cl_fonts.lua")
include("gbay/mysql/cl_mysql.lua")
include("gbay/gui/cl_bases.lua")
include("gbay/gui/cl_loading.lua")
include("gbay/gui/cl_sidebar.lua")
include("gbay/gui/cl_orderpage.lua")
include("gbay/gui/cl_homepage.lua")
include("gbay/gui/cl_updates.lua")
include("gbay/shipment/cl_shipment.lua")
include("gbay/service/cl_service.lua")
include("gbay/entity/cl_entity.lua")

local plymeta = FindMetaTable("Player")

function plymeta:GBayIsSuperAdmin(data)
	for k, v in pairs(data[1]) do
		if v[2] == self:SteamID64() then
			playerdata = v
		end
	end
	if playerdata[3] == "Superadmin" then return true else return false end
end

function plymeta:GBayIsAdmin(data)
	for k, v in pairs(data[1]) do
		if v[2] == self:SteamID64() then
			playerdata = v
		end
	end
	if playerdata[3] == "Admin" or playerdata[3] == "Superadmin" then return true else return false end
end

net.Receive("GBayNotify",function()
	local type = net.ReadString()
	local message = net.ReadString()
	if type == "generic" then
		chat.AddText(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] ", Color(255,255,255), message)
	elseif type == "error" then
		chat.AddText(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] ", Color(255,0,0), message)
	else
		chat.AddText(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] ", Color(255,255,255), message)
	end
end)

function GBayErrorMessage(msg)
	chat.AddText(Color(255,0,0), msg)
end

function GBaySelectWeapon(DFrame, thebutton)
	DFrame:SetVisible(false)
	LocalPlayer().GBayIsSelectingWeapon = true

	hook.Add( "KeyPress", "GBaySelectedWeapon", function( ply, key )
		if key == IN_SPEED and LocalPlayer().GBayIsSelectingWeapon then
			LocalPlayer().GBayIsSelectingWeapon = false
			if LocalPlayer():GetEyeTrace().Entity:GetClass() != "spawned_shipment" then
				chat.AddText(Color(255,0,0), "Please place crosshair on a shipment then press shift!")
				LocalPlayer().GBayIsSelectingWeapon = true
			else
				local gunpicked = false
				for k, v in pairs(CustomShipments) do
					if v.name == CustomShipments[LocalPlayer():GetEyeTrace().Entity:Getcontents()].name then
						DFrame:SetVisible(true)
						thebutton.Weapon = LocalPlayer():GetEyeTrace().Entity
						thebutton:SetText(v.name.." (click button again to change)")
						gunpicked = true
					end
				end
			end
		elseif key == IN_DUCK and LocalPlayer().GBayIsSelectingWeapon then
			LocalPlayer().GBayIsSelectingWeapon = false
			DFrame:SetVisible(true)
		end
	end )
end

function GBaySelectEntity(DFrame, thebutton)
	DFrame:SetVisible(false)
	LocalPlayer().GBayIsSelectingEntity = true

	hook.Add( "KeyPress", "GBaySelectedWeapon", function( ply, key )
		if key == IN_SPEED and LocalPlayer().GBayIsSelectingEntity then
			LocalPlayer().GBayIsSelectingEntity = false
			local gunpicked = false
			DFrame:SetVisible(true)
			thebutton.Entity = LocalPlayer():GetEyeTrace().Entity
			thebutton:SetText(LocalPlayer():GetEyeTrace().Entity:GetClass().." (click button again to change)")
			gunpicked = true
		elseif key == IN_DUCK and LocalPlayer().GBayIsSelectingEntity then
			LocalPlayer().GBayIsSelectingEntity = false
			DFrame:SetVisible(true)
		end
	end )
end

hook.Add("HUDPaint","GBaySelBound",function()
	if LocalPlayer().GBayIsSelectingWeapon then
		draw.SimpleText("Press Shift when item is in crosshair or press CTRL to cancel!","GBayLabelFont",ScrW()/2,ScrH()/2 - 80,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
	elseif LocalPlayer().GBayIsSelectingEntity then
		draw.SimpleText("Press Shift when item is in crosshair or press CTRL to cancel!","GBayLabelFont",ScrW()/2,ScrH()/2 - 80,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
	end
end)

net.Receive("GBayOpenMenu",function()
	LocalPlayer().GBayOpenMenuTabStatus = false
	data = net.ReadTable()
	PrintTable(data)
	DFrame = vgui.Create( "DFrame" )
	DFrame:SetSize( 1000, 700 )
	DFrame:Center()
	DFrame:SetDraggable( false )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
	DFrame.Paint = function(s, w, h)
		surface.SetDrawColor(247,247,247)
    surface.DrawRect(0, 0, w, h)

		if LocalPlayer().GBayOpenMenuTabStatus then
			draw.RoundedBox(0,350,120,w - 350 - 100,2,Color(221,221,221))
			draw.RoundedBox(0,350,160,w - 350 - 100,2,Color(221,221,221))
		else
			draw.RoundedBox(0,100,120,w - 200,2,Color(221,221,221))
			draw.RoundedBox(0,100,160,w - 200,2,Color(221,221,221))
			draw.RoundedBox(0,300,130,2,25,Color(221, 221, 221))
		end
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

	HomeBTN = vgui.Create("DButton", DFrame)
	HomeBTN:SetPos(140, 130)
	HomeBTN:SetText("Home")
	HomeBTN:SetFont("GBayLabelFontBold")
	HomeBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	HomeBTN:SizeToContents()
	HomeBTN.Paint = function() end
	HomeBTN.DoClick = function()
		GBayHomePageFull(DFrame, data)
		LocalPlayer().TabCurrentlyOn = "Home"
		GBaySideBarClosed(DFrame, "Dashboard", false, data, false)
	end

	UpdatesBTN = vgui.Create("DButton", DFrame)
	UpdatesBTN:SetPos(210, 130)
	UpdatesBTN:SetText("Updates")
	UpdatesBTN:SetFont("GBayLabelFontBold")
	UpdatesBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	UpdatesBTN:SizeToContents()
	UpdatesBTN.Paint = function() end
	UpdatesBTN.DoClick = function()
		GBayViewUpdatesFull(DFrame, data)
		LocalPlayer().TabCurrentlyOn = "Updates"
	end

	ShipmentsBTN = vgui.Create("DButton", DFrame)
	ShipmentsBTN:SetPos(320, 130)
	ShipmentsBTN:SetText("Shipments")
	ShipmentsBTN:SetFont("GBayLabelFontBold")
	ShipmentsBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	ShipmentsBTN:SizeToContents()
	ShipmentsBTN.Paint = function() end
	ShipmentsBTN.DoClick = function()
		if LocalPlayer().GBayOpenMenuTabStatus then
			GBayShipmentsPageSmall(DFrame, data)
		else
			GBayShipmentsPageFull(DFrame, data)
		end
	end

	EntitiesBTN = vgui.Create("DButton", DFrame)
	EntitiesBTN:SetPos(420, 130)
	EntitiesBTN:SetText("Entities")
	EntitiesBTN:SetFont("GBayLabelFontBold")
	EntitiesBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	EntitiesBTN:SizeToContents()
	EntitiesBTN.Paint = function() end
	EntitiesBTN.DoClick = function()
		if LocalPlayer().GBayOpenMenuTabStatus then
			GBayEntityPageSmall(DFrame, data)
		else
			GBayEntityPageFull(DFrame, data)
		end
	end

	ServicesBTN = vgui.Create("DButton", DFrame)
	ServicesBTN:SetPos(500, 130)
	ServicesBTN:SetText("Services")
	ServicesBTN:SetFont("GBayLabelFontBold")
	ServicesBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	ServicesBTN:SizeToContents()
	ServicesBTN.Paint = function() end
	ServicesBTN.DoClick = function()
		if LocalPlayer().GBayOpenMenuTabStatus then
			GBayServicePageSmall(DFrame, data)
		else
			GBayServicePageFull(DFrame, data)
		end
	end

	AdsBTN = vgui.Create("DButton", DFrame)
	AdsBTN:SetPos(590, 130)
	AdsBTN:SetText("Advertisments")
	AdsBTN:SetFont("GBayLabelFontBold")
	AdsBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	AdsBTN:SizeToContents()
	AdsBTN.Paint = function() end
	AdsBTN.DoClick = function()

	end

	StaffBTN = vgui.Create("DButton", DFrame)
	StaffBTN:SetPos(730, 130)
	StaffBTN:SetText("Staff")
	StaffBTN:SetFont("GBayLabelFontBold")
	StaffBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	StaffBTN:SizeToContents()
	StaffBTN.Paint = function() end
	StaffBTN.DoClick = function()

	end

	SettingsBTN = vgui.Create("DButton", DFrame)
	SettingsBTN:SetPos(800, 130)
	SettingsBTN:SetText("Settings")
	SettingsBTN:SetFont("GBayLabelFontBold")
	SettingsBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	SettingsBTN:SizeToContents()
	SettingsBTN.Paint = function() end
	SettingsBTN.DoClick = function()
		GBaySideBarOpened(DFrame, "Dashboard", true, data, false)
	end

	LocalPlayer().TabCurrentlyOn = "Home"
	GBaySideBarClosed(DFrame, "Dashboard", false, data, false)
	GBayHomePageFull(DFrame, data)
	hook.Add("GBaySideBarClosed","CheckToSeeIfSidebarOpened",function()
		if LocalPlayer().TabCurrentlyOn == "Home" then
			GBayHomePageFull(DFrame, data)
		elseif LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemFull(LocalPlayer().GBayOrderType, DFrame, data, LocalPlayer().GBayOrderItem)
		else
			GBayHomePageFull(DFrame, data)
		end
		HomeBTN:SetDisabled( false )
		HomeBTN:SetText("Home")
		UpdatesBTN:SetDisabled( false )
		UpdatesBTN:SetText("Updates")
		ShipmentsBTN:SetPos(320, 130)
		EntitiesBTN:SetPos(420, 130)
		ServicesBTN:SetPos(500, 130)
		AdsBTN:SetPos(590, 130)
		AdsBTN:SetText("Advertisments")
		StaffBTN:SetPos(730, 130)
		SettingsBTN:SetPos(800, 130)
	end)

	hook.Add("GBaySideBarOpened","CheckToSeeIfSidebarOpened",function()
		if LocalPlayer().TabCurrentlyOn == "Home" then
			GBayHomePageSmall(DFrame, data)
		elseif LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemSmall(LocalPlayer().GBayOrderType, DFrame, data, LocalPlayer().GBayOrderItem)
		else
			GBayHomePageSmall(DFrame, data)
		end
		HomeBTN:SetDisabled( true )
		HomeBTN:SetText("")
		UpdatesBTN:SetDisabled( true )
		UpdatesBTN:SetText("")
		ShipmentsBTN:SetPos(370, 130)
		EntitiesBTN:SetPos(470, 130)
		ServicesBTN:SetPos(550, 130)
		AdsBTN:SetPos(600, 130)
		AdsBTN:SetText("Ads")
		StaffBTN:SetPos(700, 130)
		SettingsBTN:SetPos(770, 130)
	end)
end)

concommand.Add("gbaytestcl",function()
	print(GBayConfig.ServerName)
end)
