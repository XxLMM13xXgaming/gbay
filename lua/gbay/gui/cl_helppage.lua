function GBayHelpPageFull(DFrame, data)
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
        draw.SimpleText("Need some help?","GBayLabelFontBold",w / 2,30,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Here you can watch some videos related to GBay help!","GBayLabelFont",w / 2,50,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.RoundedBox(0,0,70,w,2,Color(221,221,221))
        if gbaywefailed then
            draw.SimpleText("Looks like something went wrong!","GBayLabelFont",w / 2,h / 2 - 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Heres what we know... " .. gbaywefailederror,"GBayLabelFont",w / 2,h / 2 + 10,Color( 137, 137, 137, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    ScrollList = vgui.Create( "DPanelList", HomePanel )
    ScrollList:SetPos( 0, 80 )
    ScrollList:SetSize( HomePanel:GetWide(), HomePanel:GetTall() - 100 )
    ScrollList:EnableHorizontal(true)
    ScrollList:SetSpacing( 20 )
    ScrollList:EnableVerticalScrollbar( true )

    http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/ff3b312717a5aa04ff31a60181e78abd/raw/GBay%2520Videos%2520Videos",function(body)
        RunString(body)
        http.Fetch("https://gist.githubusercontent.com/XxLMM13xXgaming/5c4ce8c08f9afdeaba8473c67570a8ae/raw/GBay%2520Videos",function(body2)
            RunString(body2)
        end,function(error)
            gbaywefailed = true
            gbaywefailederror = error
        end)
        end,function(error)
        print("error: " .. error)
    end)
end

function GBayHelpPageSmall(DFrame, data)

end
