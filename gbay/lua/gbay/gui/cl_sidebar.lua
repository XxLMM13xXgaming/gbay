function GBaySideBarClosed(DFrame, tab, settingbtnclicked, data, firstjoined)
	if IsValid(SideBarOpened) then SideBarOpened:Remove() end
	hook.Call( "GBaySideBarClosed" )
	LocalPlayer().GBayOpenMenuTabStatus = false
	if IsValid(GBayDFrameLogo) then GBayDFrameLogo:Remove() end
	if IsValid(SideBarClosed) then SideBarClosed:Close() end
	if IsValid(SideBarOpened) then SideBarOpened:Close() end
	GBayDFrameLogo = vgui.Create("DImage", DFrame)
	GBayDFrameLogo:SetPos(DFrame:GetWide() / 2 - 129/2,20)
	GBayDFrameLogo:SetSize(129, 59)
	GBayDFrameLogo:SetImage("gbay/Logo.png")

	SideBarClosed = vgui.Create("DFrame", DFrame)
	SideBarClosed:SetPos(0,0)
	SideBarClosed:SetSize(40, DFrame:GetTall())
	SideBarClosed:SetDraggable(false)
	SideBarClosed:SetTitle('')
	SideBarClosed:ShowCloseButton(false)
	SideBarClosed.Paint = function(s, w, h)
    surface.SetDrawColor(255,255,255)
    surface.DrawRect(0, 0, w, h)
  end

	local SideBarOpenBtn = vgui.Create("DButton", SideBarClosed)
	SideBarOpenBtn:SetPos(10, 10)
	SideBarOpenBtn:SetSize(25, 25)
	SideBarOpenBtn:SetText("+")
	SideBarOpenBtn:SetFont("GBayLabelFontLarge")
	SideBarOpenBtn:SetTextColor(Color(214, 214, 214))
	SideBarOpenBtn.DoClick = function()
		SideBarClosed:Close()
		GBaySideBarOpened(DFrame, tab, false, data, firstjoined)
	end
	SideBarOpenBtn.Paint = function(s, w, h)
	end

	local SideBarSettingsBtn = vgui.Create( "DImageButton", SideBarClosed )
	SideBarSettingsBtn:SetPos( 10, SideBarClosed:GetTall() - 30 )
	SideBarSettingsBtn:SetImage( "gbay/Settings.png" )
	SideBarSettingsBtn:SizeToContents()
	SideBarSettingsBtn.DoClick = function()
		GBaySideBarOpened(DFrame, "Dashboard", true, data, firstjoined)
	end
end

