function GBayViewMoreItemFull(type, DFrame, data, item)
	if IsValid(HomePanel) then HomePanel:Remove() end
	if !IsValid(DFrame) then return end
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(50, 180)
	HomePanel:SetSize( DFrame:GetWide() - 60, DFrame:GetTall() - 190 )
	HomePanel:SetDraggable( false )
	HomePanel:SetTitle( "" )
	HomePanel:ShowCloseButton( false )
	HomePanel.QuantityOk = true
	HomePanel.Paint = function(s, w, h)
--		draw.RoundedBox(number cornerRadius,number x,number y,number width,number height,table color)
--Color(238,238,238)
		draw.RoundedBox(0,48,28,254,2,Color(221,221,221))
		draw.RoundedBox(0,300,28,2,204,Color(221,221,221))
		draw.RoundedBox(0,48,230,254,2,Color(221,221,221))
		draw.RoundedBox(0,48,28,2,204,Color(221,221,221))
		draw.RoundedBox(0,330,75,w - 400,2,Color(221,221,221))

		if s.QuantityOk then
			draw.SimpleText("You will order "..QuantitySel:GetValue().." "..v[3].."'s!","GBayLabelFont",600,90,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("You can not order any more then "..v[7].." or any less then 1!","GBayLabelFont",675,90,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
		end
	end

	v = item

	if file.Exists("materials/vgui/entities/"..v[5]..".vmt","GAME") then
		theweaponpic = "vgui/entities/"..v[5]..".vmt"
	elseif file.Exists("materials/entities/"..v[5]..".png","GAME") then
		theweaponpic = "entities/"..v[5]..".png"
	end

	local WeaponModel = vgui.Create("DImage", HomePanel)
	WeaponModel:SetPos(50,30)
	WeaponModel:SetSize(250, 200)
	WeaponModel:SetImage(theweaponpic)

	local ItemName = vgui.Create("DLabel", HomePanel)
	ItemName:SetPos(330, 30)
	ItemName:SetSize(HomePanel:GetWide(), 20)
	ItemName:SetText(v[3])
	ItemName:SetTextColor(Color(0,0,0))
	ItemName:SetFont("GBayLabelFontBold")

	local DelivText = vgui.Create("DLabel", HomePanel)
	DelivText:SetPos(330, 50)
	DelivText:SetSize(HomePanel:GetWide(), 20)
	if IsValid(player.GetBySteamID64( v[2] )) then
		DelivText:SetText("Delivery should only take less then 24 hours!")
	else
		DelivText:SetText("Delivery may take up to 1 week or your money back!")
	end
	DelivText:SetTextColor(Color( 142, 142, 142, 255 ))
	DelivText:SetFont("GBayLabelFont")

	local QuantitySelText = vgui.Create("DLabel", HomePanel)
	QuantitySelText:SetPos(330, 90)
	QuantitySelText:SetSize(HomePanel:GetWide(), 20)
	QuantitySelText:SetText("Quantity: ")
	QuantitySelText:SetTextColor(Color( 142, 142, 142, 255 ))
	QuantitySelText:SetFont("GBayLabelFont")

	QuantitySel = vgui.Create( "DNumberWang", HomePanel )
	QuantitySel:SetPos( 400, 90 )
	QuantitySel:SetValue( v[7] )
	QuantitySel:SetMin( 1 )
	QuantitySel:SetMax( v[7] )
	QuantitySel.OnValueChanged = function(num)
		if QuantitySel:GetValue() > v[7] then
			HomePanel.QuantityOk = false
		elseif QuantitySel:GetValue() < 1 then
			HomePanel.QuantityOk = false
		else
			HomePanel.QuantityOk = true
		end
	end

	local ItemDescription = vgui.Create("DLabel", HomePanel)
	ItemDescription:SetPos(330, 130)
	ItemDescription:SetText(v[4])
	ItemDescription:SetFont("GBayLabelFont")
	ItemDescription:SetTextColor(Color(0,0,0))
	ItemDescription:SizeToContents()

	local ItemPurchase = vgui.Create("DLabel", HomePanel)
	ItemPurchase:SetPos(330, 170)
	ItemPurchase:SetText("Please click purchase for more info like subtotal and delivery info!")
	ItemPurchase:SetFont("GBayLabelFont")
	ItemPurchase:SetTextColor(Color(0,0,0))
	ItemPurchase:SizeToContents()

	local PurchaseBtn = vgui.Create("DButton",HomePanel)
	PurchaseBtn:SetPos(330, 190)
	PurchaseBtn:SetSize(200, 40)
	PurchaseBtn:SetText("Purchase")
	PurchaseBtn:SetTextColor(Color(255,255,255))
	PurchaseBtn.Paint = function(s, w, h)
		draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
	end
	PurchaseBtn.DoClick = function()
		LocalPlayer().GBayBuyingItem = v
		GBaySideBarOpened(DFrame, "Purchase", false, data, false)
	end

	if v[2] == LocalPlayer():SteamID64() or LocalPlayer():GBayIsAdmin(data) then
		local EditBTN = vgui.Create("DButton",HomePanel)
		EditBTN:SetPos(335, 235)
		EditBTN:SetSize(PurchaseBtn:GetWide() / 2 - 15, 20)
		EditBTN:SetText("Edit")
		EditBTN:SetTextColor(Color(255,0,0))
		EditBTN.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
		end

		local RemoveBTN = vgui.Create("DButton",HomePanel)
		RemoveBTN:SetPos(330 + PurchaseBtn:GetWide() / 2, 235)
		RemoveBTN:SetSize(PurchaseBtn:GetWide() / 2 - 10, 20)
		RemoveBTN:SetText("Remove")
		RemoveBTN:SetTextColor(Color(255,0,0))
		RemoveBTN.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
		end
	end

	local ScrollList = vgui.Create( "DPanelList", HomePanel )
	ScrollList:SetPos( 50, 270 )
	ScrollList:SetSize( HomePanel:GetWide(), HomePanel:GetTall() - 280 )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 20 )
	ScrollList:EnableVerticalScrollbar( true )
	ScrollList.VBar.Paint = function( s, w, h )
	end
	ScrollList.VBar.btnUp.Paint = function( s, w, h ) end
	ScrollList.VBar.btnDown.Paint = function( s, w, h ) end
	ScrollList.VBar.btnGrip.Paint = function( s, w, h )
	end

	for samewepid, samewep in pairs(data[3]) do
		if samewep[5] == v[5] and samewep[1] != v[1] then
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
					GBayViewMoreItemFull("Shipment", DFrame, data, samewep)
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
					GBayViewMoreItemFull("Shipment", DFrame, data, samewep)
				end
			end

			local theweaponpic = false

			if file.Exists("materials/vgui/entities/"..samewep[5]..".vmt","GAME") then
				theweaponpic = "vgui/entities/"..samewep[5]..".vmt"
			elseif file.Exists("materials/entities/"..samewep[5]..".png","GAME") then
				theweaponpic = "entities/"..samewep[5]..".png"
			end

			local WeaponModel = vgui.Create("DImage", ItemMain)
			WeaponModel:SetPos(0,0)
			WeaponModel:SetSize(100, 100)
			WeaponModel:SetImage(theweaponpic)

			local ItemName = vgui.Create("DLabel", ItemMain)
			ItemName:SetPos(110, 10)
			ItemName:SetSize(ItemMain:GetWide(), 20)
			ItemName:SetText(samewep[3])
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
			UserRatingText:SetText("Price: "..DarkRP.formatMoney(samewep[6]))
			UserRatingText:SetTextColor(Color(0,0,0))
			UserRatingText:SetFont("GBayLabelFontSmall")

			local PlayerAvatar = vgui.Create("EnhancedAvatarImage", ItemMain)
			PlayerAvatar:SetPos( ItemMain:GetWide() - 40, 60 )
			PlayerAvatar:SetSize( 34, 34 )
			PlayerAvatar:SetSteamID( v[2], 64 )

			ScrollList:AddItem(ItemMain)
		end
	end

	LocalPlayer().TabCurrentlyOn = "Order"

	hook.Add("GBaySideBarClosed","CheckToSeeIfSidebarOpened2",function()
		if LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemFull(type, DFrame, data, item)
		end
	end)

	hook.Add("GBaySideBarOpened","CheckToSeeIfSidebarOpened2",function()
		if LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemSmall(type, DFrame, data, item)
		end
	end)
end

function GBayViewMoreItemSmall(type, DFrame, data, item)
	if IsValid(HomePanel) then HomePanel:Remove() end
	if !IsValid(DFrame) then return end
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(290, 180)
	HomePanel:SetSize( DFrame:GetWide() - 300, DFrame:GetTall() - 190 )
	HomePanel:SetDraggable( false )
	HomePanel:SetTitle( "" )
	HomePanel:ShowCloseButton( false )
	HomePanel.QuantityOk = true
	HomePanel.Paint = function(s, w, h)
--		draw.RoundedBox(number cornerRadius,number x,number y,number width,number height,table color)
--Color(238,238,238)
		draw.RoundedBox(0,48,28,254,2,Color(221,221,221))
		draw.RoundedBox(0,300,28,2,204,Color(221,221,221))
		draw.RoundedBox(0,48,230,254,2,Color(221,221,221))
		draw.RoundedBox(0,48,28,2,204,Color(221,221,221))
		draw.RoundedBox(0,330,75,w - 400,2,Color(221,221,221))

		if s.QuantityOk then
			draw.SimpleText("You will order "..QuantitySel:GetValue().."!","GBayLabelFont",550,90,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Please change quantity!","GBayLabelFont",550,90,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
		end
	end

	v = item

	if file.Exists("materials/vgui/entities/"..v[5]..".vmt","GAME") then
		theweaponpic = "vgui/entities/"..v[5]..".vmt"
	elseif file.Exists("materials/entities/"..v[5]..".png","GAME") then
		theweaponpic = "entities/"..v[5]..".png"
	end

	local WeaponModel = vgui.Create("DImage", HomePanel)
	WeaponModel:SetPos(50,30)
	WeaponModel:SetSize(250, 200)
	WeaponModel:SetImage(theweaponpic)

	local ItemName = vgui.Create("DLabel", HomePanel)
	ItemName:SetPos(330, 30)
	ItemName:SetSize(HomePanel:GetWide(), 20)
	ItemName:SetText(v[3])
	ItemName:SetTextColor(Color(0,0,0))
	ItemName:SetFont("GBayLabelFontBold")

	local DelivText = vgui.Create("DLabel", HomePanel)
	DelivText:SetPos(330, 50)
	DelivText:SetSize(HomePanel:GetWide(), 20)
	if IsValid(player.GetBySteamID64( v[2] )) then
		DelivText:SetText("Delivery should only take less then 24 hours!")
	else
		DelivText:SetText("Delivery may take up to 1 week!")
	end
	DelivText:SetTextColor(Color( 142, 142, 142, 255 ))
	DelivText:SetFont("GBayLabelFont")

	local QuantitySelText = vgui.Create("DLabel", HomePanel)
	QuantitySelText:SetPos(330, 90)
	QuantitySelText:SetSize(HomePanel:GetWide(), 20)
	QuantitySelText:SetText("Quantity: ")
	QuantitySelText:SetTextColor(Color( 142, 142, 142, 255 ))
	QuantitySelText:SetFont("GBayLabelFont")

	QuantitySel = vgui.Create( "DNumberWang", HomePanel )
	QuantitySel:SetPos( 400, 90 )
	QuantitySel:SetValue( v[7] )
	QuantitySel:SetMin( 1 )
	QuantitySel:SetMax( v[7] )
	QuantitySel.OnValueChanged = function(num)
		if QuantitySel:GetValue() > v[7] then
			HomePanel.QuantityOk = false
		elseif QuantitySel:GetValue() < 1 then
			HomePanel.QuantityOk = false
		else
			HomePanel.QuantityOk = true
		end
	end

	local ItemDescription = vgui.Create("DLabel", HomePanel)
	ItemDescription:SetPos(330, 130)
	ItemDescription:SetText(string.Left(v[4],37) .. "...")
	ItemDescription:SetFont("GBayLabelFont")
	ItemDescription:SetTextColor(Color(0,0,0))
	ItemDescription:SizeToContents()

	local ItemPurchase = vgui.Create("DLabel", HomePanel)
	ItemPurchase:SetPos(330, 170)
	ItemPurchase:SetText("Please click purchase for more info like subtotal!")
	ItemPurchase:SetFont("GBayLabelFont")
	ItemPurchase:SetTextColor(Color(0,0,0))
	ItemPurchase:SizeToContents()

	local PurchaseBtn = vgui.Create("DButton",HomePanel)
	PurchaseBtn:SetPos(330, 190)
	PurchaseBtn:SetSize(200, 40)
	PurchaseBtn:SetText("Purchase")
	PurchaseBtn:SetTextColor(Color(255,255,255))
	PurchaseBtn.Paint = function(s, w, h)
		draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
	end
	PurchaseBtn.DoClick = function()
		LocalPlayer().GBayBuyingItem = v
		LocalPlayer().GBayBuyingItemQ = QuantitySel:GetValue()
		LocalPlayer().GBayBuyingItemT = "Shipment"
		GBaySideBarOpened(DFrame, "Purchase", false, data, false)
	end

	if v[2] == LocalPlayer():SteamID64() or LocalPlayer():GBayIsAdmin(data) then
		local EditBTN = vgui.Create("DButton",HomePanel)
		EditBTN:SetPos(335, 235)
		EditBTN:SetSize(PurchaseBtn:GetWide() / 2 - 15, 20)
		EditBTN:SetText("Edit")
		EditBTN:SetTextColor(Color(255,0,0))
		EditBTN.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
		end

		local RemoveBTN = vgui.Create("DButton",HomePanel)
		RemoveBTN:SetPos(330 + PurchaseBtn:GetWide() / 2, 235)
		RemoveBTN:SetSize(PurchaseBtn:GetWide() / 2 - 10, 20)
		RemoveBTN:SetText("Remove")
		RemoveBTN:SetTextColor(Color(255,0,0))
		RemoveBTN.Paint = function(s, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
			draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
		end
	end

	local ScrollList = vgui.Create( "DPanelList", HomePanel )
	ScrollList:SetPos( 50, 270 )
	ScrollList:SetSize( HomePanel:GetWide(), HomePanel:GetTall() - 280 )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 20 )
	ScrollList:EnableVerticalScrollbar( true )
	ScrollList.VBar.Paint = function( s, w, h )
	end
	ScrollList.VBar.btnUp.Paint = function( s, w, h ) end
	ScrollList.VBar.btnDown.Paint = function( s, w, h ) end
	ScrollList.VBar.btnGrip.Paint = function( s, w, h )
	end

	for samewepid, samewep in pairs(data[3]) do
		if samewep[5] == v[5] and samewep[1] != v[1] then
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
					GBayViewMoreItemFull("Shipment", DFrame, data, samewep)
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
					GBayViewMoreItemFull("Shipment", DFrame, data, samewep)
				end
			end

			local theweaponpic = false

			if file.Exists("materials/vgui/entities/"..samewep[5]..".vmt","GAME") then
				theweaponpic = "vgui/entities/"..samewep[5]..".vmt"
			elseif file.Exists("materials/entities/"..samewep[5]..".png","GAME") then
				theweaponpic = "entities/"..samewep[5]..".png"
			end

			local WeaponModel = vgui.Create("DImage", ItemMain)
			WeaponModel:SetPos(0,0)
			WeaponModel:SetSize(100, 100)
			WeaponModel:SetImage(theweaponpic)

			local ItemName = vgui.Create("DLabel", ItemMain)
			ItemName:SetPos(110, 10)
			ItemName:SetSize(ItemMain:GetWide(), 20)
			ItemName:SetText(samewep[3])
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
			UserRatingText:SetText("Price: "..DarkRP.formatMoney(samewep[6]))
			UserRatingText:SetTextColor(Color(0,0,0))
			UserRatingText:SetFont("GBayLabelFontSmall")

			local PlayerAvatar = vgui.Create("EnhancedAvatarImage", ItemMain)
			PlayerAvatar:SetPos( ItemMain:GetWide() - 40, 60 )
			PlayerAvatar:SetSize( 34, 34 )
			PlayerAvatar:SetSteamID( v[2], 64 )

			ScrollList:AddItem(ItemMain)
		end
	end

	LocalPlayer().TabCurrentlyOn = "Order"

	hook.Add("GBaySideBarClosed","CheckToSeeIfSidebarOpened2",function()
		if LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemFull(type, DFrame, data, item)
		end
	end)

	hook.Add("GBaySideBarOpened","CheckToSeeIfSidebarOpened2",function()
		if LocalPlayer().TabCurrentlyOn == "Order" then
			GBayViewMoreItemSmall(type, DFrame, data, item)
		end
	end)
end
