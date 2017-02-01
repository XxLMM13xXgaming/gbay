resource.AddSingleFile("materials/gbay/Logo.png")
resource.AddSingleFile("materials/gbay/Settings_Logo.png")
resource.AddSingleFile("materials/gbay/Create_Logo.png")
resource.AddSingleFile("materials/gbay/Check_Out.png")
resource.AddSingleFile("materials/gbay/Settings.png")
resource.AddSingleFile("materials/gbay/Positive.png")
resource.AddSingleFile("materials/gbay/Negative.png")
resource.AddSingleFile("materials/gbay/Neutral.png")
resource.AddSingleFile("materials/gbay/Star128.png")
util.AddNetworkString("GBayOpenLoading")
util.AddNetworkString("GBayCloseLoading")
util.AddNetworkString("GBayOpenCreateServer")
util.AddNetworkString("GBayFinishSettingUpServer")
util.AddNetworkString("GBayUpdateSettings")
util.AddNetworkString("GBayOpenLoadingSettingUpServer")
util.AddNetworkString("GBaySubmitShipment")
util.AddNetworkString("GBayEditShipment")
util.AddNetworkString("GBayDoneLoading")
util.AddNetworkString("GBayDoneLoading2")
util.AddNetworkString("GBayOpenMenu")
util.AddNetworkString("GBayPurchaseItem")

-- If you change anything below you risk getting errors so please do not
local StatsWebsite = "http://xxlmm13xxgaming.com/addons/data/serveradd.php" -- my stats website (DO NOT TOUCH)
local UpdatesWebsite = "" -- place to get recent updates (DO NOT TOUCH)
local GBayServerLogged = false
local OwnerSID = nil

function GBayEscapeString(string)
  if isstring(string) then
    return GBayMySQL:Escape(string)
  else
    return string
  end
end

function GBayIsSuperadmin(data)
  if data.rank == "Superadmin" then
    return true
  end
  return false
end

function GBayIsAdmin(data)
  if data.rank == "Admin" or data.rank == "Superadmin" then
    return true
  end
  return false
end

hook.Add("PlayerInitialSpawn", "GBayPlayerInitialSpawn", function(ply)
  if !GBayServerLogged then
    MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Logging Server...\n")
    http.Post(StatsWebsite,{sid = "gbay", sip = game.GetIPAddress(), sdate=tostring(os.time()), soid = "76561198141863800"},function(body)
      print(body)
      GBayServerLogged = true
    end,function(error)
      print(error)
    end)
  end
  GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
    if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
    if result[1].affected > 0 then
      GBayMySQL:Query("SELECT * FROM players WHERE sid = "..ply:SteamID64(), function(checkifexists)
        if checkifexists[1].status == false then print('GBay MySQL Error: '..checkifexists[1].error) end
        if checkifexists[1].affected == 0 then
          GBayMySQL:Query("INSERT INTO players (sid,	rank,	rep) VALUES ('"..ply:SteamID64().."', 'User', '0', '0', '0')", function(result2)
            MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] "..ply:Nick().."'s gbay account has been created!\n")
          end)
        end
      end)
    end
  end)
end)

