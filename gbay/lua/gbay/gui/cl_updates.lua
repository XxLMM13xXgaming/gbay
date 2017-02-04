function GBayViewUpdatesFull(DFrame, data)
	if IsValid(HomePanel) then HomePanel:Remove() end
	if IsValid(HomePanel2) then HomePanel2:Remove() end
	if !IsValid(DFrame) then return end
	LocalPlayer().TabCurrentlyOn = "Updates"
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(50, 180)
	HomePanel:SetSize( DFrame:GetWide() - 60, DFrame:GetTall() - 190 )
	HomePanel:SetDraggable( false )
	HomePanel:SetTitle( "" )
	HomePanel:ShowCloseButton( false )
  local gbaywefailed = false
	HomePanel.Paint = function(s, w, h)
    draw.SimpleText("What's new?","GBayLabelFontBold",w / 2,30,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Here we can check what is new with GBay!","GBayLabelFont",w / 2,50,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.RoundedBox(0,0,70,w,2,Color(221,221,221))
    if !GBayConfig.AllowUpdates then
      draw.SimpleText("Looks like "..data[2][1][2].." does now allow updates via the internet!","GBayLabelFont",w / 2,h/2 - 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      draw.SimpleText("Update settings to get AWESOME updates!","GBayLabelFont",w / 2,h/2 + 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    if gbaywefailed then
      draw.SimpleText("Looks like something went wrong!","GBayLabelFont",w / 2,h/2 - 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      draw.SimpleText("Heres what we know... "..gbaywefailederror,"GBayLabelFont",w / 2,h/2 + 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
	end

  UpdatesLU = vgui.Create("DFrame", HomePanel)
	UpdatesLU:SetPos(0, 80)
	UpdatesLU:SetSize( DFrame:GetWide() - 60, DFrame:GetTall() - 190 + 90 )
	UpdatesLU:SetDraggable( false )
	UpdatesLU:SetTitle( "" )
	UpdatesLU:ShowCloseButton( false )
  UpdatesLU.Paint = function(s, w, h)
    surface.SetDrawColor(255,255,255, 255)
    surface.DrawRect(0, 0, w, h)
    draw.SimpleText("GBay 1.0.0 is here!","GBayLabelFontBold",w / 2,50,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Heres some quick info!","GBayLabelFont",w / 2,70,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("You can download GBay anytime at the link at the bottom of this page!","GBayLabelFont",w / 2,110,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("If you scroll in the changelist below you can see latest updates!","GBayLabelFont",w / 2,130,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

--  http.Fetch(GBayConfig.UpdatesURL,function(body)
--    RunString(body)
--  end,function(error)
--    gbaywefailed = true
--    gbaywefailederror = error
--  end)
end
