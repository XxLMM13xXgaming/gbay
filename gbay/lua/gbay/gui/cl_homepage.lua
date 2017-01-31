function GBayHomePageFull(DFrame, data)
	if IsValid(HomePanel) then HomePanel:Remove() end
	if !IsValid(DFrame) then return end
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(50, 180)
	HomePanel:SetSize( DFrame:GetWide() - 60, DFrame:GetTall() - 190 )
	HomePanel:SetDraggable( false )
	HomePanel:SetTitle( "" )
	HomePanel:ShowCloseButton( false )
	HomePanel.Paint = function() end

	local ScrollList = vgui.Create( "DPanelList", HomePanel )
	ScrollList:SetPos( 50, 0 )
	ScrollList:SetSize( HomePanel:GetWide(), HomePanel:GetTall() - 55 )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 20 )
	ScrollList:EnableVerticalScrollbar( true )

	local CreateItemPage = vgui.Create("DButton", HomePanel)
	CreateItemPage:SetPos(HomePanel:GetWide() - 30, HomePanel:GetTall() - 30)
	CreateItemPage:SetSize(25, 25)
	CreateItemPage:SetText("+")
	CreateItemPage:SetFont("GBayLabelFontLarge")
	CreateItemPage:SetTextColor(Color(214, 214, 214))
	CreateItemPage.DoClick = function()
		GBaySideBarOpened(DFrame, "Create", false, data, false)
	end
	CreateItemPage.Paint = function(s, w, h)
	end

	for k, v in pairs(data[3]) do
		local ItemMain = vgui.Create("DFrame")
		ItemMain:SetSize( 270, 130 )
		ItemMain:SetDraggable( false )
		ItemMain:SetTitle( "" )
		ItemMain:ShowCloseButton( false )
		ItemMain.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h - 30,Color(238,238,238))
			draw.RoundedBox(0,2,2,w - 4,h - 34,Color(255,255,255))
			draw.RoundedBox(0,0,0,100,100,Color(238,238,238))
		end

		if LocalPlayer():GBayIsAdmin(data) then
			local ViewMoreBTN = vgui.Create("DButton",ItemMain)
			ViewMoreBTN:SetPos(5, ItemMain:GetTall() - 20)
			ViewMoreBTN:SetSize(80, 20)
			ViewMoreBTN:SetText("View More")
			ViewMoreBTN:SetTextColor(Color(185,201,229))
			ViewMoreBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			ViewMoreBTN.DoClick = function()
				GBayViewMoreItemFull("Shipment", DFrame, data, v)
			end

			local EditBTN = vgui.Create("DButton",ItemMain)
			EditBTN:SetPos(95, ItemMain:GetTall() - 20)
			EditBTN:SetSize(80, 20)
			EditBTN:SetText("Edit")
			EditBTN:SetTextColor(Color(255,0,0))
			EditBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end

			local RemoveBTN = vgui.Create("DButton",ItemMain)
			RemoveBTN:SetPos(185, ItemMain:GetTall() - 20)
			RemoveBTN:SetSize(80, 20)
			RemoveBTN:SetText("Remove")
			RemoveBTN:SetTextColor(Color(255,0,0))
			RemoveBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
		else
			local ViewMoreBTN = vgui.Create("DButton",ItemMain)
			ViewMoreBTN:SetPos(20, ItemMain:GetTall() - 20)
			ViewMoreBTN:SetSize(ItemMain:GetWide() - 40, 20)
			ViewMoreBTN:SetText("View More")
			ViewMoreBTN:SetTextColor(Color(185,201,229))
			ViewMoreBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			ViewMoreBTN.DoClick = function()
				GBayViewMoreItemFull("Shipment", DFrame, data, v)
			end
		end

		local theweaponpic = false

		if file.Exists("materials/vgui/entities/"..v[5]..".vmt","GAME") then
			theweaponpic = "vgui/entities/"..v[5]..".vmt"
		elseif file.Exists("materials/entities/"..v[5]..".png","GAME") then
			theweaponpic = "entities/"..v[5]..".png"
		end

		local WeaponModel = vgui.Create("DImage", ItemMain)
		WeaponModel:SetPos(0,0)
		WeaponModel:SetSize(100, 100)
		WeaponModel:SetImage(theweaponpic)

		local ItemName = vgui.Create("DLabel", ItemMain)
		ItemName:SetPos(110, 10)
		ItemName:SetSize(ItemMain:GetWide(), 20)
		ItemName:SetText(v[3])
		ItemName:SetTextColor(Color(0,0,0))
		ItemName:SetFont("GBayLabelFontSmall")

		local UserRatingText = vgui.Create("DLabel", ItemMain)
		UserRatingText:SetPos(110, 30)
		UserRatingText:SetSize(ItemMain:GetWide(), 20)
		UserRatingText:SetText("User Rating: ")
		UserRatingText:SetTextColor(Color(0,0,0))
		UserRatingText:SetFont("GBayLabelFontSmall")

		local thestars = 0
		local numbers = {data[1][1][4], -data[1][1][5], -data[1][1][6]}
		local sum = 0
		local total = 0
		for i = 1, #numbers do
		    sum = sum + numbers[i]
		    total = total + math.abs(numbers[i])
		end
		local percent = math.Round(numbers[1]/total * 100, 1)

		if percent <= 20 then thestars = 1 end
		if percent <= 40 then thestars = 2 end
		if percent <= 60 then thestars = 3 end
		if percent <= 80 then thestars = 4 end
		if percent <= 100 then thestars = 5 end

		local theposforstars = 185
		for i=1, thestars do
			local RatingStars = vgui.Create("DImage", ItemMain)
			RatingStars:SetPos(theposforstars,35)
			RatingStars:SetSize(10, 10)
			RatingStars:SetImage("gbay/Star128.png")
			theposforstars = theposforstars + 15
		end

		local UserRatingText = vgui.Create("DLabel", ItemMain)
		UserRatingText:SetPos(110, 50)
		UserRatingText:SetSize(ItemMain:GetWide(), 20)
		UserRatingText:SetText("Price: "..DarkRP.formatMoney(v[6]))
		UserRatingText:SetTextColor(Color(0,0,0))
		UserRatingText:SetFont("GBayLabelFontSmall")

		local PlayerAvatar = vgui.Create("EnhancedAvatarImage", ItemMain)
		PlayerAvatar:SetPos( ItemMain:GetWide() - 40, 60 )
		PlayerAvatar:SetSize( 34, 34 )
		PlayerAvatar:SetSteamID( v[2], 64 )

		ScrollList:AddItem(ItemMain)
	end
