net.Receive("GBaySetMySQL",function()
  local DFrame = vgui.Create( "DFrame" )
  DFrame:SetSize( 300, 185 )
  DFrame:SetTitle( "GBay MySQL info!" )
  DFrame:Center()
  DFrame:SetDraggable( true )
  DFrame:ShowCloseButton(true)
  DFrame:MakePopup()

  local HostEntry = vgui.Create( "DTextEntry", DFrame )
  HostEntry:SetPos( 10, 30 )
  HostEntry:SetSize( DFrame:GetWide() - 20, 20 )
  HostEntry:SetText( "MySQL Host" )
  HostEntry.OnEnter = function( self )
  end

  local UsernameEntry = vgui.Create( "DTextEntry", DFrame )
  UsernameEntry:SetPos( 10, 55 )
  UsernameEntry:SetSize( DFrame:GetWide() - 20, 20 )
  UsernameEntry:SetText( "MySQL Username" )
  UsernameEntry.OnEnter = function( self )
  end

  local PasswordEntry = vgui.Create( "DTextEntry", DFrame )
  PasswordEntry:SetPos( 10, 80 )
  PasswordEntry:SetSize( DFrame:GetWide() - 20, 20 )
  PasswordEntry:SetText( "MySQL Password" )

  local DatabaseEntry = vgui.Create( "DTextEntry", DFrame )
  DatabaseEntry:SetPos( 10, 105 )
  DatabaseEntry:SetSize( DFrame:GetWide() - 20, 20 )
  DatabaseEntry:SetText( "MySQL Database" )
  DatabaseEntry.OnEnter = function( self )
  end

  local PortEntry = vgui.Create( "DTextEntry", DFrame )
  PortEntry:SetPos( 10, 130 )
  PortEntry:SetSize( DFrame:GetWide() - 20, 20 )
  PortEntry:SetNumeric( true )
  PortEntry:SetText( "MySQL Port" )
  PortEntry.OnEnter = function( self )
  end

  local SubmitBTN = vgui.Create("DButton", DFrame)
  SubmitBTN:SetPos(10, 155)
  SubmitBTN:SetSize( DFrame:GetWide() - 20, 20 )
  SubmitBTN:SetText("Submit MySQL Info")
  SubmitBTN.DoClick = function()
    net.Start("GBaySetMySQL")
      net.WriteString(HostEntry:GetValue())
      net.WriteString(UsernameEntry:GetValue())
      net.WriteString(PasswordEntry:GetValue())
      net.WriteString(DatabaseEntry:GetValue())
      net.WriteFloat(PortEntry:GetValue())
    net.SendToServer()
  end

  net.Receive("GBayCloseSetMySQL",function()
    local worked = net.ReadBool()
    local error = net.ReadString()
    DFrame:Close()
    if worked then
      chat.AddText(Color(0,255,0), "MySQL Connected!")
    else
      chat.AddText(Color(255,0,0), "MySQL Error! Error: " .. error)
      chat.AddText(Color(255,0,0), "Menu will re-open in 5 sec...")
    end
  end)
end)
