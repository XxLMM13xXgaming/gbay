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
		local nomoney = false
		local wronginfo = false
		local error = false
		net.Receive("GBayTransErrorReport",function()
			report = net.ReadString()
			nomoney = false
			wronginfo = false
			error = false
			samep = false
			success = false
			if report == "Money" then nomoney = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Info" then wronginfo = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "Error" then error = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
			if report == "SamePlayer" then samep = true timer.Simple(5, function() GBaySideBarClosed(DFrame, "Dashboard", false, data, false) end) end
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
				draw.SimpleText("Whats your server name?","GBayLabelFont",w / 2,140,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,200,w,2,Color(221,221,221))
				draw.SimpleText("Can people pay for ads?","GBayLabelFont",w / 2,210,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,300,w,2,Color(221,221,221))
				draw.SimpleText("Can people sell services?","GBayLabelFont",w / 2,310,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,400,w,2,Color(221,221,221))
				draw.SimpleText("Can people create coupons?","GBayLabelFont",w / 2,410,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.RoundedBox(0,0,500,w,2,Color(221,221,221))
				draw.SimpleText("More content coming.","GBayLabelFontBold",w / 2,570,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Check updates tab often","GBayLabelFont",w / 2,590,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText(" to keep up to date!","GBayLabelFont",w / 2,610,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			else
				draw.SimpleText("Get outta here!","GBayLabelFontBold",w / 2,h/2,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Currently there are no user settings","GBayLabelFont",w / 2,h/2 - 30,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
				draw.SimpleText("Maybe sometime soon!","GBayLabelFont",w / 2,h/2 - 60,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER)
			end
		end

		if playerisadmin then
			ServerNameTE = vgui.Create("DTextEntry",SideBarOpened)
			ServerNameTE:SetPos(20, 170)
			ServerNameTE:SetSize(SideBarOpened:GetWide() - 40, 20 )
			if !firstjoined then
				ServerNameTE:SetText(data[2][1][2])
			else
				ServerNameTE:SetText("Server Name")
			end
			ServerNameTE.OnTextChanged = function(s)
				if string.len(s:GetValue()) > 15 then
					local timeleftforrestriction = 5
					s:SetText("Server name must be < 15 characters... ("..timeleftforrestriction..")")
					s:SetEditable(false)
					timer.Create("GBayUnlockServerNameEntry",1, 5, function()
						timeleftforrestriction = timeleftforrestriction - 1
						if timeleftforrestriction <= 0 then
							s:SetText("Server Name")
							s:SetEditable(true)
							return
						end
						s:SetText("Server name must be < 15 characters... ("..timeleftforrestriction..")")
					end)
				end
			end

			AdsCheckBoxYes = vgui.Create( "DCheckBoxLabel", SideBarOpened )
			AdsCheckBoxYes:SetPos( 20, 240 )
			if data != nil then
				if data[2][1][3] == 1 then
					AdsCheckBoxYes:SetValue( 1 )
				else
					AdsCheckBoxYes:SetValue( 0 )
				end
			else
				AdsCheckBoxYes:SetValue( 0 )
			end
			AdsCheckBoxYes:SetText("Yes")
			AdsCheckBoxYes:SetFont("GBayLabelFont")
			AdsCheckBoxYes:SetTextColor(Color(137, 137, 137))
			AdsCheckBoxYes.OnChange = function(value)
				if value then
					if AdsCheckBoxNo:GetChecked() then
						AdsCheckBoxNo:SetValue(0)
						return
					end
				end
			end

			AdsCheckBoxNo = vgui.Create( "DCheckBoxLabel", SideBarOpened )
			AdsCheckBoxNo:SetPos( 20, 270 )
			if data != nil then
				if data[2][1][3] == 1 then
					AdsCheckBoxNo:SetValue( 0 )
				else
					AdsCheckBoxNo:SetValue( 1 )
				end
			else
				AdsCheckBoxNo:SetValue( 0 )
			end
			AdsCheckBoxNo:SetText("No")
			AdsCheckBoxNo:SetFont("GBayLabelFont")
			AdsCheckBoxNo:SetTextColor(Color(137, 137, 137))
			AdsCheckBoxNo.OnChange = function(value)
				if value then
					if AdsCheckBoxYes:GetChecked() then
						AdsCheckBoxYes:SetValue(0)
						return
					end

				end
			end

			ServiceCheckBoxYes = vgui.Create( "DCheckBoxLabel", SideBarOpened)
			ServiceCheckBoxYes:SetPos(20, 340)
			if data != nil then
				if data[2][1][4] == 1 then
					ServiceCheckBoxYes:SetValue( 1 )
				else
					ServiceCheckBoxYes:SetValue( 0 )
				end
			else
				ServiceCheckBoxYes:SetValue( 0 )
			end
			ServiceCheckBoxYes:SetText("Yes")
			ServiceCheckBoxYes:SetFont("GBayLabelFont")
			ServiceCheckBoxYes:SetTextColor(Color(137, 137, 137))
			ServiceCheckBoxYes.OnChange = function(value)
				if value then
					if ServiceCheckBoxNo:GetChecked() then
						ServiceCheckBoxNo:SetValue(0)
						return
					end
				end
			end

			ServiceCheckBoxNo = vgui.Create( "DCheckBoxLabel", SideBarOpened)
			ServiceCheckBoxNo:SetPos(20, 370)
			if data != nil then
				if data[2][1][4] == 1 then
					ServiceCheckBoxNo:SetValue( 0 )
				else
					ServiceCheckBoxNo:SetValue( 1 )
				end
			else
				ServiceCheckBoxNo:SetValue( 0 )
			end
			ServiceCheckBoxNo:SetText("No")
			ServiceCheckBoxNo:SetFont("GBayLabelFont")
			ServiceCheckBoxNo:SetTextColor(Color(137, 137, 137))
			ServiceCheckBoxNo.OnChange = function(value)
				if value then
					if ServiceCheckBoxYes:GetChecked() then
						ServiceCheckBoxYes:SetValue(0)
						return
					end
				end
			end

			CouponCheckBoxYes = vgui.Create( "DCheckBoxLabel", SideBarOpened)
			CouponCheckBoxYes:SetPos(20, 440)
			if data != nil then
				if data[2][1][5] == 1 then
					CouponCheckBoxYes:SetValue( 1 )
				else
					CouponCheckBoxYes:SetValue( 0 )
				end
			else
				CouponCheckBoxYes:SetValue( 0 )
			end
			CouponCheckBoxYes:SetText("Yes")
			CouponCheckBoxYes:SetFont("GBayLabelFont")
			CouponCheckBoxYes:SetTextColor(Color(137, 137, 137))
			CouponCheckBoxYes.OnChange = function(value)
				if value then
					if CouponCheckBoxNo:GetChecked() then
						CouponCheckBoxNo:SetValue(0)
						return
					end
				end
			end

			CouponCheckBoxNo = vgui.Create( "DCheckBoxLabel", SideBarOpened)
			CouponCheckBoxNo:SetPos(20, 470)
			if data != nil then
				if data[2][1][5] == 1 then
					CouponCheckBoxNo:SetValue( 0 )
				else
					CouponCheckBoxNo:SetValue( 1 )
				end
			else
				CouponCheckBoxNo:SetValue( 0 )
			end
			CouponCheckBoxNo:SetText("No")
			CouponCheckBoxNo:SetFont("GBayLabelFont")
			CouponCheckBoxNo:SetTextColor(Color(137, 137, 137))
			CouponCheckBoxNo.OnChange = function(value)
				if value then
					if CouponCheckBoxYes:GetChecked() then
						CouponCheckBoxYes:SetValue(0)
						return
					end
				end
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
				if AdsCheckBoxYes:GetChecked() or AdsCheckBoxNo:GetChecked() then
					if ServiceCheckBoxYes:GetChecked() or ServiceCheckBoxNo:GetChecked() then
						if CouponCheckBoxYes:GetChecked() or CouponCheckBoxNo:GetChecked() then
							if firstjoined then
								net.Start("GBayFinishSettingUpServer")
									net.WriteString(ServerNameTE:GetValue())
									net.WriteBool(AdsCheckBoxYes:GetChecked())
									net.WriteBool(ServiceCheckBoxYes:GetChecked())
									net.WriteBool(CouponCheckBoxYes:GetChecked())
								net.SendToServer()
								SideBarOpened:Close()
								GBaySideBarOpened(DFrame, "PleaseRefresh", false, {}, firstjoined)
							else
								print("Aye")
								net.Start("GBayUpdateSettings")
									net.WriteString(ServerNameTE:GetValue())
									net.WriteBool(AdsCheckBoxYes:GetChecked())
									net.WriteBool(ServiceCheckBoxYes:GetChecked())
									net.WriteBool(CouponCheckBoxYes:GetChecked())
								net.SendToServer()
								SideBarOpened:Close()
								GBaySideBarOpened(DFrame, "PleaseRefresh", false, data, false)
							end
						else
							GBayErrorMessage("Please check either yes or no ALL the sections that require it!")
						end
					else
						GBayErrorMessage("Please check either yes or no ALL the sections that require it!")
					end
				else
					GBayErrorMessage("Please check either yes or no ALL the sections that require it!")
				end
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
	elseif tab == "PlayerProfile" then
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
		usedentity = false
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
				end
				usedshipments = true
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
	elseif tab == "Purchase" then
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
	end
end