function GBaySideBarOpened(DFrame, tab, settingbtnclicked, data, firstjoined)
	hook.Call( "GBaySideBarOpened" )
	LocalPlayer().GBayOpenMenuTabStatus = true
	if IsValid(GBayDFrameLogo) then GBayDFrameLogo:Remove() end
	GBayDFrameLogo = vgui.Create("DImage", DFrame)
	GBayDFrameLogo:SetPos(DFrame:GetWide() / 2 - 129/2 +280/2,20)
	GBayDFrameLogo:SetSize(129, 59)
	GBayDFrameLogo:SetImage("gbay/Logo.png")

	if IsValid(SideBarClosed) then SideBarClosed:Close() end
	if IsValid(SideBarOpened) then SideBarOpened:Close() end
	SideBarOpened = vgui.Create("DFrame", DFrame)
	SideBarOpened:SetPos(0,0)
	SideBarOpened:SetSize(280, DFrame:GetTall())
	SideBarOpened:SetDraggable(false)
	SideBarOpened:SetTitle('')
	SideBarOpened:ShowCloseButton(false)
	SideBarOpened.Paint = function(s, w, h)
		surface.SetDrawColor(255,255,255)
		surface.DrawRect(0, 0, w, h)
	end
	local SideBarCloseBtn = vgui.Create("DButton", SideBarOpened)
	SideBarCloseBtn:SetPos(SideBarOpened:GetWide() - 30, 5)
	SideBarCloseBtn:SetSize(25, 25)
	SideBarCloseBtn:SetText("-")
	SideBarCloseBtn:SetFont("GBayLabelFontLarge")
	SideBarCloseBtn:SetTextColor(Color(214, 214, 214))
	SideBarCloseBtn.Paint = function() end
	SideBarCloseBtn.DoClick = function()
		SideBarOpened:Close()
		GBaySideBarClosed(DFrame, tab, false, data, firstjoined)
	end

	if tab == "PleaseRefresh" then
		local GBayLogoSettings = Material("gbay/Settings_Logo.png")
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoSettings	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			if firstjoined then
				draw.SimpleText("Server settings saved!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Please close this whole page","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("and reopen to use GBay!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Server settings saved!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Please close this sidebar to go to the","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("dashboard... Server settings will","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("not display diffrent untill you","GBayLabelFont",w / 2,h/2 +60,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("restart GBay!","GBayLabelFont",w / 2,h/2 +80,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	elseif tab == "PleaseRefreshOther" then
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText("Please Refresh!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("GBay needs to be refreshed!","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Close and then re-open!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	elseif tab == "Loading" then
		net.Receive("GBayDoneLoading",function()
			local newtype = net.ReadString()
			local newdata = net.ReadTable()
			if newtype == "Shipment" then
				table.insert(data[3],newdata[1],newdata)
			elseif newtype == "Service" then
				table.insert(data[4],newdata[1],newdata)
			elseif newtype == "Entity" then
				table.insert(data[5],newdata[1],newdata)
			end
			GBaySideBarOpened(DFrame, "Terms", false, data, false)
		end)
		net.Receive("GBayDoneLoading2",function()
			GBaySideBarOpened(DFrame, "PleaseRefreshOther", false, data, false)
		end)
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText("Saving data to database!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Please wait while we process","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("and refresh all data on GBay!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		end
		SideBarOpened.Think = function(s)
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
	elseif tab == "TransPending" then
		nomoney = false
		wronginfo = false
		error = false
		samep = false
		bought = false
		success = false

		net.Receive("GBayTransErrorReport",function()
			report = net.ReadString()
			nomoney = false
			wronginfo = false
			error = false
			samep = false
			bought = false
			success = false
			if report == "Money" then nomoney = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Info" then wronginfo = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Error" then error = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "SamePlayer" then samep = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Bought" then bought = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Success" then success = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
		end)
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			if nomoney then
				draw.SimpleText("No money!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("It looks like you do not have the funds","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("To purchase this item!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif wronginfo then
				draw.SimpleText("Ugh oh!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Something went wrong!","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Item was not found!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif error then
				draw.SimpleText("Uh Oh!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Something went wrong!","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Close GBay and try again!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif samep then
				draw.SimpleText("Uh Oh!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Something went wrong!","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Do not buy your own item!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif bought then
				draw.SimpleText("Uh Oh!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Something went wrong!","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Do not buy this twice!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			elseif success then
				draw.SimpleText("Transaction Successful!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Your order has now been sent! ","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Please wait for the delivery","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Transaction Pending!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Please wait while we process...","GBayLabelFont",w / 2,h/2 + 20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Errors will be reported below!","GBayLabelFont",w / 2,h/2 +40,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
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
		end
		SideBarOpened.Think = function(s)
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
	elseif tab == "Terms" then
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			draw.SimpleText("Item now on GBay!","GBayLabelFontBold",w / 2,20,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Here are some rules with selling...","GBayLabelFont",w / 2,45,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("At any time you may remove your","GBayLabelFont",w / 2,63,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("item or you can edit it by","GBayLabelFont",w / 2,83,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("clicking buttons below the","GBayLabelFont",w / 2,103,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("item. When your item is sold","GBayLabelFont",w / 2,123,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("You NEED to make sure you","GBayLabelFont",w / 2,143,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("keep the item and deliver","GBayLabelFont",w / 2,163,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("when the order is placed or you","GBayLabelFont",w / 2,183,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("risk receiving bad rep or a ban!","GBayLabelFont",w / 2,203,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Any questions please contact staff","GBayLabelFont",w / 2,223,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("a staff member","GBayLabelFont",w / 2,243,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("So lets recap the most important rules","GBayLabelFont",w / 2,303,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Save your shipment or remove it from","GBayLabelFont",w / 2,323,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("store before it is bought...","GBayLabelFont",w / 2,343,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Right when you are notified of the","GBayLabelFont",w / 2,383,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("purchase of your item please make","GBayLabelFont",w / 2,403,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("sure you deliver the item to the ","GBayLabelFont",w / 2,423,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("customer!","GBayLabelFont",w / 2,443,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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
		end
		SideBarOpened.Think = function(s)
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

		local TermsAccept = vgui.Create("DButton", SideBarOpened)
		TermsAccept:SetPos(20, SideBarOpened:GetTall() - 40)
		TermsAccept:SetSize(SideBarOpened:GetWide() - 40, 30)
		TermsAccept:SetText("Accept")
		TermsAccept:SetTextColor(Color(255,255,255))
		TermsAccept.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		TermsAccept.DoClick = function()
			GBaySideBarClosed(DFrame, "Dashboard", false, data, false)
		end
	elseif tab == "Settings" or settingbtnclicked then
		local GBayLogoSettings = Material("gbay/Settings_Logo.png")
		if !firstjoined then
			playerisadmin = LocalPlayer():GBayIsSuperAdmin(data)
		else
			playerisadmin = true
		end
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoSettings	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			if playerisadmin then
--				draw.SimpleText("Whats your server name?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.RoundedBox(0,0,200,w,2,Color(221,221,221))
--				draw.SimpleText("Can people pay for ads?","GBayLabelFont",w / 2,210,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.RoundedBox(0,0,300,w,2,Color(221,221,221))
--				draw.SimpleText("Can people sell services?","GBayLabelFont",w / 2,310,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.RoundedBox(0,0,400,w,2,Color(221,221,221))
--				draw.SimpleText("Can people create coupons?","GBayLabelFont",w / 2,410,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.RoundedBox(0,0,500,w,2,Color(221,221,221))
--				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
--				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Get outta here!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Currently there are no user settings","GBayLabelFont",w / 2,h/2 - 30,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Maybe sometime soon!","GBayLabelFont",w / 2,h/2 - 60,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			end
		end

		if playerisadmin then
			local ScrollList = vgui.Create( "DPanelList", SideBarOpened )
			ScrollList:SetPos( 0, 140 )
			ScrollList:SetSize( SideBarOpened:GetWide(), SideBarOpened:GetTall() - 190 )
			ScrollList:EnableHorizontal(false)
			ScrollList:SetSpacing( 20 )
			ScrollList:EnableVerticalScrollbar( false )

			if data[2][1][1] == nil then
				servername = "Server Name"
				adsyon = false
				servsyon = false
				coupsyon = false
				ffpi = 0
				mpfpi = 0
				itfpi = 0
			else
				servername = data[2][1][2]
				adsyon = data[2][1][3]
				servsyon = data[2][1][4]
				coupsyon = data[2][1][5]
				ffpi = data[2][1][6]
				mpfpi = data[2][1][7]
				itfpi = data[2][1][8]
			end

			local configs = {
				{"Whats your server name?", "text:15:Server Name", servername},
				{"Can people pay for ads?", "bool", adsyon},
				{"Can people sell services?", "bool", servsyon},
				{"Can people create coupons?", "bool", coupsyon},
				{"What is the fee for posting items?", "numb:Posting Fee", ffpi},
				{"What is the max price for items?", "numb:Max price", mpfpi},
				{"Item tax (%)", "numb:Tax (for 8% just type 8)", itfpi},
			}

			for k, v in pairs(configs) do
				if string.Left(v[2],4) == "text" or string.Left(v[2],4) == "numb" then
					sizey = 65
				elseif string.Left(v[2],4) == "bool" then
					sizey = 85
				end

				local ItemMain = vgui.Create("DFrame")
				ItemMain:SetSize( ScrollList:GetWide(0), sizey )
				ItemMain:SetDraggable( false )
				ItemMain:SetTitle( "" )
				ItemMain:ShowCloseButton( false )
				ItemMain.Paint = function(s, w, h)
					draw.SimpleText(v[1],"GBayLabelFont",w / 2,0,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
					draw.RoundedBox(0,0,h - 2,w,2,Color(221,221,221))
				end

				if string.Left(v[2],4) == "text" then
					local text = string.Explode(':',v[2])
					local ItemMainTE = vgui.Create("DTextEntry",ItemMain)
					ItemMainTE:SetPos(20, 25)
					ItemMainTE:SetSize(SideBarOpened:GetWide() - 40, 20 )
					ItemMainTE:SetText(text[3].." ("..v[3]..")")
					ItemMainTE.OnTextChanged = function(s)
						if string.len(s:GetValue()) > tonumber(text[2]) then
							local timeleftforrestriction = 5
							s:SetText(text[3].." must be < "..text[2].." characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText(text[3])
									s:SetEditable(true)
									return
								end
								s:SetText(text[3].." must be < "..text[2].." characters... ("..timeleftforrestriction..")")
							end)
						else
							v[3] = s:GetValue()
						end
					end
				elseif string.Left(v[2],4) == "bool" then
					local CheckBoxYes = vgui.Create( "DCheckBoxLabel", ItemMain )
					CheckBoxYes:SetPos( 20, 30 )
					if data != nil then
						if v[3] == 1 then
							CheckBoxYes:SetValue( 1 )
						else
							CheckBoxYes:SetValue( 0 )
						end
					else
						CheckBoxYes:SetValue( 0 )
					end
					CheckBoxYes:SetText("Yes")
					CheckBoxYes:SetFont("GBayLabelFont")
					CheckBoxYes:SetTextColor(Color(137, 137, 137))
					CheckBoxYes.OnChange = function(value)
						v[3] = value:GetChecked()
						if value then
							if CheckBoxNo:GetChecked() then
								CheckBoxNo:SetValue(0)
								return
							end
						end
					end

					local CheckBoxNo = vgui.Create( "DCheckBoxLabel", ItemMain )
					CheckBoxNo:SetPos( 20, 55 )
					if data != nil then
						if v[3] == 0 then
							CheckBoxNo:SetValue( 1 )
						else
							CheckBoxNo:SetValue( 0 )
						end
					else
						CheckBoxNo:SetValue( 0 )
					end
					CheckBoxNo:SetText("No")
					CheckBoxNo:SetFont("GBayLabelFont")
					CheckBoxNo:SetTextColor(Color(137, 137, 137))
					CheckBoxNo.OnChange = function(value)
						if value then
							if CheckBoxYes:GetChecked() then
								CheckBoxYes:SetValue(0)
								return
							end

						end
					end
				elseif string.Left(v[2],4) == "numb" then
					local text = string.Explode(':',v[2])
					local ItemMainTE = vgui.Create("DTextEntry",ItemMain)
					ItemMainTE:SetPos(20, 25)
					ItemMainTE:SetSize(SideBarOpened:GetWide() - 40, 20 )
					ItemMainTE:SetText(v[3])
					ItemMainTE:SetNumeric(true)
					ItemMainTE.OnTextChanged = function(s)
						v[3] = s:GetValue()
					end
				end
				ScrollList:AddItem(ItemMain)
			end

			SaveSettingsBtn = vgui.Create("DButton", SideBarOpened)
			SaveSettingsBtn:SetPos(20, SideBarOpened:GetTall() - 40)
			SaveSettingsBtn:SetSize(SideBarOpened:GetWide() - 40, 30)
			SaveSettingsBtn:SetText("Save Settings")
			SaveSettingsBtn:SetTextColor(Color(255,255,255))
			SaveSettingsBtn.Paint = function(s, w, h)
				draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
			end
			SaveSettingsBtn.DoClick = function()
				local datatosend = {}
				for k, v in pairs(configs) do
					table.insert(datatosend,#datatosend + 1, v[3])
				end
				net.Start("GBayUpdateSettings")
					net.WriteTable(datatosend)
				net.SendToServer()
				GBaySideBarOpened(DFrame, "PleaseRefresh", false, {}, firstjoined)
			end
		end
	elseif tab == "Dashboard" then
		for k, v in pairs(data[1]) do
			if v[2] == LocalPlayer():SteamID64() then
				playerdata = v
			end
		end
		local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
		local sum = 0
		local total = 0
		for i = 1, #numbers do
		    sum = sum + numbers[i]
		    total = total + math.abs(numbers[i])
		end
		local percent = math.Round(numbers[1]/total * 100, 1)
		if IsValid(player.GetBySteamID64(playerdata[2])) then
			playerdatanick = player.GetBySteamID64(playerdata[2]):Nick()
		else
			playerdatanick = "Unknown"
		end
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			draw.RoundedBox(0,13,38,68,68,Color(221,221,221))
			draw.SimpleText(playerdatanick,"GBayLabelFontBold",180,60,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(percent.."% positive feedback","GBayLabelFontSmall",165,80,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[4],"GBayLabelFontBold",55,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Positive","GBayLabelFontSmall",55,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[5],"GBayLabelFontBold",155,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Neutral","GBayLabelFontSmall",155,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[6],"GBayLabelFontBold",245,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Negative","GBayLabelFontSmall",245,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("User Info","GBayLabelFontSmall",5,230,Color( 188, 188, 188, 255 ))
			draw.RoundedBox(0,0,250,w,2,Color(221,221,221))
			draw.SimpleText("Player ID: "..playerdata[1],"GBayLabelFontSmall",5,270,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Player Rank: "..playerdata[3],"GBayLabelFontSmall",5,300,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Total Player Rep: "..playerdata[4] + playerdata[5] + playerdata[6],"GBayLabelFontSmall",5,330,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Below are your current items for sale!","GBayLabelFontSmall",5,380,Color( 188, 188, 188, 255 ))
			draw.RoundedBox(0,0,400,w,2,Color(221,221,221))
		end

		local PlayerAvatar = vgui.Create( "AvatarImage", SideBarOpened )
		PlayerAvatar:SetPos( 15, 40 )
		PlayerAvatar:SetSize( 64, 64 )
		PlayerAvatar:SetSteamID( playerdata[2], 64 )

		local PositiveIMG = vgui.Create("DImage", SideBarOpened)
		PositiveIMG:SetPos(30, 160)
		PositiveIMG:SizeToContents()
		PositiveIMG:SetImage("gbay/Positive.png")

		local NeutralIMG = vgui.Create("DImage", SideBarOpened)
		NeutralIMG:SetPos(130, 160)
		NeutralIMG:SizeToContents()
		NeutralIMG:SetImage("gbay/Neutral.png")

		local NegativeIMG = vgui.Create("DImage", SideBarOpened)
		NegativeIMG:SetPos(220, 160)
		NegativeIMG:SizeToContents()
		NegativeIMG:SetImage("gbay/Negative.png")

		local ScrollList = vgui.Create( "DPanelList", SideBarOpened )
		ScrollList:SetPos( 5, 420 )
		ScrollList:SetSize( SideBarOpened:GetWide(), SideBarOpened:GetTall() - 440 )
		ScrollList:EnableHorizontal(true)
		ScrollList:SetSpacing( 20 )
		ScrollList:EnableVerticalScrollbar( true )
		ScrollList.VBar.Paint = function( s, w, h )
		end
		ScrollList.VBar.btnUp.Paint = function( s, w, h ) end
		ScrollList.VBar.btnDown.Paint = function( s, w, h ) end
		ScrollList.VBar.btnGrip.Paint = function( s, w, h )
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

			if LocalPlayer():GBayIsAdmin(data) or v[2] == LocalPlayer():SteamID64() then
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
					LocalPlayer().GBayOrderType = "Shipment"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Shipment", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
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
				EditBTN.DoClick = function()
					LocalPlayer().GBayIsEditing = v[1]
					GBaySideBarOpened(DFrame, "EditServ", false, data, false)
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
				RemoveBTN.DoClick = function()
					Derma_Query( "Are you sure you want to remove this item?", "GBay Remove Item", "Yes", function()
						net.Start("GBayRemoveShipment")
							net.WriteFloat(v[1])
						net.SendToServer()
					end, "No", function()

					end)
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
					LocalPlayer().GBayOrderType = "Shipment"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Shipment", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
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

			for playerid, player in pairs(data[1]) do
				if player[2] == v[2] then
					playerdata = player
				end
			end

			local thestars = 0
			local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
			local sum = 0
			local total = 0
			for i = 1, #numbers do
			    sum = sum + numbers[i]
			    total = total + math.abs(numbers[i])
			end
			local percent = math.Round(numbers[1]/total * 100, 1)

			if percent <= 20 then
				thestars = 1
			elseif percent <= 40 then
				thestars = 2
			elseif percent <= 60 then
				thestars = 3
			elseif percent <= 80 then
				thestars = 4
			elseif percent <= 100 then
			 	thestars = 5
			end

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

		for k, v in pairs(data[4]) do
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

			if LocalPlayer():GBayIsAdmin(data) or v[2] == LocalPlayer():SteamID64() then
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
					LocalPlayer().GBayOrderType = "Service"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Service", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
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
				EditBTN.DoClick = function()
					LocalPlayer().GBayIsEditing = v[1]
					GBaySideBarOpened(DFrame, "EditServ", false, data, false)
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
				RemoveBTN.DoClick = function()
					Derma_Query( "Are you sure you want to remove this item?", "GBay Remove Item", "Yes", function()
						net.Start("GBayRemoveService")
							net.WriteFloat(v[1])
						net.SendToServer()
					end, "No", function()

					end)
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
					LocalPlayer().GBayOrderType = "Service"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Service", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
				end
			end

			local ServModel = vgui.Create("DImage", ItemMain)
			ServModel:SetPos(0,0)
			ServModel:SetSize(100, 100)
			ServModel:SetImage("gbay/Services_Small.png")

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

			for playerid, player in pairs(data[1]) do
				if player[2] == v[2] then
					playerdata = player
				end
			end

			local thestars = 0
			local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
			local sum = 0
			local total = 0
			for i = 1, #numbers do
			    sum = sum + numbers[i]
			    total = total + math.abs(numbers[i])
			end
			local percent = math.Round(numbers[1]/total * 100, 1)

			if percent <= 20 then
				thestars = 1
			elseif percent <= 40 then
				thestars = 2
			elseif percent <= 60 then
				thestars = 3
			elseif percent <= 80 then
				thestars = 4
			elseif percent <= 100 then
			 	thestars = 5
			end

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
			UserRatingText:SetText("Price: "..DarkRP.formatMoney(v[5]))
			UserRatingText:SetTextColor(Color(0,0,0))
			UserRatingText:SetFont("GBayLabelFontSmall")

			local PlayerAvatar = vgui.Create("EnhancedAvatarImage", ItemMain)
			PlayerAvatar:SetPos( ItemMain:GetWide() - 40, 60 )
			PlayerAvatar:SetSize( 34, 34 )
			PlayerAvatar:SetSteamID( v[2], 64 )

			ScrollList:AddItem(ItemMain)
		end

		for k, v in pairs(data[5]) do
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

			if LocalPlayer():GBayIsAdmin(data) or v[2] == LocalPlayer():SteamID64() then
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
					LocalPlayer().GBayOrderType = "Entity"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Entity", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
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
				EditBTN.DoClick = function()
					LocalPlayer().GBayIsEditing = v[1]
					GBaySideBarOpened(DFrame, "EditEnt", false, data, false)
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
				RemoveBTN.DoClick = function()
					Derma_Query( "Are you sure you want to remove this item?", "GBay Remove Item", "Yes", function()
						net.Start("GBayRemoveEntity")
							net.WriteFloat(v[1])
						net.SendToServer()
					end, "No", function()

					end)
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
					LocalPlayer().GBayOrderType = "Entity"
					LocalPlayer().GBayOrderItem = v
					HomePanel:Remove()
					GBayViewMoreItemFull("Entity", DFrame, data, v)
					LocalPlayer().GBayPlayerProfileWho = v[2]
					GBaySideBarClosed(DFrame, "PlayerProfile", false, data, false)
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

			for playerid, player in pairs(data[1]) do
				if player[2] == v[2] then
					playerdata = player
				end
			end

			local thestars = 0
			local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
			local sum = 0
			local total = 0
			for i = 1, #numbers do
			    sum = sum + numbers[i]
			    total = total + math.abs(numbers[i])
			end
			local percent = math.Round(numbers[1]/total * 100, 1)

			if percent <= 20 then
				thestars = 1
			elseif percent <= 40 then
				thestars = 2
			elseif percent <= 60 then
				thestars = 3
			elseif percent <= 80 then
				thestars = 4
			elseif percent <= 100 then
			 	thestars = 5
			end

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
	elseif tab == "PlayerProfile" then
		local playerdata = {}
		for k, v in pairs(data[1]) do
			if v[2] == LocalPlayer().GBayPlayerProfileWho then
				playerdata = v
			end
		end
		local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
		local sum = 0
		local total = 0
		for i = 1, #numbers do
		    sum = sum + numbers[i]
		    total = total + math.abs(numbers[i])
		end
		local percent = math.Round(numbers[1]/total * 100, 1)
		if IsValid(player.GetBySteamID64(playerdata[2])) then
			playerdatanick = player.GetBySteamID64(playerdata[2]):Nick()
		else
			playerdatanick = "Unknown"
		end
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			draw.RoundedBox(0,13,38,68,68,Color(221,221,221))
			draw.SimpleText(playerdatanick,"GBayLabelFontBold",180,60,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(percent.."% positive feedback","GBayLabelFontSmall",165,80,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[4],"GBayLabelFontBold",55,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Positive","GBayLabelFontSmall",55,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[5],"GBayLabelFontBold",155,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Neutral","GBayLabelFontSmall",155,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText(playerdata[6],"GBayLabelFontBold",245,155,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("Negative","GBayLabelFontSmall",245,175,Color( 188, 188, 188, 255 ),TEXT_ALIGN_CENTER)
			draw.SimpleText("User Info","GBayLabelFontSmall",5,230,Color( 188, 188, 188, 255 ))
			draw.RoundedBox(0,0,250,w,2,Color(221,221,221))
			draw.SimpleText("Player ID: "..playerdata[1],"GBayLabelFontSmall",5,270,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Player Rank: "..playerdata[3],"GBayLabelFontSmall",5,300,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Total Player Rep: "..playerdata[4] + playerdata[5] + playerdata[6],"GBayLabelFontSmall",5,330,Color( 188, 188, 188, 255 ))
			draw.SimpleText("Below are this users items!","GBayLabelFontSmall",5,380,Color( 188, 188, 188, 255 ))
			draw.RoundedBox(0,0,400,w,2,Color(221,221,221))
		end

		if LocalPlayer():GBayIsSuperAdmin(data) then
			local BanBTN = vgui.Create("DButton",SideBarOpened)
			BanBTN:SetPos(20, 350)
			BanBTN:SetSize(SideBarOpened:GetWide() / 3 - 20, 20)
			BanBTN:SetText("Ban User")
			BanBTN:SetTextColor(Color(255,0,0))
			BanBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			BanBTN.DoClick = function()
				Derma_StringRequest(
					"GBay Ban Player",
					"How many days should this ban be?",
					"1",
					function( text )
						net.Start("GBayBanPlayer")
							net.WriteFloat(tonumber(text))
							net.WriteFloat(tonumber(playerdata[1]))
						net.SendToServer()
					end,
					function( text ) end
				 )
			end

			local SetRankBTN = vgui.Create("DButton",SideBarOpened)
			SetRankBTN:SetPos(SideBarOpened:GetWide() / 3 + 10, 350)
			SetRankBTN:SetSize(SideBarOpened:GetWide() / 3 - 20, 20)
			SetRankBTN:SetText("Set Rank")
			SetRankBTN:SetTextColor(Color(185,201,229))
			SetRankBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			SetRankBTN.DoClick = function()
				Derma_StringRequest(
				"GBay Set Player Rank",
					"What rank should this player be? (Superadmin or Admin only!)",
					"Admin",
					function( text )
						net.Start("GBaySetPlayerRank")
							net.WriteString(text)
							net.WriteFloat(tonumber(playerdata[1]))
						net.SendToServer()
					end,
					function( text ) end
				 )
			end

			local EditUserBTN = vgui.Create("DButton",SideBarOpened)
			EditUserBTN:SetPos(SideBarOpened:GetWide() / 3 + 10 + SideBarOpened:GetWide() / 3 - 10, 350)
			EditUserBTN:SetSize(SideBarOpened:GetWide() / 3 - 20, 20)
			EditUserBTN:SetText("Edit User")
			EditUserBTN:SetTextColor(Color(185,201,229))
			EditUserBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			EditUserBTN.DoClick = function()
				local menu = DermaMenu()
				menu:AddOption( "Edit +rep", function()
					Derma_StringRequest(
					"GBay Set Player +rep",
						"What should the +rep be for this player?",
						"0",
						function( text )
							net.Start("GBaySetprep")
								net.WriteFloat(tonumber(text))
								net.WriteFloat(tonumber(playerdata[1]))
							net.SendToServer()
						end,
						function( text ) end
					 )
				end )
				menu:AddOption( "Edit neutral rep", function()
					Derma_StringRequest(
					"GBay Set Player neutral rep",
						"What should the neutral rep be for this player?",
						"0",
						function( text )
							net.Start("GBaySetnrep")
								net.WriteFloat(tonumber(text))
								net.WriteFloat(tonumber(playerdata[1]))
							net.SendToServer()
						end,
						function( text ) end
					 )
				end )
				menu:AddOption( "Edit -rep", function()
					Derma_StringRequest(
					"GBay Set Player -rep",
						"What should the -rep be for this player?",
						"0",
						function( text )
							net.Start("GBaySetmrep")
								net.WriteFloat(tonumber(text))
								net.WriteFloat(tonumber(playerdata[1]))
							net.SendToServer()
						end,
						function( text ) end
					 )
				end )
				menu:AddOption( "Close", function() end )
				menu:Open()
			end
		elseif LocalPlayer():GBayIsAdmin(data) then
			local BanBTN = vgui.Create("DButton",SideBarOpened)
			BanBTN:SetPos(20, 350)
			BanBTN:SetSize(SideBarOpened:GetWide() / 3 - 20, 20)
			BanBTN:SetText("Ban User")
			BanBTN:SetTextColor(Color(255,0,0))
			BanBTN.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,Color(238,238,238))
				draw.RoundedBox(0,2,2,w-4,h-4,Color(255,255,255))
			end
			BanBTN.DoClick = function()
				Derma_StringRequest(
					"GBay Ban Player",
					"How many days should this ban be?",
					"1",
					function( text )
						print("Ran")
						net.Start("GBayBanPlayer")
							net.WriteFloat(tonumber(text))
							net.WriteFloat(tonumber(playerdata[1]))
						net.SendToServer()
					end,
					function( text ) end
				 )
			end
		end

		local PlayerAvatar = vgui.Create( "AvatarImage", SideBarOpened )
		PlayerAvatar:SetPos( 15, 40 )
		PlayerAvatar:SetSize( 64, 64 )
		PlayerAvatar:SetSteamID( playerdata[2], 64 )

		local PositiveIMG = vgui.Create("DImage", SideBarOpened)
		PositiveIMG:SetPos(30, 160)
		PositiveIMG:SizeToContents()
		PositiveIMG:SetImage("gbay/Positive.png")

		local NeutralIMG = vgui.Create("DImage", SideBarOpened)
		NeutralIMG:SetPos(130, 160)
		NeutralIMG:SizeToContents()
		NeutralIMG:SetImage("gbay/Neutral.png")

		local NegativeIMG = vgui.Create("DImage", SideBarOpened)
		NegativeIMG:SetPos(220, 160)
		NegativeIMG:SizeToContents()
		NegativeIMG:SetImage("gbay/Negative.png")

		local ScrollList = vgui.Create( "DPanelList", SideBarOpened )
		ScrollList:SetPos( 5, 420 )
		ScrollList:SetSize( SideBarOpened:GetWide(), SideBarOpened:GetTall() - 440 )
		ScrollList:EnableHorizontal(true)
		ScrollList:SetSpacing( 20 )
		ScrollList:EnableVerticalScrollbar( true )
		ScrollList.VBar.Paint = function( s, w, h )
		end
		ScrollList.VBar.btnUp.Paint = function( s, w, h ) end
		ScrollList.VBar.btnDown.Paint = function( s, w, h ) end
		ScrollList.VBar.btnGrip.Paint = function( s, w, h )
		end
		for k, v in pairs(data[3]) do
			if v[2] == playerdata[2] then
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
					GBayViewMoreItemSmall("Shipment", DFrame, data, v)
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
				local numbers = {playerdata[4], -playerdata[5], -playerdata[6]}
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
	elseif tab == "Create" then
		local GBayLogoCreate = Material("gbay/Create_Logo.png")
		local used = false
		usedshipments = false
		usedent = false
		usedservice = false
		tab = "Dashboard"
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoCreate	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			draw.SimpleText("What type of item?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			if usedshipments then
				draw.SimpleText("Name of the shipment?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the shipment?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Select your weapon!","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your shipment?","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Shipment??","GBayLabelFont",w / 2,460,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,520,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			elseif usedservice then
				draw.SimpleText("Name of the service?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the service?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your service?","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Service??","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

				draw.RoundedBox(0,0,460,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,550,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			elseif usedent then
				draw.SimpleText("Name of the entity?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the entity?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Select your entity!","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your entity?","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Entity??","GBayLabelFont",w / 2,460,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,520,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			end
		end

		local CreateItmType = vgui.Create( "DComboBox", SideBarOpened )
		CreateItmType:SetPos(20, 170)
		CreateItmType:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmType:SetValue( "Item Type" )
		CreateItmType:AddChoice( "Shipment" )
		CreateItmType:AddChoice( "Entity" )
		CreateItmType:AddChoice( "Service" )
		CreateItmType.OnSelect = function( panel, index, value )
			if used then
				GBaySideBarClosed(DFrame, "Create", false, data, firstjoined)
				GBaySideBarOpened(DFrame, "Create", false, data, false)
				if value == "Shipment" then
					local CreateItmShipName = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmShipName:SetPos(20, 230)
					CreateItmShipName:SetSize(SideBarOpened:GetWide() - 40, 20 )
					CreateItmShipName:SetText( "Shipment name" )
					CreateItmShipName.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 27 then
							local timeleftforrestriction = 5
							s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment name")
									s:SetEditable(true)
									return
								end
								s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local CreateItmShipDesc = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmShipDesc:SetPos(20, 290)
					CreateItmShipDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
					CreateItmShipDesc:SetText( "Shipment Description" )
					CreateItmShipDesc:SetMultiline( true )
					CreateItmShipDesc.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 81 then
							local timeleftforrestriction = 5
							s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment Description")
									s:SetEditable(true)
									return
								end
								s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local SelWepBtn = vgui.Create("DButton", SideBarOpened)
					SelWepBtn:SetPos(20, 370)
					SelWepBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelWepBtn:SetText("Select Shipmet (must be close)")
					SelWepBtn:SetTextColor(Color(255,255,255))
					SelWepBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelWepBtn.Weapon = nil
					SelWepBtn.DoClick = function()
						GBaySelectWeapon(DFrame, SelWepBtn)
					end

					local SelWepPrice = vgui.Create( "DNumSlider", SideBarOpened )
					SelWepPrice:SetPos( 20, 430 )
					SelWepPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
					SelWepPrice:SetText( "" )
					SelWepPrice:SetMin( 0 )
					SelWepPrice:SetMax( GBayConfig.MaxPrice )
					SelWepPrice:SetDecimals( 0 )

					local SelWepSubBtn = vgui.Create("DButton", SideBarOpened)
					SelWepSubBtn:SetPos(20, 490)
					SelWepSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelWepSubBtn:SetText("Submit Shipment")
					SelWepSubBtn:SetTextColor(Color(255,255,255))
					SelWepSubBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelWepSubBtn.DoClick = function()
						net.Start("GBaySubmitShipment")
							net.WriteString(CreateItmShipName:GetValue())
							net.WriteString(CreateItmShipDesc:GetValue())
							net.WriteEntity(SelWepBtn.Weapon)
							net.WriteFloat(SelWepPrice:GetValue())
						net.SendToServer()
						GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
					end
					usedshipments = true
				elseif value == "Service" then
					usedservice = true
					local CreateItmServName = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmServName:SetPos(20, 230)
					CreateItmServName:SetSize(SideBarOpened:GetWide() - 40, 20 )
					CreateItmServName:SetText( "Service name" )
					CreateItmServName.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 27 then
							local timeleftforrestriction = 5
							s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment name")
									s:SetEditable(true)
									return
								end
								s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local CreateItmServDesc = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmServDesc:SetPos(20, 290)
					CreateItmServDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
					CreateItmServDesc:SetText( "Service Description" )
					CreateItmServDesc:SetMultiline( true )
					CreateItmServDesc.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 81 then
							local timeleftforrestriction = 5
							s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Service Description")
									s:SetEditable(true)
									return
								end
								s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local SelServPrice = vgui.Create( "DNumSlider", SideBarOpened )
					SelServPrice:SetPos( 20, 370 )
					SelServPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
					SelServPrice:SetText( "" )
					SelServPrice:SetMin( 0 )
					SelServPrice:SetMax( GBayConfig.MaxPrice )
					SelServPrice:SetDecimals( 0 )

					local SelServSubBtn = vgui.Create("DButton", SideBarOpened)
					SelServSubBtn:SetPos(20, 430)
					SelServSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelServSubBtn:SetText("Submit Service")
					SelServSubBtn:SetTextColor(Color(255,255,255))
					SelServSubBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelServSubBtn.DoClick = function()
						net.Start("GBaySubmitService")
							net.WriteString(CreateItmServName:GetValue())
							net.WriteString(CreateItmServDesc:GetValue())
							net.WriteFloat(SelServPrice:GetValue())
						net.SendToServer()
						GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
					end
				end
			else
				if value == "Shipment" then
					usedshipments = true
					local CreateItmShipName = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmShipName:SetPos(20, 230)
					CreateItmShipName:SetSize(SideBarOpened:GetWide() - 40, 20 )
					CreateItmShipName:SetText( "Shipment name" )
					CreateItmShipName.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 27 then
							local timeleftforrestriction = 5
							s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment name")
									s:SetEditable(true)
									return
								end
								s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local CreateItmShipDesc = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmShipDesc:SetPos(20, 290)
					CreateItmShipDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
					CreateItmShipDesc:SetText( "Shipment Description" )
					CreateItmShipDesc:SetMultiline( true )
					CreateItmShipDesc.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 81 then
							local timeleftforrestriction = 5
							s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment Description")
									s:SetEditable(true)
									return
								end
								s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local SelWepBtn = vgui.Create("DButton", SideBarOpened)
					SelWepBtn:SetPos(20, 370)
					SelWepBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelWepBtn:SetText("Select Shipmet (must be close)")
					SelWepBtn:SetTextColor(Color(255,255,255))
					SelWepBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelWepBtn.Weapon = nil
					SelWepBtn.DoClick = function()
						GBaySelectWeapon(DFrame, SelWepBtn)
					end

					local SelWepPrice = vgui.Create( "DNumSlider", SideBarOpened )
					SelWepPrice:SetPos( 20, 430 )
					SelWepPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
					SelWepPrice:SetText( "" )
					SelWepPrice:SetMin( 0 )
					SelWepPrice:SetMax( GBayConfig.MaxPrice )
					SelWepPrice:SetDecimals( 0 )

					local SelWepSubBtn = vgui.Create("DButton", SideBarOpened)
					SelWepSubBtn:SetPos(20, 490)
					SelWepSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelWepSubBtn:SetText("Submit Shipment")
					SelWepSubBtn:SetTextColor(Color(255,255,255))
					SelWepSubBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelWepSubBtn.DoClick = function()
						net.Start("GBaySubmitShipment")
							net.WriteString(CreateItmShipName:GetValue())
							net.WriteString(CreateItmShipDesc:GetValue())
							net.WriteEntity(SelWepBtn.Weapon)
							net.WriteFloat(SelWepPrice:GetValue())
						net.SendToServer()
						GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
					end
				elseif value == "Service" then
					usedservice = true
					local CreateItmServName = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmServName:SetPos(20, 230)
					CreateItmServName:SetSize(SideBarOpened:GetWide() - 40, 20 )
					CreateItmServName:SetText( "Service name" )
					CreateItmServName.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 27 then
							local timeleftforrestriction = 5
							s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Shipment name")
									s:SetEditable(true)
									return
								end
								s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local CreateItmServDesc = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmServDesc:SetPos(20, 290)
					CreateItmServDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
					CreateItmServDesc:SetText( "Service Description" )
					CreateItmServDesc:SetMultiline( true )
					CreateItmServDesc.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 81 then
							local timeleftforrestriction = 5
							s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Service Description")
									s:SetEditable(true)
									return
								end
								s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local SelServPrice = vgui.Create( "DNumSlider", SideBarOpened )
					SelServPrice:SetPos( 20, 370 )
					SelServPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
					SelServPrice:SetText( "" )
					SelServPrice:SetMin( 0 )
					SelServPrice:SetMax( GBayConfig.MaxPrice )
					SelServPrice:SetDecimals( 0 )

					local SelServSubBtn = vgui.Create("DButton", SideBarOpened)
					SelServSubBtn:SetPos(20, 430)
					SelServSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelServSubBtn:SetText("Submit Service")
					SelServSubBtn:SetTextColor(Color(255,255,255))
					SelServSubBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelServSubBtn.DoClick = function()
						net.Start("GBaySubmitService")
							net.WriteString(CreateItmServName:GetValue())
							net.WriteString(CreateItmServDesc:GetValue())
							net.WriteFloat(SelServPrice:GetValue())
						net.SendToServer()
						GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
					end
				elseif value == "Entity" then
					usedshipments = true
					local CreateItmEntName = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmEntName:SetPos(20, 230)
					CreateItmEntName:SetSize(SideBarOpened:GetWide() - 40, 20 )
					CreateItmEntName:SetText( "Entity name" )
					CreateItmEntName.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 27 then
							local timeleftforrestriction = 5
							s:SetText("Entity name must be < 27 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Entity name")
									s:SetEditable(true)
									return
								end
								s:SetText("Entity name must be < 27 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local CreateItmEntDesc = vgui.Create( "DTextEntry", SideBarOpened )
					CreateItmEntDesc:SetPos(20, 290)
					CreateItmEntDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
					CreateItmEntDesc:SetText( "Entity Description" )
					CreateItmEntDesc:SetMultiline( true )
					CreateItmEntDesc.OnTextChanged = function(s)
						if string.len(s:GetValue()) > 81 then
							local timeleftforrestriction = 5
							s:SetText("Entity description must be < 81 characters... ("..timeleftforrestriction..")")
							s:SetEditable(false)
							timer.Create("GBayUnlockServerNameEntry",1, 5, function()
								timeleftforrestriction = timeleftforrestriction - 1
								if timeleftforrestriction <= 0 then
									s:SetText("Entity Description")
									s:SetEditable(true)
									return
								end
								s:SetText("Entity description must be < 81 characters... ("..timeleftforrestriction..")")
							end)
						end
					end

					local SelEntBtn = vgui.Create("DButton", SideBarOpened)
					SelEntBtn:SetPos(20, 370)
					SelEntBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelEntBtn:SetText("Select Entity (must be close)")
					SelEntBtn:SetTextColor(Color(255,255,255))
					SelEntBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelEntBtn.Entity = nil
					SelEntBtn.DoClick = function()
						GBaySelectEntity(DFrame, SelEntBtn)
					end

					local SelEntPrice = vgui.Create( "DNumSlider", SideBarOpened )
					SelEntPrice:SetPos( 20, 430 )
					SelEntPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
					SelEntPrice:SetText( "" )
					SelEntPrice:SetMin( 0 )
					SelEntPrice:SetMax( GBayConfig.MaxPrice )
					SelEntPrice:SetDecimals( 0 )

					local SelWepSubBtn = vgui.Create("DButton", SideBarOpened)
					SelWepSubBtn:SetPos(20, 490)
					SelWepSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
					SelWepSubBtn:SetText("Submit Entity")
					SelWepSubBtn:SetTextColor(Color(255,255,255))
					SelWepSubBtn.Paint = function(s, w, h)
						draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
					end
					SelWepSubBtn.DoClick = function()
						net.Start("GBaySubmitEntity")
							net.WriteString(CreateItmEntName:GetValue())
							net.WriteString(CreateItmEntDesc:GetValue())
							net.WriteEntity(SelEntBtn.Entity)
							net.WriteFloat(SelEntPrice:GetValue())
						net.SendToServer()
						GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
					end
				end
			end
			used = true
		end
	elseif tab == "EditShip" then
		local GBayLogoCreate = Material("gbay/Create_Logo.png")
		usedshipments = true
		tab = "Dashboard"
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoCreate	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			draw.SimpleText("What type of item?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			if usedshipments then
				draw.SimpleText("Name of the shipment?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the shipment?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Select your weapon!","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your shipment?","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Item??","GBayLabelFont",w / 2,460,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

				draw.RoundedBox(0,0,520,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

			end
		end

		local CreateItmType = vgui.Create( "DComboBox", SideBarOpened )
		CreateItmType:SetPos(20, 170)
		CreateItmType:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmType:SetValue( "Shipment" )
		CreateItmType:AddChoice( "Shipment" )

		local editingwep = nil

		for k, v in pairs(data[3]) do
			if v[1] == LocalPlayer().GBayIsEditing then
				editingwep = v
			end
		end

		local CreateItmShipName = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmShipName:SetPos(20, 230)
		CreateItmShipName:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmShipName:SetText( editingwep[3] )
		CreateItmShipName.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 27 then
				local timeleftforrestriction = 5
				s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Shipment name")
						s:SetEditable(true)
						return
					end
					s:SetText("Shipment name must be < 27 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local CreateItmShipDesc = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmShipDesc:SetPos(20, 290)
		CreateItmShipDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
		CreateItmShipDesc:SetText( editingwep[4] )
		CreateItmShipDesc:SetMultiline( true )
		CreateItmShipDesc.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 81 then
				local timeleftforrestriction = 5
				s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Shipment Description")
						s:SetEditable(true)
						return
					end
					s:SetText("Shipment description must be < 81 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local SelWepBtn = vgui.Create("DButton", SideBarOpened)
		SelWepBtn:SetPos(20, 370)
		SelWepBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
		SelWepBtn:SetText(editingwep[5])
		SelWepBtn:SetTextColor(Color(255,255,255))
		SelWepBtn.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		SelWepBtn.DoClick = function()

		end

		local SelWepPrice = vgui.Create( "DNumSlider", SideBarOpened )
		SelWepPrice:SetPos( 20, 430 )
		SelWepPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
		SelWepPrice:SetText( "" )
		SelWepPrice:SetMin( 0 )
		SelWepPrice:SetMax( GBayConfig.MaxPrice )
		SelWepPrice:SetValue(editingwep[6])
		SelWepPrice:SetDecimals( 0 )

		local SelWepSubBtn = vgui.Create("DButton", SideBarOpened)
		SelWepSubBtn:SetPos(20, 490)
		SelWepSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
		SelWepSubBtn:SetText("Edit Shipment")
		SelWepSubBtn:SetTextColor(Color(255,255,255))
		SelWepSubBtn.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		SelWepSubBtn.DoClick = function()
			net.Start("GBayEditShipment")
				net.WriteTable(editingwep)
				net.WriteString(CreateItmShipName:GetValue())
				net.WriteString(CreateItmShipDesc:GetValue())
				net.WriteFloat(SelWepPrice:GetValue())
			net.SendToServer()
			GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
		end
		usedshipments = true
	elseif tab == "EditServ" then
		local GBayLogoCreate = Material("gbay/Create_Logo.png")
		usedservice = true
		tab = "Dashboard"
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoCreate	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			draw.SimpleText("What type of item?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			if usedservice then
				draw.SimpleText("Name of the service?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the service?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your shipment?","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Item??","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

				draw.RoundedBox(0,0,560,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

			end
		end

		local CreateItmType = vgui.Create( "DComboBox", SideBarOpened )
		CreateItmType:SetPos(20, 170)
		CreateItmType:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmType:SetValue( "Service" )
		CreateItmType:AddChoice( "Service" )

		local editingwep = nil

		for k, v in pairs(data[4]) do
			if v[1] == LocalPlayer().GBayIsEditing then
				editingwep = v
			end
		end

		local CreateItmServName = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmServName:SetPos(20, 230)
		CreateItmServName:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmServName:SetText( editingwep[3] )
		CreateItmServName.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 27 then
				local timeleftforrestriction = 5
				s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Service name")
						s:SetEditable(true)
						return
					end
					s:SetText("Service name must be < 27 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local CreateItmServDesc = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmServDesc:SetPos(20, 290)
		CreateItmServDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
		CreateItmServDesc:SetText( editingwep[4] )
		CreateItmServDesc:SetMultiline( true )
		CreateItmServDesc.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 81 then
				local timeleftforrestriction = 5
				s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Service Description")
						s:SetEditable(true)
						return
					end
					s:SetText("Service description must be < 81 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local SelServPrice = vgui.Create( "DNumSlider", SideBarOpened )
		SelServPrice:SetPos( 20, 370 )
		SelServPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
		SelServPrice:SetText( "" )
		SelServPrice:SetMin( 0 )
		SelServPrice:SetMax( GBayConfig.MaxPrice )
		SelServPrice:SetValue(editingwep[6])
		SelServPrice:SetDecimals( 0 )

		local SelServSubBtn = vgui.Create("DButton", SideBarOpened)
		SelServSubBtn:SetPos(20, 430)
		SelServSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
		SelServSubBtn:SetText("Edit Service")
		SelServSubBtn:SetTextColor(Color(255,255,255))
		SelServSubBtn.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		SelServSubBtn.DoClick = function()
			net.Start("GBayEditService")
				net.WriteTable(editingwep)
				net.WriteString(CreateItmServName:GetValue())
				net.WriteString(CreateItmServDesc:GetValue())
				net.WriteFloat(SelServPrice:GetValue())
			net.SendToServer()
			GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
		end
		usedservice = true
	elseif tab == "EditEnt" then
		local GBayLogoCreate = Material("gbay/Create_Logo.png")
		usedshipments = true
		tab = "Dashboard"
		SideBarOpened.Paint = function(s, w, h)
			surface.SetDrawColor(255,255,255, 255)
			surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogoCreate	)
			surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
			draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
			draw.SimpleText("What type of item?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			if usedent then
				draw.SimpleText("Name of the entity?","GBayLabelFont",w / 2,200,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Description of the entity?","GBayLabelFont",w / 2,260,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Select your entity!","GBayLabelFont",w / 2,340,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("What is the price of your entity?","GBayLabelFont",w / 2,400,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Submit your Item??","GBayLabelFont",w / 2,460,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)

				draw.RoundedBox(0,0,520,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			end
		end

		local CreateItmType = vgui.Create( "DComboBox", SideBarOpened )
		CreateItmType:SetPos(20, 170)
		CreateItmType:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmType:SetValue( "Entity" )
		CreateItmType:AddChoice( "Entity" )

		local editingwep = nil

		for k, v in pairs(data[5]) do
			if v[1] == LocalPlayer().GBayIsEditing then
				editingwep = v
			end
		end

		local CreateItmEntName = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmEntName:SetPos(20, 230)
		CreateItmEntName:SetSize(SideBarOpened:GetWide() - 40, 20 )
		CreateItmEntName:SetText( editingwep[3] )
		CreateItmEntName.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 27 then
				local timeleftforrestriction = 5
				s:SetText("Entity name must be < 27 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Entity name")
						s:SetEditable(true)
						return
					end
					s:SetText("Entity name must be < 27 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local CreateItmEntDesc = vgui.Create( "DTextEntry", SideBarOpened )
		CreateItmEntDesc:SetPos(20, 290)
		CreateItmEntDesc:SetSize(SideBarOpened:GetWide() - 40, 40 )
		CreateItmEntDesc:SetText( editingwep[4] )
		CreateItmEntDesc:SetMultiline( true )
		CreateItmEntDesc.OnTextChanged = function(s)
			if string.len(s:GetValue()) > 81 then
				local timeleftforrestriction = 5
				s:SetText("Entity description must be < 81 characters... ("..timeleftforrestriction..")")
				s:SetEditable(false)
				timer.Create("GBayUnlockServerNameEntry",1, 5, function()
					timeleftforrestriction = timeleftforrestriction - 1
					if timeleftforrestriction <= 0 then
						s:SetText("Entity Description")
						s:SetEditable(true)
						return
					end
					s:SetText("Entity description must be < 81 characters... ("..timeleftforrestriction..")")
				end)
			end
		end

		local SelEntBtn = vgui.Create("DButton", SideBarOpened)
		SelEntBtn:SetPos(20, 370)
		SelEntBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
		SelEntBtn:SetText(editingwep[5])
		SelEntBtn:SetTextColor(Color(255,255,255))
		SelEntBtn.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		SelEntBtn.DoClick = function()

		end

		local SelEntPrice = vgui.Create( "DNumSlider", SideBarOpened )
		SelEntPrice:SetPos( 20, 430 )
		SelEntPrice:SetSize( SideBarOpened:GetWide() - 40, 20 )
		SelEntPrice:SetText( "" )
		SelEntPrice:SetMin( 0 )
		SelEntPrice:SetMax( GBayConfig.MaxPrice )
		SelEntPrice:SetValue(editingwep[6])
		SelEntPrice:SetDecimals( 0 )

		local SelEntSubBtn = vgui.Create("DButton", SideBarOpened)
		SelEntSubBtn:SetPos(20, 490)
		SelEntSubBtn:SetSize(SideBarOpened:GetWide() - 40, 20)
		SelEntSubBtn:SetText("Edit Entity")
		SelEntSubBtn:SetTextColor(Color(255,255,255))
		SelEntSubBtn.Paint = function(s, w, h)
			draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
		end
		SelEntSubBtn.DoClick = function()
			net.Start("GBayEditEntity")
				net.WriteTable(editingwep)
				net.WriteString(CreateItmEntName:GetValue())
				net.WriteString(CreateItmEntDesc:GetValue())
				net.WriteFloat(SelEntPrice:GetValue())
			net.SendToServer()
			GBaySideBarOpened(DFrame, "Loading", false, data, firstjoined)
		end
		usedent = true
	elseif tab == "Purchase" then
		if LocalPlayer().GBayBuyingItemT == "Shipment" then
			local GBayLogoCheckOut = Material("gbay/Check_Out.png")
			local postoputtext = 190
			local keepgoing = true
			local totalprice = 0
			local costofone = LocalPlayer().GBayBuyingItem[6] / LocalPlayer().GBayBuyingItem[7]
			SideBarOpened.Paint = function(s, w, h)
				surface.SetDrawColor(255,255,255, 255)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( GBayLogoCheckOut	)
				surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
				draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
				draw.SimpleText(LocalPlayer().GBayBuyingItem[3] .." Purchase","GBayLabelFontBold",w / 2,150,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Quantity to purchase: "..LocalPlayer().GBayBuyingItemQ,"GBayLabelFont",w / 2,170,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			for i=1, LocalPlayer().GBayBuyingItemQ do
				if i > 10 then
					if keepgoing then
						local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
						TheLabelForItems:SetPos(20, postoputtext)
						TheLabelForItems:SetText("+"..LocalPlayer().GBayBuyingItemQ - i.." "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone * LocalPlayer().GBayBuyingItemQ -i ))
						TheLabelForItems:SetFont("GBayLabelFont")
						TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
						TheLabelForItems:SizeToContents()
						keepgoing = false
						totalprice = totalprice + costofone * LocalPlayer().GBayBuyingItemQ -i
					end
				else
					local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
					TheLabelForItems:SetPos(20, postoputtext)
					TheLabelForItems:SetText("+1 "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone))
					TheLabelForItems:SetFont("GBayLabelFont")
					TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
					TheLabelForItems:SizeToContents()
					postoputtext = postoputtext + 20
					totalprice = totalprice + costofone
				end
			end

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 160)
			TheTaxRate:SetText("Price: "..DarkRP.formatMoney(totalprice))
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 140)
			TheTaxRate:SetText("Tax Rate: "..GBayConfig.TaxToMultiplyBy * 100 .. "%")
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxPrice = vgui.Create("DLabel", SideBarOpened)
			TheTaxPrice:SetPos(20, SideBarOpened:GetTall() - 120)
			TheTaxPrice:SetText("Tax: "..DarkRP.formatMoney(totalprice * GBayConfig.TaxToMultiplyBy))
			TheTaxPrice:SetFont("GBayLabelFont")
			TheTaxPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxPrice:SizeToContents()

			totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy

			local TheFinalPrice = vgui.Create("DLabel", SideBarOpened)
			TheFinalPrice:SetPos(20, SideBarOpened:GetTall() - 100)
			TheFinalPrice:SetText("Subtotal: "..DarkRP.formatMoney(totalprice))
			TheFinalPrice:SetFont("GBayLabelFont")
			TheFinalPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheFinalPrice:SizeToContents()

			local CheckOutBtn = vgui.Create("DButton",SideBarOpened)
			CheckOutBtn:SetPos(20, SideBarOpened:GetTall() - 70)
			CheckOutBtn:SetSize(SideBarOpened:GetWide() - 40, 40)
			CheckOutBtn:SetText("Check out")
			CheckOutBtn:SetTextColor(Color(255,255,255))
			CheckOutBtn.Paint = function(s, w, h)
				draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
			end
			CheckOutBtn.DoClick = function()
				net.Start("GBayPurchaseItem")
					net.WriteString(LocalPlayer().GBayBuyingItemT)
				  net.WriteFloat(LocalPlayer().GBayBuyingItemQ)
				  net.WriteTable(LocalPlayer().GBayBuyingItem)
				net.SendToServer()
				GBaySideBarOpened(DFrame, "TransPending", false, data, firstjoined)
			end
		elseif LocalPlayer().GBayBuyingItemT == "Service" then
			local GBayLogoCheckOut = Material("gbay/Check_Out.png")
			local postoputtext = 190
			local keepgoing = true
			local totalprice = 0
			local costofone = LocalPlayer().GBayBuyingItem[5]
			SideBarOpened.Paint = function(s, w, h)
				surface.SetDrawColor(255,255,255, 255)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( GBayLogoCheckOut	)
				surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
				draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
				draw.SimpleText(LocalPlayer().GBayBuyingItem[3] .." Purchase","GBayLabelFontBold",w / 2,150,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Quantity to purchase: "..LocalPlayer().GBayBuyingItemQ,"GBayLabelFont",w / 2,170,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			for i=1, LocalPlayer().GBayBuyingItemQ do
				if i > 10 then
					if keepgoing then
						local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
						TheLabelForItems:SetPos(20, postoputtext)
						TheLabelForItems:SetText("+"..LocalPlayer().GBayBuyingItemQ - i.." "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone * LocalPlayer().GBayBuyingItemQ -i ))
						TheLabelForItems:SetFont("GBayLabelFont")
						TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
						TheLabelForItems:SizeToContents()
						keepgoing = false
						totalprice = totalprice + costofone * LocalPlayer().GBayBuyingItemQ -i
					end
				else
					local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
					TheLabelForItems:SetPos(20, postoputtext)
					TheLabelForItems:SetText("+1 "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone))
					TheLabelForItems:SetFont("GBayLabelFont")
					TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
					TheLabelForItems:SizeToContents()
					postoputtext = postoputtext + 20
					totalprice = totalprice + costofone
				end
			end

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 160)
			TheTaxRate:SetText("Price: "..DarkRP.formatMoney(totalprice))
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 140)
			TheTaxRate:SetText("Tax Rate: "..GBayConfig.TaxToMultiplyBy * 100 .. "%")
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxPrice = vgui.Create("DLabel", SideBarOpened)
			TheTaxPrice:SetPos(20, SideBarOpened:GetTall() - 120)
			TheTaxPrice:SetText("Tax: "..DarkRP.formatMoney(totalprice * GBayConfig.TaxToMultiplyBy))
			TheTaxPrice:SetFont("GBayLabelFont")
			TheTaxPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxPrice:SizeToContents()

			totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy

			local TheFinalPrice = vgui.Create("DLabel", SideBarOpened)
			TheFinalPrice:SetPos(20, SideBarOpened:GetTall() - 100)
			TheFinalPrice:SetText("Subtotal: "..DarkRP.formatMoney(totalprice))
			TheFinalPrice:SetFont("GBayLabelFont")
			TheFinalPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheFinalPrice:SizeToContents()

			local CheckOutBtn = vgui.Create("DButton",SideBarOpened)
			CheckOutBtn:SetPos(20, SideBarOpened:GetTall() - 70)
			CheckOutBtn:SetSize(SideBarOpened:GetWide() - 40, 40)
			CheckOutBtn:SetText("Check out")
			CheckOutBtn:SetTextColor(Color(255,255,255))
			CheckOutBtn.Paint = function(s, w, h)
				draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
			end
			CheckOutBtn.DoClick = function()
				net.Start("GBayPurchaseItem")
					net.WriteString(LocalPlayer().GBayBuyingItemT)
				  net.WriteFloat(LocalPlayer().GBayBuyingItemQ)
				  net.WriteTable(LocalPlayer().GBayBuyingItem)
				net.SendToServer()
				GBaySideBarOpened(DFrame, "TransPending", false, data, firstjoined)
			end
		elseif LocalPlayer().GBayBuyingItemT == "Entity" then
			local GBayLogoCheckOut = Material("gbay/Check_Out.png")
			local postoputtext = 190
			local keepgoing = true
			local totalprice = 0
			local costofone = LocalPlayer().GBayBuyingItem[6]
			SideBarOpened.Paint = function(s, w, h)
				surface.SetDrawColor(255,255,255, 255)
				surface.DrawRect(0, 0, w, h)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( GBayLogoCheckOut	)
				surface.DrawTexturedRect(w / 2 - 129/2,45,129,52)
				draw.RoundedBox(0,0,130,w,2,Color(221,221,221))
				draw.SimpleText(LocalPlayer().GBayBuyingItem[3] .." Purchase","GBayLabelFontBold",w / 2,150,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText("Quantity to purchase: "..LocalPlayer().GBayBuyingItemQ,"GBayLabelFont",w / 2,170,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			for i=1, LocalPlayer().GBayBuyingItemQ do
				if i > 10 then
					if keepgoing then
						local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
						TheLabelForItems:SetPos(20, postoputtext)
						TheLabelForItems:SetText("+"..LocalPlayer().GBayBuyingItemQ - i.." "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone * LocalPlayer().GBayBuyingItemQ -i ))
						TheLabelForItems:SetFont("GBayLabelFont")
						TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
						TheLabelForItems:SizeToContents()
						keepgoing = false
						totalprice = totalprice + costofone * LocalPlayer().GBayBuyingItemQ -i
					end
				else
					local TheLabelForItems = vgui.Create("DLabel", SideBarOpened)
					TheLabelForItems:SetPos(20, postoputtext)
					TheLabelForItems:SetText("+1 "..LocalPlayer().GBayBuyingItem[3].." - "..DarkRP.formatMoney(costofone))
					TheLabelForItems:SetFont("GBayLabelFont")
					TheLabelForItems:SetTextColor(Color( 137, 137, 137, 255 ))
					TheLabelForItems:SizeToContents()
					postoputtext = postoputtext + 20
					totalprice = totalprice + costofone
				end
			end

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 160)
			TheTaxRate:SetText("Price: "..DarkRP.formatMoney(totalprice))
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxRate = vgui.Create("DLabel", SideBarOpened)
			TheTaxRate:SetPos(20, SideBarOpened:GetTall() - 140)
			TheTaxRate:SetText("Tax Rate: "..GBayConfig.TaxToMultiplyBy * 100 .. "%")
			TheTaxRate:SetFont("GBayLabelFont")
			TheTaxRate:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxRate:SizeToContents()

			local TheTaxPrice = vgui.Create("DLabel", SideBarOpened)
			TheTaxPrice:SetPos(20, SideBarOpened:GetTall() - 120)
			TheTaxPrice:SetText("Tax: "..DarkRP.formatMoney(totalprice * GBayConfig.TaxToMultiplyBy))
			TheTaxPrice:SetFont("GBayLabelFont")
			TheTaxPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheTaxPrice:SizeToContents()

			totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy

			local TheFinalPrice = vgui.Create("DLabel", SideBarOpened)
			TheFinalPrice:SetPos(20, SideBarOpened:GetTall() - 100)
			TheFinalPrice:SetText("Subtotal: "..DarkRP.formatMoney(totalprice))
			TheFinalPrice:SetFont("GBayLabelFont")
			TheFinalPrice:SetTextColor(Color( 137, 137, 137, 255 ))
			TheFinalPrice:SizeToContents()

			local CheckOutBtn = vgui.Create("DButton",SideBarOpened)
			CheckOutBtn:SetPos(20, SideBarOpened:GetTall() - 70)
			CheckOutBtn:SetSize(SideBarOpened:GetWide() - 40, 40)
			CheckOutBtn:SetText("Check out")
			CheckOutBtn:SetTextColor(Color(255,255,255))
			CheckOutBtn.Paint = function(s, w, h)
				draw.RoundedBox(3,0,0,w,h,Color(0, 95, 168))
			end
			CheckOutBtn.DoClick = function()
				net.Start("GBayPurchaseItem")
					net.WriteString(LocalPlayer().GBayBuyingItemT)
				  net.WriteFloat(LocalPlayer().GBayBuyingItemQ)
				  net.WriteTable(LocalPlayer().GBayBuyingItem)
				net.SendToServer()
				GBaySideBarOpened(DFrame, "TransPending", false, data, firstjoined)
			end
		end
	end
end
