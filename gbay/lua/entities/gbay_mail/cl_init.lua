include('shared.lua')

net.Receive("GBayOpenNPCLoading",function()
  local loadingtext = "Loading"
  local DFrame = vgui.Create("DFrame")
  DFrame:SetSize(300,105)
  DFrame:Center()
  DFrame:SetText("")
  DFrame:MakePopup()
  DFrame:ShowCloseButton(false)
  DFrame.Paint = function(s, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    for k, v in pairs(mf.fireworks) do
      if (not v.peaked) then
        draw.RoundedBox(mf.size / 2, v.pos[1], v.pos[2], mf.size, mf.size, v.color)
      else
        local part = v.particles

        for i = 1, #part do
          draw.RoundedBox(mf.particlesize/2, part[i].pos[1], part[i].pos[2], mf.particlesize, mf.particlesize, v.color)
        end
      end
    end
    draw.SimpleText(loadingtext,"GBayTitleFont",w / 2,h / 2,Color( 0, 0, 0 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  DFrame.Think = function(s)
    if (math.random(0, 100) < 0.01 and #mf.fireworks <= 5) then
      mf.newfirework(s, math.random(0, s:GetWide()), s:GetTall() + 5)
    end

    for k, v in pairs(mf.fireworks) do
      if (v.color.a < 0) then
        table.remove(mf.fireworks, k)
        continue
      end

      if (not v.peaked) then
        v.pos[2] = Lerp(mf.speed * FrameTime(), v.pos[2], s:GetTall() / v.peak)
      else
        if (v.particlenum ~= #v.particles) then
          for i = 1, v.particlenum do
              mf.newparticle(v, v.pos[1], v.pos[2])
          end
        else
          local part = v.particles

          for i = 1, v.particlenum do
            if (part[i].peaked) then
              part[i].pos[2] = part[i].pos[4] + v.pos[2]
              part[i].pos[1] = part[i].pos[3] + v.pos[1]
            else
              if (part[i].pos[1] >= part[i].pos[3] + v.pos[1]) and (part[i].pos[2] >= part[i].pos[4] + v.pos[2]) then
                part[i].peaked = true
              else
                part[i].pos[2] = Lerp(mf.particlespeed * FrameTime(), part[i].pos[2], part[i].pos[4] + v.pos[2])
                part[i].pos[1] = Lerp(mf.particlespeed * FrameTime(), part[i].pos[1], part[i].pos[3] + v.pos[1])
              end
            end
          end
        end

        v.color.a = v.color.a - 2
        v.pos[2] = v.pos[2] + 0.5
      end

      if (v.pos[2] <= ((s:GetTall() / v.peak) + 5)) then
        v.peaked = true
      end
    end
  end

  net.Receive("GBayCloseNPCLoading",function()
    if IsValid(DFrame) then DFrame:Close() end
  end)
end)

net.Receive("GBayOpenMailNPCHomePage",function()
  local DFrame = vgui.Create("DFrame")
  DFrame:SetSize(300,105)
  DFrame:Center()
  DFrame:SetText("")
  DFrame:MakePopup()
  DFrame:ShowCloseButton(false)
  DFrame.Paint = function(s, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    draw.SimpleText("What can I do for you?","GBayLabelFont",w / 2,5,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
  end

  local DFrameClose = vgui.Create("DButton", DFrame)
	DFrameClose:SetPos(DFrame:GetWide() - 25, 5)
	DFrameClose:SetSize(25, 25)
	DFrameClose:SetText("X")
	DFrameClose:SetFont("GBayCloseFont")
	DFrameClose:SetTextColor(Color(214, 214, 214))
	DFrameClose.DoClick = function()
		DFrame:Close()
    net.Start("GBayNPCClosed")
    net.SendToServer()
	end
	DFrameClose.Paint = function(s, w, h)
	end

	local DFrameMin = vgui.Create("DButton", DFrame)
	DFrameMin:SetPos(DFrame:GetWide() - 40, 5)
	DFrameMin:SetSize(25, 25)
	DFrameMin:SetText("_")
	DFrameMin:SetFont("GBayCloseFont")
	DFrameMin:SetTextColor(Color(214, 214, 214))
	DFrameMin.DoClick = function()
		GBayMenuMin(DFrame)
	end
	DFrameMin.Paint = function(s, w, h)
	end

  local CheckOrderID = vgui.Create("DButton", DFrame)
  CheckOrderID:SetPos(20, 45)
  CheckOrderID:SetSize(DFrame:GetWide() - 40, 20 )
  CheckOrderID:SetText("Check my orders!")
  CheckOrderID:SetTextColor(Color(255,255,255))
  CheckOrderID.Paint = function(s, w, h)
    draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
  end
  CheckOrderID.DoClick = function()
    DFrame:Close()
    net.Start("GBayCheckOrder")
    net.SendToServer()
  end

  local ShipOrderID = vgui.Create("DButton", DFrame)
  ShipOrderID:SetPos(20, 70)
  ShipOrderID:SetSize(DFrame:GetWide() - 40, 20 )
  ShipOrderID:SetText("Ship my orders!")
  ShipOrderID:SetTextColor(Color(255,255,255))
  ShipOrderID.Paint = function(s, w, h)
    draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
  end
  ShipOrderID.DoClick = function()
    DFrame:Close()
    net.Start("GBayShipOrder")
    net.SendToServer()
  end
end)

net.Receive("GBayOpenPlayerOrders",function()
  local thetable = net.ReadTable()
  PrintTable(thetable)
  local DFrame = vgui.Create("DFrame")
  DFrame:SetSize(400,400)
  DFrame:Center()
  DFrame:SetText("")
  DFrame:MakePopup()
  DFrame:ShowCloseButton(false)
  DFrame.Paint = function(s, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    draw.SimpleText("Here are your orders!","GBayLabelFont",w / 2,5,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
  end

  local BackToMain = vgui.Create("DButton", DFrame)
  BackToMain:SetPos(20, DFrame:GetTall() - 25)
  BackToMain:SetSize(DFrame:GetWide() - 40, 20 )
  BackToMain:SetText("Alright lets go back!")
  BackToMain:SetTextColor(Color(255,255,255))
  BackToMain.Paint = function(s, w, h)
    draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
  end
  BackToMain.DoClick = function()
    DFrame:Close()
    net.Start("GBayMailNPCReturn")
    net.SendToServer()
  end

  local ScrollList = vgui.Create( "DPanelList", DFrame )
	ScrollList:SetPos( 20, 50 )
	ScrollList:SetSize( DFrame:GetWide() - 25, DFrame:GetTall() - 85 )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 10 )
	ScrollList:EnableVerticalScrollbar( true )

  for k, v in pairs(thetable) do
    local ItemMain = vgui.Create("DFrame")
    ItemMain:SetSize( ScrollList:GetWide() - 20, 105 )
    ItemMain:SetDraggable( false )
    ItemMain:SetTitle( "" )
    ItemMain:ShowCloseButton( false )
    ItemMain.Paint = function(s, w, h)
      draw.RoundedBox(0,0,0,w,h,Color(137, 137, 137, 255))
    end

    local ItemDate = vgui.Create("DLabel", ItemMain)
    ItemDate:SetPos(5, 5)
    ItemDate:SetSize(ItemMain:GetWide(), 20)
    ItemDate:SetText("Time Bought: "..os.date("%m/%d/%y",tonumber(v.timestamp)))
    ItemDate:SetFont("GBayLabelFont")

    local ItemType = vgui.Create("DLabel", ItemMain)
    ItemType:SetPos(5, 30)
    ItemType:SetSize(ItemMain:GetWide(), 20)
    ItemType:SetText("Item Type: "..v.type.." ("..v.weapon.."("..v.quantity.."))")
    ItemType:SetFont("GBayLabelFont")

    local ItemID = vgui.Create("DLabel", ItemMain)
    ItemID:SetPos(5, 55)
    ItemID:SetSize(ItemMain:GetWide(), 20)
    ItemID:SetText("Item ID: "..v.id)
    ItemID:SetFont("GBayLabelFont")

    if tostring(v.completed) == "1" then
      local ItemShip = vgui.Create("DButton", ItemMain)
      ItemShip:SetPos(20, 80)
      ItemShip:SetSize(ItemMain:GetWide() - 40, 20 )
      ItemShip:SetText("Retreive Item")
      ItemShip:SetTextColor(Color(255,255,255))
      ItemShip.Paint = function(s, w, h)
        draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
      end
      ItemShip.DoClick = function()
        net.Start("GBayRetriveItem")
          net.WriteFloat(v.id)
        net.SendToServer()
        DFrame:SetVisible(false)
      end
    else
      local ItemShip = vgui.Create("DButton", ItemMain)
      ItemShip:SetPos(20, 80)
      ItemShip:SetSize(ItemMain:GetWide() - 40, 20 )
      ItemShip:SetText("Retreive Item")
      ItemShip:SetTextColor(Color(255,255,255))
      ItemShip.Paint = function(s, w, h)
        draw.RoundedBox(3,0,0,w,h,Color(39, 39, 39))
      end
    end
    ScrollList:AddItem(ItemMain)
  end
end)

net.Receive("GBayOpenPlayerOrdersShip",function()
  local thetable = net.ReadTable()
  PrintTable(thetable)
  local DFrame = vgui.Create("DFrame")
  DFrame:SetSize(400,400)
  DFrame:Center()
  DFrame:SetText("")
  DFrame:MakePopup()
  DFrame:ShowCloseButton(false)
  DFrame.Paint = function(s, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(255,255,255,255))
    draw.SimpleText("Here are your orders!","GBayLabelFont",w / 2,5,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
  end

  local BackToMain = vgui.Create("DButton", DFrame)
  BackToMain:SetPos(20, DFrame:GetTall() - 25)
  BackToMain:SetSize(DFrame:GetWide() - 40, 20 )
  BackToMain:SetText("Alright lets go back!")
  BackToMain:SetTextColor(Color(255,255,255))
  BackToMain.Paint = function(s, w, h)
    draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
  end
  BackToMain.DoClick = function()
    DFrame:Close()
    net.Start("GBayMailNPCReturn")
    net.SendToServer()
  end

  local ScrollList = vgui.Create( "DPanelList", DFrame )
	ScrollList:SetPos( 20, 50 )
	ScrollList:SetSize( DFrame:GetWide() - 25, DFrame:GetTall() - 85 )
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing( 10 )
	ScrollList:EnableVerticalScrollbar( true )

  for k, v in pairs(thetable) do
    if tonumber(v.completed) == 0 then
      local ItemMain = vgui.Create("DFrame")
      ItemMain:SetSize( ScrollList:GetWide() - 20, 130 )
      ItemMain:SetDraggable( false )
      ItemMain:SetTitle( "" )
      ItemMain:ShowCloseButton( false )
      ItemMain.Paint = function(s, w, h)
        draw.RoundedBox(0,0,0,w,h,Color(137, 137, 137, 255))
      end

      local ItemDate = vgui.Create("DLabel", ItemMain)
      ItemDate:SetPos(5, 5)
      ItemDate:SetSize(ItemMain:GetWide(), 20)
      ItemDate:SetText("Time Bought: "..os.date("%m/%d/%y",tonumber(v.timestamp)))
      ItemDate:SetFont("GBayLabelFont")

      local ItemType = vgui.Create("DLabel", ItemMain)
      ItemType:SetPos(5, 30)
      ItemType:SetSize(ItemMain:GetWide(), 20)
      ItemType:SetText("Item Type: "..v.type.." ("..v.weapon.."("..v.quantity.."))")
      ItemType:SetFont("GBayLabelFont")

      local ItemID = vgui.Create("DLabel", ItemMain)
      ItemID:SetPos(5, 55)
      ItemID:SetSize(ItemMain:GetWide(), 20)
      ItemID:SetText("Item ID: "..v.id)
      ItemID:SetFont("GBayLabelFont")

      local thecus = ""
      if IsValid(player.GetBySteamID64(v.sidcustomer)) then
        thecus = player.GetBySteamID64(v.sidcustomer):Nick()
      else
        thecus = v.sidcustomer
      end

      local ItemCus = vgui.Create("DLabel", ItemMain)
      ItemCus:SetPos(5, 80)
      ItemCus:SetSize(ItemMain:GetWide(), 20)
      ItemCus:SetText("Customer: "..thecus)
      ItemCus:SetFont("GBayLabelFont")

      local ItemShip = vgui.Create("DButton", ItemMain)
      ItemShip:SetPos(20, 105)
      ItemShip:SetSize(ItemMain:GetWide() - 40, 20 )
      ItemShip:SetText("Ship Item")
      ItemShip:SetTextColor(Color(255,255,255))
      ItemShip.Paint = function(s, w, h)
        draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
      end
      ItemShip.DoClick = function()
        net.Start("GBayShipItem")
          net.WriteFloat(v.id)
        net.SendToServer()
        DFrame:SetVisible(false)
      end
      ScrollList:AddItem(ItemMain)
    end
  end

  net.Receive("GBayNPCShiped",function()
--    DFrame:SetVisible(true)
    DFrame:Close()
  end)
end)
