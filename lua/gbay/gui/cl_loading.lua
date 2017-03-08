net.Receive("GBayOpenLoading",function()
  local frame_w, frame_h = 1000, 700
  local loadingtext = "Loading"
	local GBayLogo = Material("gbay/Logo2.png")

  local loadingperc = 0

  local DFrame = vgui.Create( "DFrame" )
  DFrame:SetPos(-frame_w, ScrH()/2 - frame_h/2)
	DFrame:SetSize( frame_w, frame_h )
	DFrame:SetDraggable( false )
	DFrame:MakePopup()
	DFrame:SetTitle( "" )
	DFrame:ShowCloseButton( false )
  DFrame.Paint = function(s, w, h)
    surface.SetDrawColor(247,247,247)
    surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( GBayLogo	)
		surface.DrawTexturedRect(w / 2 - 129/2,20,129,59)
    draw.SimpleText(loadingtext,"GBayTitleFont",w / 2,h / 2,Color( 0, 0, 0 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  DFrame:MoveTo( ScrW()/2 - frame_w/2, ScrH()/2 - frame_h/2, 1, 0, 1, function()
    timer.Create("GbayGUILoadingText",.5,0,function()
      if !IsValid(DFrame) then return end
      if loadingtext == "Loading" then loadingtext = "Loading." elseif loadingtext == "Loading." then loadingtext = "Loading.." elseif loadingtext == "Loading.." then loadingtext = "Loading..." elseif loadingtext == "Loading..." then loadingtext = "Loading" end
    end)
    net.Receive("GBayGUILoadingPercLoad",function()
      loadingperc = loadingperc + 142
    end)
    net.Receive("GBayGUILoadingPercLoad100",function()
      loadingperc = 1000
    end)
    DFrame.Paint = function(s, w, h)
			surface.SetDrawColor(247,247,247)
	    surface.DrawRect(0, 0, w, h)
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( GBayLogo	)
			surface.DrawTexturedRect(w / 2 - 129/2,20,129,59)

      draw.RoundedBox(0,0,h-5,loadingperc,5,Color(255,0,0))

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

	--    draw.SimpleText("Welcome to GBay","GBayTitleFont",w / 2,0,Color( 0, 0, 0 ),TEXT_ALIGN_CENTER)
	--    draw.SimpleText("Please wait while we load everything up!","GBayLabelFont",w / 2,30,Color( 0, 0, 0 ),TEXT_ALIGN_CENTER)
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
  end)

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

  net.Receive("GBayCloseLoading",function()
    if IsValid(DFrame) then DFrame:Close() end
  end)
end)
