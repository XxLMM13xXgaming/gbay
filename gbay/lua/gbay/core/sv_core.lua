print("Aye we loaded!")
include("gbay/mysql/sv_mysql.lua")
include("gbay/shipment/sv_shipment.lua")
include("gbay/service/sv_service.lua")
include("gbay/entity/sv_entity.lua")
AddCSLuaFile("gbay/mysql/cl_mysql.lua")
AddCSLuaFile("gbay/gui/cl_fonts.lua")
AddCSLuaFile("gbay/gui/cl_bases.lua")
AddCSLuaFile("gbay/gui/cl_loading.lua")
AddCSLuaFile("gbay/gui/cl_sidebar.lua")
AddCSLuaFile("gbay/gui/cl_orderpage.lua")
AddCSLuaFile("gbay/gui/cl_homepage.lua")
AddCSLuaFile("gbay/gui/cl_updates.lua")
AddCSLuaFile("gbay/shipment/cl_shipment.lua")
AddCSLuaFile("gbay/service/cl_service.lua")
AddCSLuaFile("gbay/entity/cl_entity.lua")
resource.AddSingleFile("materials/gbay/Logo.png")
resource.AddSingleFile("materials/gbay/Settings_Logo.png")
resource.AddSingleFile("materials/gbay/Create_Logo.png")
resource.AddSingleFile("materials/gbay/Check_Out.png")
resource.AddSingleFile("materials/gbay/Settings.png")
resource.AddSingleFile("materials/gbay/Positive.png")
resource.AddSingleFile("materials/gbay/Negative.png")
resource.AddSingleFile("materials/gbay/Neutral.png")
resource.AddSingleFile("materials/gbay/Star128.png")
resource.AddSingleFile("materials/gbay/Services_Small.png")
resource.AddSingleFile("materials/gbay/Services_Large.png")
util.AddNetworkString("GBaySetMySQL")
util.AddNetworkString("GBayCloseSetMySQL")
util.AddNetworkString("GBayNotify")
util.AddNetworkString("GBayOpenLoading")
util.AddNetworkString("GBayCloseLoading")
util.AddNetworkString("GBayOpenCreateServer")
util.AddNetworkString("GBayUpdateSettings")
util.AddNetworkString("GBayOpenLoadingSettingUpServer")
util.AddNetworkString("GBaySubmitShipment")
util.AddNetworkString("GBayEditShipment")
util.AddNetworkString("GBayRemoveShipment")
util.AddNetworkString("GBaySubmitEntity")
util.AddNetworkString("GBayEditEntity")
util.AddNetworkString("GBayRemoveEntity")
util.AddNetworkString("GBaySubmitService")
util.AddNetworkString("GBayEditService")
util.AddNetworkString("GBayRemoveService")
util.AddNetworkString("GBayDoneLoading")
util.AddNetworkString("GBayDoneLoading2")
util.AddNetworkString("GBayOpenMenu")
util.AddNetworkString("GBayPurchaseItem")
util.AddNetworkString("GBayTransErrorReport")
util.AddNetworkString("GBayRemoveItem")
util.AddNetworkString("GBayBanPlayer")
util.AddNetworkString("GBaySetPlayerRank")
util.AddNetworkString("GBaySetprep")
util.AddNetworkString("GBaySetnrep")
util.AddNetworkString("GBaySetmrep")
GBayConfig = {}

local OwnerSID = nil

local plymeta = FindMetaTable("Player")

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

function GBayIsBanned(data)
  if data[1].affected > 1 then return true else return false end
end

function plymeta:GBayNotify(type, message)
  net.Start("GBayNotify")
    net.WriteString(type)
    net.WriteString(message)
  net.Send(self)
end

function GBayRefreashSettings()
  GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
    local data = result[1].data[1]
    GBayConfig.ServerName = data.servername
    GBayConfig.AdsToggle = data.ads
    GBayConfig.ServiceToggle = data.aservicesds
    GBayConfig.CouponToggle = data.coupons
    GBayConfig.PriceToPayToSell = data.feepost
    GBayConfig.MaxPrice = data.maxprice
    GBayConfig.TaxToMultiplyBy = data.taxpercent / 100
  end)