end

function GBayHomePageSmall(DFrame, data)
	if IsValid(HomePanel) then HomePanel:Remove() end
	if !IsValid(DFrame) then return end
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(290, 180)
	HomePanel:SetSize( DFrame:GetWide() - 300, DFrame:GetTall() - 190 )
	HomePanel:SetDraggable( false )
	HomePanel:SetTitle( "" )
	HomePanel:ShowCloseButton( false )
	HomePanel.Paint = function() end

	local ScrollList = vgui.Create( "DPanelList", HomePanel )
	ScrollList:SetPos( 50, 0 )
	ScrollList:SetSize( HomePanel:GetWide(), HomePanel:GetTall() )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 20 )
	ScrollList:EnableVerticalScrollbar( true )

	local CreateItemPage = vgui.Create("DButton", HomePanel)
	CreateItemPage:SetPos(HomePanel:GetWide() - 30, HomePanel:GetTall() - 30)
	CreateItemPage:SetSize(25, 25)
	CreateItemPage:SetText("+")
	CreateItemPage:SetFont("GBayLabelFontLarge")
	CreateItemPage:SetTextColor(Color(214, 214, 214))
	CreateItemPage.DoClick = function()
		GBaySideBarOpened(DFrame, "Create", false, data, false)
	end
	CreateItemPage.Paint = function(s, w, h)
	end

	for k, v in pairs(data[3]) do
		local ItemMain = vgui.Create("DFrame")
		ItemMain:SetSize( 270, 130 )
		ItemMain:SetDraggable( false )
		ItemMain:SetTitle( "" )
		ItemMain:ShowCloseButton( false )
		ItemMain.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h - 30,Color(238,238,238))
			draw.RoundedBox(0,2,2,w - 4,h - 34,Color(255,255,255))
			draw.RoundedBox(0,0,0,100,100,Color(238,238,238))
		end

		if LocalPlayer():GBayIsAdmin(data) then
			local ViewMoreBTN = vgui.Create("DButton",ItemMain)
			ViewMoreBTN:SetPos(20, ItemMain:GetTall() - 20)
			ViewMoreBTN:SetSize(50, 20)
			ViewMoreBTN:SetText("View More")
			ViewMoreBTN:SetTextColor(Color(185,201,229))
			ViewMoreBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
		else
			local ViewMoreBTN = vgui.Create("DButton",ItemMain)
			ViewMoreBTN:SetPos(20, ItemMain:GetTall() - 20)
			ViewMoreBTN:SetSize(ItemMain:GetWide() - 40, 20)
			ViewMoreBTN:SetText("View More")
			ViewMoreBTN:SetTextColor(Color(185,201,229))
			ViewMoreBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
		end

		local theweaponpic = false

		if file.Exists("materials/vgui/entities/"..v[5]..".vmt","GAME") then
			theweaponpic = "vgui/entities/"..v[5]..".vmt"
		elseif file.Exists("materials/entities/"..v[5]..".png","GAME") then
			theweaponpic = "entities/"..v[5]..".png"
		end

		local WeaponModel = vgui.Create("DImage", ItemMain)
		WeaponModel:SetPos(0,0)
		WeaponModel:SetSize(100, 100)
		WeaponModel:SetImage(theweaponpic)

		local ItemName = vgui.Create("DLabel", ItemMain)
		ItemName:SetPos(110, 10)
		ItemName:SetSize(ItemMain:GetWide(), 20)
		ItemName:SetText(v[3])
		ItemName:SetTextColor(Color(0,0,0))
		ItemName:SetFont("GBayLabelFontSmall")

		local UserRatingText = vgui.Create("DLabel", ItemMain)
		UserRatingText:SetPos(110, 30)
		UserRatingText:SetSize(ItemMain:GetWide(), 20)
		UserRatingText:SetText("User Rating: ")
		UserRatingText:SetTextColor(Color(0,0,0))
		UserRatingText:SetFont("GBayLabelFontSmall")

		local thestars = 0
		local numbers = {data[1][1][4], -data[1][1][5], -data[1][1][6]}
		local sum = 0
		local total = 0
		for i = 1, #numbers do
		    sum = sum + numbers[i]
		    total = total + math.abs(numbers[i])
		end
		local percent = math.Round(numbers[1]/total * 100, 1)

		if percent <= 20 then thestars = 1 end
		if percent <= 40 then thestars = 2 end
		if percent <= 60 then thestars = 3 end
		if percent <= 80 then thestars = 4 end
		if percent <= 100 then thestars = 5 end

		local theposforstars = 185
		for i=1, thestars do
			local RatingStars = vgui.Create("DImage", ItemMain)
			RatingStars:SetPos(theposforstars,35)
			RatingStars:SetSize(10, 10)
			RatingStars:SetImage("gbay/Star128.png")
			theposforstars = theposforstars + 15
		end

		local UserRatingText = vgui.Create("DLabel", ItemMain)
		UserRatingText:SetPos(110, 50)
		UserRatingText:SetSize(ItemMain:GetWide(), 20)
		UserRatingText:SetText("Price: "..DarkRP.formatMoney(v[6]))
		UserRatingText:SetTextColor(Color(0,0,0))
		UserRatingText:SetFont("GBayLabelFontSmall")

		local PlayerAvatar = vgui.Create("EnhancedAvatarImage", ItemMain)
		PlayerAvatar:SetPos( ItemMain:GetWide() - 40, 60 )
		PlayerAvatar:SetSize( 34, 34 )
		PlayerAvatar:SetSteamID( v[2], 64 )

		ScrollList:AddItem(ItemMain)
	end
end