hook.Add("PlayerSay", "GBayPlayerSay", function(ply, text)
  local text = string.lower(text)
  local playerinfotable = {}
  local serverinfotable = {}
  local shipmentsinfotable = {}
  local serviceinfotable = {}
  if text:lower():match('[!/:.]gbay') then
    net.Start("GBayOpenLoading")
    net.Send(ply)
    GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
      if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
      if result[1].affected == 0 then
        OwnerSID = ply:SteamID64()
        GBayMySQL:Query("SELECT * FROM players WHERE sid = "..ply:SteamID64(), function(checkifexists)
          if checkifexists[1].status == false then print('GBay MySQL Error: '..checkifexists[1].error) end
          if checkifexists[1].affected == 0 then
            GBayMySQL:Query("INSERT INTO players (sid,	rank,	positiverep, neutralrep, negativerep) VALUES ('"..ply:SteamID64().."', 'Superadmin', '0', '0', '0')", function(result2)
              if result2[1].status == false then print('GBay MySQL Error: '..result2[1].error) end
              timer.Simple(2,function()
                net.Start("GBayOpenCreateServer")
                net.Send(ply)
                net.Start("GBayCloseLoading")
                net.Send(ply)
              end)
            end)
          else
            timer.Simple(2,function()
              net.Start("GBayOpenCreateServer")
              net.Send(ply)
              net.Start("GBayCloseLoading")
              net.Send(ply)
            end)
          end
        end)
      else
        GBayMySQL:Query("SELECT * FROM players", function(playerinfo)
          if playerinfo[1].status == false then print('GBay MySQL Error: '..playerinfo[1].error) end
          for k, v in pairs(playerinfo[1].data) do
            table.insert(playerinfotable,{v.id, v.sid, v.rank, v.positiverep, v.neutralrep, v.negativerep})
          end
          GBayMySQL:Query("SELECT * FROM serverinfo", function(serverinfo)
            if serverinfo[1].status == false then print('GBay MySQL Error: '..serverinfo[1].error) end
            for k, v in pairs(serverinfo[1].data) do
              table.insert(serverinfotable,{v.id, v.servername, v.ads, v.services, v.coupons, v.ranks})
            end
            GBayMySQL:Query("SELECT * FROM shipments", function(shipmentsinfo)
              if shipmentsinfo[1].status == false then print('GBay MySQL Error: '..shipmentsinfo[1].error) end
              for k, v in pairs(shipmentsinfo[1].data) do
                table.insert(shipmentsinfotable,{	v.id, v.sidmerchant, v.name, v.description, v.wep, v.price, v.amount})
              end
              GBayMySQL:Query("SELECT * FROM service", function(serviceinfo)
                if serviceinfo[1].status == false then print('GBay MySQL Error: '..serviceinfo[1].error) end
                for k, v in pairs(serviceinfo[1].data) do
                  table.insert(serviceinfotable,{v.id, v.sidmerchant, v.name, v.description, v.price, v.coupons, v.advertisment, v.buyers})
                end
                timer.Simple(2,function()
                  local JammedTable = {}
                  table.insert(JammedTable,1,playerinfotable)
                  table.insert(JammedTable,2,serverinfotable)
                  table.insert(JammedTable,3,shipmentsinfotable)
                  table.insert(JammedTable,4,serviceinfotable)
                  net.Start("GBayOpenMenu")
                  net.WriteTable(JammedTable)
                  net.Send(ply)
                  net.Start("GBayCloseLoading")
                  net.Send(ply)
                end)
              end)
            end)
          end)
        end)
      end
    end)
    return ''
  end
end)

net.Receive("GBayFinishSettingUpServer",function(len, ply)
  local customrankstable = {{"User", false, false, false, false, false, false, false, false}, {"Superadmin", true, true, true, true, true, true, true, true}}
  local servername = net.ReadString()
  local ads = net.ReadBool()
  local service = net.ReadBool()
  local coupon = net.ReadBool()
  if ads then adst = 1 else adst = 0 end
  if service then servicet = 1 else servicet = 0 end
  if coupon then coupont = 1 else coupont = 0 end
  if OwnerSID == ply:SteamID64() then
    GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
      if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
      if result[1].affected == 0 then
        GBayMySQL:Query("INSERT INTO serverinfo (	servername,	ads,	services,	coupons,ranks) VALUES ('"..servername.."', '"..adst.."', '"..servicet.."', '"..coupont.."', '"..util.TableToJSON(customrankstable).."')", function(sentinfo)
          if sentinfo[1].status == false then print('GBay MySQL Error: '..sentinfo[1].error) end
        end)
      end
    end)
  end
end)

net.Receive("GBayUpdateSettings",function(len, ply)
  local customrankstable = {{"User", false, false, false, false, false, false, false, false}, {"Superadmin", true, true, true, true, true, true, true, true}}
  local servername = net.ReadString()
  local ads = net.ReadBool()
  local service = net.ReadBool()
  local coupon = net.ReadBool()
  if ads then adst = 1 else adst = 0 end
  if service then servicet = 1 else servicet = 0 end
  if coupon then coupont = 1 else coupont = 0 end
  GBayMySQL:Query("SELECT * FROM players", function(playerinfo)
    if playerinfo[1].status == false then print('GBay MySQL Error: '..playerinfo[1].error) end
    if playerinfo[1].data[1].rank == "Superadmin" or playerinfo[1].data[1].rank == "Admin" then
      GBayMySQL:Query("UPDATE serverinfo SET servername='"..servername.."', ads='"..adst.."', services='"..servicet.."', coupons='"..coupont.."'", function(result)
        if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
      end)
    end
  end)
end)

net.Receive("GBayPurchaseItem",function(len, ply)
  local type = net.ReadString()
  local quantity = net.ReadFloat()
  local item = net.ReadTable()
  

end)

concommand.Add("gbaytest",function(ply)
  PrintTable(CustomShipments[ply:GetEyeTrace().Entity:Getcontents()])
end)
