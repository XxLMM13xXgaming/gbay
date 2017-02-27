function GBayAdsPageFull(DFrame, data)
  if IsValid(HomePanel) then HomePanel:Remove() end
	if IsValid(HomePanel2) then HomePanel2:Remove() end
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
		GBaySideBarOpened(DFrame, "CreateAds", false, data, false)
	end
	CreateItemPage.Paint = function(s, w, h)
	end
end