end

hook.Add("PlayerInitialSpawn", "GBayPlayerInitialSpawn", function(ply)
  if GBayMySQL == nil then
    net.Start("GBaySetMySQL")
    net.Send(ply)
  else
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
        GBayMySQL:Query("SELECT * FROM bans WHERE bid="..ply:SteamID64(), function(bansresult)
          if bansresult[1].status == false then print('GBay MySQL Error: '..bansresult[1].error) end
          if bansresult[1].affected > 0 then
            local bandata = bansresult[1].data[1]
            if os.time() > bandata.time then
              GBayMySQL:Query("DELETE FROM bans WHERE bid="..ply:SteamID64(), function(unbansresult)
                if unbansresult[1].status == false then print('GBay MySQL Error: '..unbansresult[1].error) end
                timer.Simple(20, function()
                  ply:GBayNotify("generic", "You have been unbanned!")
                end)
              end)
            end
          end
        end)
      end
    end)
  end
end)

hook.Add("PlayerSay", "GBayPlayerSay", function(ply, text)
  ply:ChatPrint("MOM IT WORKS!")
  local text = string.lower(text)
  local playerinfotable = {}
  local serverinfotable = {}
  local shipmentsinfotable = {}
  local serviceinfotable = {}
  local entityinfotable = {}
  if text:lower():match('[!/:.]gbay') then
    net.Start("GBayOpenLoading")
    net.Send(ply)
    GBayMySQL:Query("SELECT * FROM bans WHERE bid="..ply:SteamID64(), function(bansresult)
      if bansresult[1].status == false then print('GBay MySQL Error: '..bansresult[1].error) end
      if bansresult[1].affected > 0 then
        ply:GBayNotify("error", "You are currently banned from GBay!")
        net.Start("GBayCloseLoading")
        net.Send(ply)
      else
        GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
          if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
          if result[1].affected == 0 then
            OwnerSID = ply:SteamID64()
            GBayMySQL:Query("SELECT * FROM players WHERE sid = "..ply:SteamID64(), function(checkifexists)
              if checkifexists[1].status == false then print('GBay MySQL Error: '..checkifexists[1].error) end
              if checkifexists[1].affected == 0 then
                GBayMySQL:Query("INSERT INTO players (sid,	rank,	positiverep, neutralrep, negativerep) VALUES ('"..ply:SteamID64().."', 'Superadmin', '0', '0', '0')", function(result2)
                  if result2[1].status == false then print('GBay MySQL Error: '..result2[1].error) end
                  GBayMySQL:Query("INSERT INTO serverinfo (servername) VALUES ('Server name')", function(insertingresult)
                    if insertingresult[1].status == false then print('GBay MySQL Error: '..insertingresult[1].error) end
                    PrintTable(insertingresult)
                    timer.Simple(2,function()
                      net.Start("GBayOpenCreateServer")
                      net.Send(ply)
                      net.Start("GBayCloseLoading")
                      net.Send(ply)
                    end)
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
                  table.insert(serverinfotable,{v.id, v.servername, v.ads, v.services, v.coupons, v.feepost, v.maxprice, v.taxpercent, v.npcpos, v.npcang, v.npcmodel, v.ranks})
                end
                GBayMySQL:Query("SELECT * FROM shipments", function(shipmentsinfo)
                  if shipmentsinfo[1].status == false then print('GBay MySQL Error: '..shipmentsinfo[1].error) end
                  for k, v in pairs(shipmentsinfo[1].data) do
                    table.insert(shipmentsinfotable,{	v.id, v.sidmerchant, v.name, v.description, v.wep, v.price, v.amount})
                  end
                  GBayMySQL:Query("SELECT * FROM service", function(serviceinfo)
                    if serviceinfo[1].status == false then print('GBay MySQL Error: '..serviceinfo[1].error) end
                    for k, v in pairs(serviceinfo[1].data) do
                      table.insert(serviceinfotable,{v.id, v.sidmerchant, v.name, v.description, v.price, v.buyers})
                    end
                    GBayMySQL:Query("SELECT * FROM entities", function(entityinfo)
                      if entityinfo[1].status == false then print('GBay MySQL Error: '..entityinfo[1].error) end
                      for k, v in pairs(entityinfo[1].data) do
                        table.insert(entityinfotable,{v.id, v.sidmerchant, v.name, v.description, v.ent, v.price})
                      end
                    end)
                    timer.Simple(2,function()
                      local JammedTable = {}
                      table.insert(JammedTable,1,playerinfotable)
                      table.insert(JammedTable,2,serverinfotable)
                      table.insert(JammedTable,3,shipmentsinfotable)
                      table.insert(JammedTable,4,serviceinfotable)
                      table.insert(JammedTable,5,entityinfotable)
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
      end
    end)
    return ''
  end
end)

net.Receive("GBayUpdateSettings",function(len, ply)
  local customrankstable = {{"User", false, false, false, false, false, false, false, false}, {"Superadmin", true, true, true, true, true, true, true, true}}
  local settings = GBayEscapeString(net.ReadTable())
  local servername = settings[1]
  local ads = settings[2]
  local service = settings[3]
  local coupon = settings[4]
  local postingfee = settings[5]
  local maxpricetosell = settings[6]
  local taxtocharge = settings[7]
  if ads then adst = 1 else adst = 0 end
  if service then servicet = 1 else servicet = 0 end
  if coupon then coupont = 1 else coupont = 0 end
  GBayMySQL:Query("SELECT * FROM players", function(playerinfo)
    if playerinfo[1].status == false then print('GBay MySQL Error: '..playerinfo[1].error) end
    if playerinfo[1].data[1].rank == "Superadmin" or playerinfo[1].data[1].rank == "Admin" then
      GBayMySQL:Query("UPDATE serverinfo SET servername='"..servername.."', ads='"..adst.."', services='"..servicet.."', coupons='"..coupont.."', feepost='"..postingfee.."', maxprice='"..maxpricetosell.."', taxpercent='"..taxtocharge.."'", function(result)
        if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
        GBayRefreashSettings()
      end)
    end
  end)
end)

net.Receive("GBayPurchaseItem",function(len, ply)
  local type = GBayEscapeString(net.ReadString())
  local quantity = GBayEscapeString(net.ReadFloat())
  local item = GBayEscapeString(net.ReadTable())
  if type == "Shipment" then
    GBayMySQL:Query("SELECT * FROM shipments WHERE id="..item[1], function(shipmentinfo)
      if shipmentinfo[1].status == false then print('GBay MySQL Error: '..shipmentinfo[1].error) end
      if shipmentinfo[1].affected > 0 then
        local data = shipmentinfo[1].data[1]
        local totalprice = 0
    		local costofone = data.price / data.amount
        if data.sidmerchant != ply:SteamID64() then
          if quantity <= data.amount then
            totalprice = costofone * quantity
            totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy
            if ply:getDarkRPVar("money") >= totalprice then
              if quantity == data.amount then
                GBayMySQL:Query("DELETE FROM shipments WHERE id="..data.id, function(removeshipment)
                  if removeshipment[1].status == false then print('GBay MySQL Error: '..removeshipment[1].error) end
                  GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer,	type,	weapon,	quantity) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Shipment', '"..data.wep.."', '"..tonumber(quantity).."')", function(addtoorder)
                    if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                    ply:addMoney(-totalprice)
                    net.Start("GBayTransErrorReport")
                      net.WriteString('Success')
                    net.Send(ply)
                  end)
                end)
              else
                GBayMySQL:Query("UPDATE shipments SET amount='"..data.amount - quantity.."' WHERE id="..data.id, function(removeshipment)
                  if removeshipment[1].status == false then print('GBay MySQL Error: '..removeshipment[1].error) end
                  GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer,	type,	weapon,	quantity) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Shipment', '"..data.wep.."', '"..tonumber(quantity).."')", function(addtoorder)
                    if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                    ply:addMoney(-totalprice)
                    net.Start("GBayTransErrorReport")
                      net.WriteString('Success')
                    net.Send(ply)
                  end)
                end)
              end
            else
              net.Start("GBayTransErrorReport")
                net.WriteString('Money')
              net.Send(ply)
            end
          else
            net.Start("GBayTransErrorReport")
              net.WriteString('Info')
            net.Send(ply)
          end
        else
          net.Start("GBayTransErrorReport")
            net.WriteString('SamePlayer')
          net.Send(ply)
        end
      else
        net.Start("GBayTransErrorReport")
          net.WriteString('Info')
        net.Send(ply)
      end
    end)
  elseif type == "Service" then
    GBayMySQL:Query("SELECT * FROM service WHERE id="..item[1], function(serviceinfo)
      if serviceinfo[1].status == false then print('GBay MySQL Error: '..serviceinfo[1].error) end
      if serviceinfo[1].affected > 0 then
        local data = serviceinfo[1].data[1]
        local totalprice = 0
    		local costofone = data.price
        local prevbuyers = util.JSONToTable(data.buyers)
        if data.sidmerchant != ply:SteamID64() then
          if !table.HasValue(prevbuyers,ply:SteamID64()) then
            totalprice = costofone * quantity
            totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy
            if ply:getDarkRPVar("money") >= totalprice then
              table.insert(prevbuyers,#prevbuyers + 1,ply:SteamID64())
              GBayMySQL:Query("UPDATE service SET buyers='"..util.TableToJSON(prevbuyers).."'", function(addtoorder)
                if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                ply:addMoney(-totalprice)
                net.Start("GBayTransErrorReport")
                  net.WriteString('Success')
                net.Send(ply)
              end)
            else
              net.Start("GBayTransErrorReport")
                net.WriteString('Money')
              net.Send(ply)
            end
          else
            net.Start("GBayTransErrorReport")
              net.WriteString('Bought')
            net.Send(ply)
          end
        else
          net.Start("GBayTransErrorReport")
            net.WriteString('SamePlayer')
          net.Send(ply)
        end
      else
        net.Start("GBayTransErrorReport")
          net.WriteString('Info')
        net.Send(ply)
      end
    end)
  elseif type == "Entity" then
    GBayMySQL:Query("SELECT * FROM entities WHERE id="..item[1], function(entityinfo)
      if entityinfo[1].status == false then print('GBay MySQL Error: '..entityinfo[1].error) end
      if entityinfo[1].affected > 0 then
        local data = entityinfo[1].data[1]
        local totalprice = 0
        local costofone = data.price
        if data.sidmerchant != ply:SteamID64() then
          totalprice = costofone * quantity
          totalprice = totalprice + totalprice * GBayConfig.TaxToMultiplyBy
          if ply:getDarkRPVar("money") >= totalprice then
            GBayMySQL:Query("DELETE FROM entities WHERE id="..data.id, function(removeentity)
              if removeentity[1].status == false then print('GBay MySQL Error: '..removeentity[1].error) end
              GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer, type, weapon, quantity) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Entity', '"..data.ent.."', '"..tonumber(quantity).."')", function(addtoorder)
                if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                ply:addMoney(-totalprice)
                net.Start("GBayTransErrorReport")
                  net.WriteString('Success')
                net.Send(ply)
              end)
            end)
          else
            net.Start("GBayTransErrorReport")
              net.WriteString('Money')
            net.Send(ply)
          end
        else
          net.Start("GBayTransErrorReport")
            net.WriteString('SamePlayer')
          net.Send(ply)
        end
      else
        net.Start("GBayTransErrorReport")
          net.WriteString('Info')
        net.Send(ply)
      end
    end)
  else
    net.Start("GBayTransErrorReport")
      net.WriteString('Info')
    net.Send(ply)
  end
end)

net.Receive("GBayBanPlayer",function(len, ply)
  days = GBayEscapeString(net.ReadFloat())
  victim = GBayEscapeString(net.ReadFloat())

  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("SELECT * FROM bans WHERE bid="..victimplayersresult[1].data[1].sid, function(bansresult)
          if bansresult[1].status == false then print('GBay MySQL Error: '..bansresult[1].error) end
          if bansresult[1].affected > 1 then
            ply:GBayNotify("error", "This player is already banned!")
          else
            GBayMySQL:Query("INSERT INTO bans (bid, aid, time) VALUES ('"..victimplayersresult[1].data[1].sid.."', '"..ply:SteamID64().."', '"..os.time() + 60*60*24*days.."')", function(banresult)
              if banresult[1].status == false then print('GBay MySQL Error: '..banresult[1].error) end
              if IsValid(player.GetBySteamID64(victimplayersresult[1].data[1].sid)) then
                player.GetBySteamID64(victimplayersresult[1].data[1].sid):GBayNotify("error", "You have been banned by "..player.GetBySteamID64(ply:SteamID64()):Nick().." for "..days.." day(s)!")
              end
            end)
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBaySetPlayerRank",function(len, ply)
  rank = GBayEscapeString(net.ReadString())
  victim = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsSuperadmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("UPDATE players SET rank='"..rank.."' WHERE id="..victim, function(rankchangedresult)
          if rankchangedresult[1].status == false then print('GBay MySQL Error: '..rankchangedresult[1].error) end
          if IsValid(player.GetBySteamID64(victimplayersresult[1].data[1].sid)) then
            player.GetBySteamID64(victimplayersresult[1].data[1].sid):GBayNotify("generic", "Your rank has been set by "..player.GetBySteamID64(ply:SteamID64()):Nick().." to "..rank.."!")
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBaySetprep",function(len, ply)
  rep = GBayEscapeString(net.ReadFloat())
  victim = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("UPDATE players SET positiverep='"..rep.."' WHERE id="..victim, function(repchangedresult)
          if repchangedresult[1].status == false then print('GBay MySQL Error: '..repchangedresult[1].error) end
          if IsValid(player.GetBySteamID64(victimplayersresult[1].data[1].sid)) then
            player.GetBySteamID64(victimplayersresult[1].data[1].sid):GBayNotify("generic", "Your positive rep has been set by "..player.GetBySteamID64(ply:SteamID64()):Nick().." to "..rep.."!")
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBaySetnrep",function(len, ply)
  rep = GBayEscapeString(net.ReadFloat())
  victim = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("UPDATE players SET neutralrep='"..rep.."' WHERE id="..victim, function(repchangedresult)
          if repchangedresult[1].status == false then print('GBay MySQL Error: '..repchangedresult[1].error) end
          if IsValid(player.GetBySteamID64(victimplayersresult[1].data[1].sid)) then
            player.GetBySteamID64(victimplayersresult[1].data[1].sid):GBayNotify("generic", "Your neutral rep has been set by "..player.GetBySteamID64(ply:SteamID64()):Nick().." to "..rep.."!")
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBaySetmrep",function(len, ply)
  rep = GBayEscapeString(net.ReadFloat())
  victim = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("UPDATE players SET negativerep='"..rep.."' WHERE id="..victim, function(repchangedresult)
          if repchangedresult[1].status == false then print('GBay MySQL Error: '..repchangedresult[1].error) end
          if IsValid(player.GetBySteamID64(victimplayersresult[1].data[1].sid)) then
            player.GetBySteamID64(victimplayersresult[1].data[1].sid):GBayNotify("generic", "Your negative rep has been set by "..player.GetBySteamID64(ply:SteamID64()):Nick().." to "..rep.."!")
          end
        end)
      end)
    end
  end)
end)

concommand.Add("gbaytest",function(ply)
  GBayRefreashSettings()
end)
