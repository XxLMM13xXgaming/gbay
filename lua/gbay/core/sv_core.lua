include("gbay/mysql/sv_mysql.lua")
include("gbay/ads/sv_ads.lua")
include("gbay/shipment/sv_shipment.lua")
include("gbay/service/sv_service.lua")
include("gbay/entity/sv_entity.lua")
AddCSLuaFile("gbay/mysql/cl_mysql.lua")
AddCSLuaFile("gbay/gui/cl_adminpanel.lua")
AddCSLuaFile("gbay/gui/cl_fonts.lua")
AddCSLuaFile("gbay/gui/cl_bases.lua")
AddCSLuaFile("gbay/gui/cl_loading.lua")
AddCSLuaFile("gbay/gui/cl_sidebar.lua")
AddCSLuaFile("gbay/gui/cl_orderpage.lua")
AddCSLuaFile("gbay/gui/cl_homepage.lua")
AddCSLuaFile("gbay/gui/cl_updates.lua")
AddCSLuaFile("gbay/gui/cl_helppage.lua")
AddCSLuaFile("gbay/shipment/cl_shipment.lua")
AddCSLuaFile("gbay/ads/cl_ads.lua")
AddCSLuaFile("gbay/service/cl_service.lua")
AddCSLuaFile("gbay/entity/cl_entity.lua")
util.AddNetworkString("GBayOpenAdminPanel")
util.AddNetworkString("GBaySetMySQL")
util.AddNetworkString("GBayCloseSetMySQL")
util.AddNetworkString("GBaySetMySQLFromConfig")
util.AddNetworkString("GBayNotify")
util.AddNetworkString("GBayOpenLoading")
util.AddNetworkString("GBayCloseLoading")
util.AddNetworkString("GBayGUILoadingPercLoad")
util.AddNetworkString("GBayGUILoadingPercLoad100")
util.AddNetworkString("GBayOpenCreateServer")
util.AddNetworkString("GBayUpdateSettings")
util.AddNetworkString("GBayOpenLoadingSettingUpServer")
util.AddNetworkString("GBaySubmitShipment")
util.AddNetworkString("GBayEditShipment")
util.AddNetworkString("GBayRemoveShipment")
util.AddNetworkString("GBaySubmitEntity")
util.AddNetworkString("GBayEditEntity")
util.AddNetworkString("GBayRemoveEntity")
util.AddNetworkString("GBayRemoveEnt")
util.AddNetworkString("GBaySubmitService")
util.AddNetworkString("GBayEditService")
util.AddNetworkString("GBayRemoveService")
util.AddNetworkString("GBayMarkServiceAsDone")
util.AddNetworkString("GBayDoneLoading")
util.AddNetworkString("GBayDoneLoading2")
util.AddNetworkString("GBayOpenMenu")
util.AddNetworkString("GBayPurchaseItem")
util.AddNetworkString("GBayTransErrorReport")
util.AddNetworkString("GBayRemoveItem")
util.AddNetworkString("GBayBanPlayer")
util.AddNetworkString("GBayUnBanPlayer")
util.AddNetworkString("GBaySetPlayerRank")
util.AddNetworkString("GBaySetprep")
util.AddNetworkString("GBaySetnrep")
util.AddNetworkString("GBaySetmrep")
util.AddNetworkString("GBayPlayerRatingWorker")
util.AddNetworkString("GBayPurchaseAd")
util.AddNetworkString("GBaySendConfig")
util.AddNetworkString("GBayAddAllAdmins")
GBayConfig = {}

local OwnerSID = nil

local plymeta = FindMetaTable("Player")

function GBayEscapeString(string)
  if isstring(string) then
    return GBayMySQL:Escape(string)
  elseif istable(string) then
    local returntable = {}
    for k, v in pairs(string) do
      if isstring(v) then
        table.insert(returntable,k,GBayMySQL:Escape(v))
      else
        table.insert(returntable,k,v)
      end
    end
    return returntable
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
  if data[1].affected > 1 then
    return true
  end
  return false
end

function plymeta:GBayNotify(type, message)
  net.Start("GBayNotify")
    net.WriteString(type)
    net.WriteString(message)
  net.Send(self)
end

function GBayRefreshSettings()
  GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
    if result[1].affected > 0 then
      local data = result[1].data[1]
      GBayConfig.ServerName = data.servername
      GBayConfig.AdsToggle = data.ads
      GBayConfig.ServiceToggle = data.services
      GBayConfig.CouponToggle = data.coupons
      GBayConfig.PriceToPayToSell = data.feepost
      GBayConfig.MaxPrice = data.maxprice
      GBayConfig.TaxToMultiplyBy = data.taxpercent / 100
      GBayConfig.TimeToNotify = data.ttnoo
      npcpost = string.Explode(",",data.npcpos)
      npcangt = string.Explode(",",data.npcang)
      GBayConfig.NPCPos = Vector(npcpost[1], npcpost[2], npcpost[3])
      GBayConfig.NPCAng = Angle(npcangt[1], npcangt[2], npcangt[3])
      GBayConfig.NPCModel = data.npcmodel
      net.Start("GBaySendConfig")
        net.WriteString(data.servername)
        net.WriteFloat(data.ads)
        net.WriteFloat(data.services)
        net.WriteFloat(data.coupons)
        net.WriteFloat(data.feepost)
        net.WriteFloat(data.maxprice)
        net.WriteFloat(data.taxpercent / 100)
      net.Broadcast()
      local entfound = false
      for k, v in pairs(ents.FindByClass("gbay_mail")) do
        entfound = true
      end
      if entfound == false then
        SpawnGBayMailNPC()
      end
    else
      MsgC(Color(255,0,0), "GBay settings not saved! Please configure to get NO errors!\n")
    end
  end)
end

function plymeta:GBayRefreshSettingsClient()
  net.Start("GBaySendConfig")
    net.WriteString(GBayConfig.ServerName)
    net.WriteFloat(GBayConfig.AdsToggle)
    net.WriteFloat(GBayConfig.ServiceToggle)
    net.WriteFloat(GBayConfig.CouponToggle)
    net.WriteFloat(GBayConfig.PriceToPayToSell)
    net.WriteFloat(GBayConfig.MaxPrice)
    net.WriteFloat(GBayConfig.TaxToMultiplyBy)
  net.Send(self)
end

hook.Add("PlayerInitialSpawn", "GBayPlayerInitialSpawn", function(ply)
  if GBayMySQL == nil then
    net.Start("GBaySetMySQL")
    net.Send(ply)
  else
    ply:GBayRefreshSettingsClient()
    GBayMySQL:Query("SELECT * FROM serverinfo", function(result)
      if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
      if result[1].affected > 0 then
        GBayMySQL:Query("SELECT * FROM players WHERE sid = "..ply:SteamID64(), function(checkifexists)
          if checkifexists[1].status == false then print('GBay MySQL Error: '..checkifexists[1].error) end
          if checkifexists[1].affected == 0 then
            GBayMySQL:Query("INSERT INTO players (sid,	rank,	positiverep, neutralrep, negativerep, rating) VALUES ('"..ply:SteamID64().."', 'User', '0', '0', '0', '[]')", function(result2)
              if result2[1].status == false then print('GBay MySQL Error: '..result2[1].error) end
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
        GBayMySQL:Query("SELECT * FROM ads", function(adsonserver)
          if adsonserver[1].status == false then print('GBay MySQL Error: '..adsonserver[1].error) end
          for k, v in pairs(adsonserver[1].data) do
            if v.timetoexpire < os.time() then
              GBayMySQL:Query("DELETE FROM ads WHERE id="..v.id, function(removeads)
                if removeads[1].status == false then print('GBay MySQL Error: '..removeads[1].error) end
              end)
            end
          end
        end)
        GBayMySQL:Query("SELECT * FROM orders WHERE sidmerchant ="..ply:SteamID64(), function(playersorders)
          if playersorders[1].status == false then print('GBay MySQL Error: '..playersorders[1].error) end
          if playersorders[1].affected > 0 then
            ply:GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
            timer.Create("GBayNotifyPlayerOfOrders",GBayConfig.TimeToNotify * 60,0,function()
              ply:GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
            end)
          end
        end)
        GBayMySQL:Query("SELECT * FROM service WHERE sidmerchant ="..ply:SteamID64(), function(playersservice)
          if playersservice[1].status == false then print('GBay MySQL Error: '..playersservice[1].error) end
          if playersservice[1].affected > 0 then
            for k, v in pairs(playersservice[1].data) do
              local buyers = util.JSONToTable(v.buyers)
              if #buyers > 0 then
                ply:GBayNotify("error", "Looks like you have "..#buyers.." service(s) to do!")
                for k, v in pairs(buyers) do
                  if IsValid(player.GetBySteamID64(v)) then
                    ply:GBayNotify("error", "Looks like you have some services to do! Please talk to "..player.GetBySteamID64(v):Nick().." ASAP!")
                  end
                end
                timer.Create("GBayNotifyPlayerOfOrders",GBayConfig.TimeToNotify * 60,0,function()
                  for k, v in pairs(buyers) do
                    if IsValid(player.GetBySteamID64(v)) then
                      ply:GBayNotify("error", "Looks like you have some services to do! Please talk to "..player.GetBySteamID64(v):Nick().." ASAP!")
                    end
                  end
                end)
              end
            end
          end
        end)
      end
    end)
  end
end)

hook.Add("PlayerSay", "GBayPlayerSay", function(ply, text)
  local text = string.lower(text)
  local playerinfotable = {}
  local serverinfotable = {}
  local shipmentsinfotable = {}
  local serviceinfotable = {}
  local entityinfotable = {}
  local adsinfotable = {}
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
                GBayMySQL:Query("INSERT INTO players (sid,	rank,	positiverep, neutralrep, negativerep, rating) VALUES ('"..ply:SteamID64().."', 'Superadmin', '0', '0', '0', '[]')", function(result2)
                  if result2[1].status == false then print('GBay MySQL Error: '..result2[1].error) end
                  GBayMySQL:Query("INSERT INTO serverinfo (servername) VALUES ('Server name')", function(insertingresult)
                    if insertingresult[1].status == false then print('GBay MySQL Error: '..insertingresult[1].error) end
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
            local JammedTable = {}
            local JammedTable2 = {}
            GBayMySQL:Query("SELECT * FROM players", function(playerinfo)
              if playerinfo[1].status == false then print('GBay MySQL Error: '..playerinfo[1].error) end
              net.Start("GBayGUILoadingPercLoad")
              net.Send(ply)
              for k, v in pairs(playerinfo[1].data) do
                table.insert(playerinfotable,{v.id, v.sid, v.rank, v.positiverep, v.neutralrep, v.negativerep})
                if v.sid == ply:SteamID64() then
                  for bid, b in pairs(util.JSONToTable(v.rating)) do
                    table.insert(JammedTable2,#JammedTable2 + 1,{b[1], b[2]})
                  end
                end
              end
              GBayMySQL:Query("SELECT * FROM serverinfo", function(serverinfo)
                if serverinfo[1].status == false then print('GBay MySQL Error: '..serverinfo[1].error) end
                net.Start("GBayGUILoadingPercLoad")
                net.Send(ply)
                for k, v in pairs(serverinfo[1].data) do
                  table.insert(serverinfotable,{v.id, v.servername, v.ads, v.services, v.coupons, v.feepost, v.maxprice, v.taxpercent, v.ttnoo, v.npcpos, v.npcang, v.npcmodel, v.ranks})
                end
                GBayMySQL:Query("SELECT * FROM shipments", function(shipmentsinfo)
                  if shipmentsinfo[1].status == false then print('GBay MySQL Error: '..shipmentsinfo[1].error) end
                  net.Start("GBayGUILoadingPercLoad")
                  net.Send(ply)
                  for k, v in pairs(shipmentsinfo[1].data) do
                    table.insert(shipmentsinfotable,{	v.id, v.sidmerchant, v.name, v.description, v.wep, v.price, v.amount})
                  end
                  GBayMySQL:Query("SELECT * FROM service", function(serviceinfo)
                    if serviceinfo[1].status == false then print('GBay MySQL Error: '..serviceinfo[1].error) end
                    net.Start("GBayGUILoadingPercLoad")
                    net.Send(ply)
                    for k, v in pairs(serviceinfo[1].data) do
                      table.insert(serviceinfotable,{v.id, v.sidmerchant, v.name, v.description, v.price, v.buyers})
                    end
                    GBayMySQL:Query("SELECT * FROM entities", function(entityinfo)
                      if entityinfo[1].status == false then print('GBay MySQL Error: '..entityinfo[1].error) end
                      net.Start("GBayGUILoadingPercLoad")
                      net.Send(ply)
                      for k, v in pairs(entityinfo[1].data) do
                        table.insert(entityinfotable,{v.id, v.sidmerchant, v.name, v.description, v.ent, v.price})
                      end
                      GBayMySQL:Query("SELECT * FROM ads", function(adsinfo)
                        if adsinfo[1].status == false then print('GBay MySQL Error: '..adsinfo[1].error) end
                        net.Start("GBayGUILoadingPercLoad")
                        net.Send(ply)
                        for k, v in pairs(adsinfo[1].data) do
                          table.insert(adsinfotable,{v.id, v.asid, v.type, v.iid, v.timetoexpire})
                        end
                      end)
                      timer.Simple(2,function()
                        net.Start("GBayGUILoadingPercLoad100")
                        net.Send(ply)
                        timer.Simple(.2, function()
                          table.insert(JammedTable,1,playerinfotable)
                          table.insert(JammedTable,2,serverinfotable)
                          table.insert(JammedTable,3,shipmentsinfotable)
                          table.insert(JammedTable,4,serviceinfotable)
                          table.insert(JammedTable,5,entityinfotable)
                          table.insert(JammedTable,6,adsinfotable)
                          net.Start("GBayOpenMenu")
                            net.WriteTable(JammedTable)
                            net.WriteTable(JammedTable2)
                          net.Send(ply)
                          net.Start("GBayCloseLoading")
                          net.Send(ply)
                        end)
                      end)
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
  elseif text:lower():match('[!/:.]gadmin') then
    GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playerresult)
      if playerresult[1].status == false then print('GBay MySQL Error: '..playerresult[1].error) end
      if GBayIsAdmin(playerresult[1].data[1]) then
        GBayMySQL:Query("SELECT * FROM players", function(allplayerresult)
          if allplayerresult[1].status == false then print('GBay MySQL Error: '..allplayerresult[1].error) end
          ply:GBayNotify("generic", "Loading players...")
          net.Start("GBayOpenAdminPanel")
            net.WriteTable(allplayerresult[1].data)
          net.Send(ply)
        end)
      else
        ply:GBayNotify("error", "Get outta here!")
      end
    end)
    return ''
  end
end)

net.Receive("GBayUpdateSettings",function(len, ply)
  local customrankstable = {{"User", false, false, false, false, false, false, false, false}, {"Superadmin", true, true, true, true, true, true, true, true}}
  local settings = GBayEscapeString(net.ReadTable())
  local servername = settings[2]
  local ads = settings[3]
  local service = settings[4]
  local coupon = settings[5]
  local postingfee = settings[6]
  local maxpricetosell = settings[7]
  local taxtocharge = settings[8]
  local thetimetonot = settings[9]
  local npcpos = settings[10]
  local npcang = settings[11]
  local npcmodel = settings[12]

  if ads then adst = 1 else adst = 0 end
  if service then servicet = 1 else servicet = 0 end
  if coupon then coupont = 1 else coupont = 0 end
  GBayMySQL:Query("SELECT * FROM players", function(playerinfo)
    if playerinfo[1].status == false then print('GBay MySQL Error: '..playerinfo[1].error) end
    if playerinfo[1].data[1].rank == "Superadmin" or playerinfo[1].data[1].rank == "Admin" then
      GBayMySQL:Query("UPDATE serverinfo SET servername='"..servername.."', ads='"..adst.."', services='"..servicet.."', coupons='"..coupont.."', feepost='"..postingfee.."', maxprice='"..maxpricetosell.."', taxpercent='"..taxtocharge.."', ttnoo='"..thetimetonot.."', npcpos='"..npcpos.."', npcang='"..npcang.."', npcmodel='"..npcmodel.."'", function(result)
        if result[1].status == false then print('GBay MySQL Error: '..result[1].error) end
        GBayRefreshSettings()
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
            totalprice = math.Round(costofone * quantity)
            totalprice = math.Round(totalprice + totalprice * GBayConfig.TaxToMultiplyBy)
            if ply:getDarkRPVar("money") >= math.Round(totalprice) then
              if quantity == data.amount then
                GBayMySQL:Query("DELETE FROM shipments WHERE id="..data.id, function(removeshipment)
                  if removeshipment[1].status == false then print('GBay MySQL Error: '..removeshipment[1].error) end
                  GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer,	type,	weapon,	weaponshipname, quantity, pricepaid, timestamp) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Shipment', '"..data.wep.."', '"..data.wepname.."', '"..tonumber(quantity).."', '"..data.price.."', '"..tonumber(os.time()).."')", function(addtoorder)
                    if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                    ply:addMoney(-math.Round(totalprice))
                    net.Start("GBayTransErrorReport")
                      net.WriteString('Success')
                    net.Send(ply)
                    if IsValid(player.GetBySteamID64(data.sidmerchant)) then
                      player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                      timer.Create("GBayNotifyPlayerOfOrders",GBayConfig.TimeToNotify * 60,0,function()
                        player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                      end)
                    end
                  end)
                end)
              else
                GBayMySQL:Query("UPDATE shipments SET amount='"..data.amount - quantity.."' WHERE id="..data.id, function(removeshipment)
                  if removeshipment[1].status == false then print('GBay MySQL Error: '..removeshipment[1].error) end
                  GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer,	type,	weapon,	weaponshipname, quantity, pricepaid, timestamp) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Shipment', '"..data.wep.."', '"..data.wepname.."', '"..tonumber(quantity).."', '"..data.price.."', '"..tonumber(os.time()).."')", function(addtoorder)
                    if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                    ply:addMoney(-totalprice)
                    net.Start("GBayTransErrorReport")
                      net.WriteString('Success')
                    net.Send(ply)
                    if IsValid(player.GetBySteamID64(data.sidmerchant)) then
                      player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                      timer.Create("GBayNotifyPlayerOfOrders",GBayConfig.TimeToNotify * 60,0,function()
                        player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                      end)
                    end
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
              GBayMySQL:Query("INSERT INTO orders (sidmerchant,	sidcustomer, type, weapon, quantity, pricepaid, timestamp) VALUES ('"..data.sidmerchant.."', '"..ply:SteamID64().."', 'Entity', '"..data.ent.."', '"..tonumber(quantity).."', '"..data.price.."', '"..tonumber(os.time()).."')", function(addtoorder)
                if addtoorder[1].status == false then print('GBay MySQL Error: '..addtoorder[1].error) end
                ply:addMoney(-totalprice)
                net.Start("GBayTransErrorReport")
                  net.WriteString('Success')
                net.Send(ply)
                if IsValid(player.GetBySteamID64(data.sidmerchant)) then
                  player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                  timer.Create("GBayNotifyPlayerOfOrders",GBayConfig.TimeToNotify * 60,0,function()
                    player.GetBySteamID64(data.sidmerchant):GBayNotify("error", "Looks like you have some orders to fill! Please visit the MailNPC ASAP!")
                  end)
                end
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
  victim = GBayEscapeString(net.ReadString())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("SELECT * FROM bans WHERE bid="..victim, function(bansresult)
          if bansresult[1].status == false then print('GBay MySQL Error: '..bansresult[1].error) end
          if bansresult[1].affected > 1 then
            ply:GBayNotify("error", "This player is already banned!")
          else
            GBayMySQL:Query("INSERT INTO bans (bid, aid, time) VALUES ('"..victim.."', '"..ply:SteamID64().."', '"..os.time() + 60*60*24*days.."')", function(banresult)
              if banresult[1].status == false then print('GBay MySQL Error: '..banresult[1].error) end
              if IsValid(player.GetBySteamID64(victim)) then
                player.GetBySteamID64(victim):GBayNotify("error", "You have been banned by "..player.GetBySteamID64(ply:SteamID64()):Nick().." for "..days.." day(s)!")
              end
            end)
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBayUnBanPlayer",function(len, ply)
  victim = GBayEscapeString(net.ReadString())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsAdmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("SELECT * FROM bans WHERE bid="..victim, function(bansresult)
          if bansresult[1].status == false then print('GBay MySQL Error: '..bansresult[1].error) end
          if bansresult[1].affected > 0 then
            GBayMySQL:Query("DELETE FROM bans WHERE bid ="..ply:SteamID64(), function(banresult)
              if banresult[1].status == false then print('GBay MySQL Error: '..banresult[1].error) end
              if IsValid(player.GetBySteamID64(victim)) then
                player.GetBySteamID64(victim):GBayNotify("generic", "You have been unbanned by "..player.GetBySteamID64(ply:SteamID64()):Nick().."!")
              end
            end)
          else
            ply:GBayNotify("error", "This player is not banned!")
          end
        end)
      end)
    end
  end)
end)

net.Receive("GBaySetPlayerRank",function(len, ply)
  rank = GBayEscapeString(net.ReadString())
  victim = GBayEscapeString(net.ReadString())
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsSuperadmin(adminplayersresult[1].data[1]) then
      GBayMySQL:Query("SELECT * FROM players WHERE id="..victim, function(victimplayersresult)
        if victimplayersresult[1].status == false then print('GBay MySQL Error: '..victimplayersresult[1].error) end
        GBayMySQL:Query("UPDATE players SET rank='"..rank.."' WHERE sid="..victim, function(rankchangedresult)
          if rankchangedresult[1].status == false then print('GBay MySQL Error: '..rankchangedresult[1].error) end
          if IsValid(player.GetBySteamID64(victim)) then
            player.GetBySteamID64(victim):GBayNotify("generic", "Your rank has been set by "..player.GetBySteamID64(ply:SteamID64()):Nick().." to "..rank.."!")
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

net.Receive("GBaySetMySQLFromConfig",function(len, ply)
  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
    if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
    if GBayIsSuperadmin(adminplayersresult[1].data[1]) then
      net.Start("GBaySetMySQL")
      net.Send(ply)
    end
  end)
end)

net.Receive("GBayPlayerRatingWorker",function(len, ply)
  local playertorate = GBayEscapeString(net.ReadString())
  local rate = GBayEscapeString(net.ReadString())

  GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playersdata)
    if playersdata[1].status == false then print('GBay MySQL Error: '..playersdata[1].error) end
    local torates = util.JSONToTable(playersdata[1].data[1].rating)
    local ratingplayerfound = false
    for k, v in pairs(torates) do
      if ratingplayerfound == false then
        if v[1] == playertorate then
          ratingplayerfound = true
          table.remove(torates,k)
        end
      end
    end
    if ratingplayerfound then
      GBayMySQL:Query("UPDATE players SET rating='"..util.TableToJSON(torates).."' WHERE sid="..ply:SteamID64(), function(updateplayer)
        if updateplayer[1].status == false then print('GBay MySQL Error: '..updateplayer[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid="..playertorate, function(victimsid)
          if victimsid[1].status == false then print('GBay MySQL Error: '..victimsid[1].error) end
          local query = ""
          if rate == "Positive" then
            query = "UPDATE players SET positiverep='"..(tonumber(victimsid[1].data[1].positiverep) + 1) .."' WHERE sid="..playertorate
          elseif rate == "Netural" then
            query = "UPDATE players SET neutralrep='"..(tonumber(victimsid[1].data[1].neutralrep) + 1) .."' WHERE sid="..playertorate
          elseif rate == "Negative" then
            query = "UPDATE players SET negativerep='"..(tonumber(victimsid[1].data[1].negativerep) + 1) .."' WHERE sid="..playertorate
          end
          GBayMySQL:Query(query, function(updatevicplayer)
            if updatevicplayer[1].status == false then print('GBay MySQL Error: '..updatevicplayer[1].error) end
          end)
        end)
      end)
    end
  end)
end)

net.Receive("GBayAddAllAdmins",function(len, ply)
  if ply:IsSuperAdmin() then
    for k, v in pairs(player.GetAll()) do
      if v:IsSuperAdmin() then
        GBayMySQL:Query("UPDATE players SET rank='Superadmin' WHERE sid="..v:SteamID64(), function(rankchangedresult)
          if rankchangedresult[1].status == false then print('GBay MySQL Error: '..rankchangedresult[1].error) end
          v:GBayNotify("generic", "Your rank has been set by "..ply:Nick().." to Superadmin!")
        end)
      end
    end
  end
end)

concommand.Add("gbaytest",function(ply)
--  GBayRefreshSettings()
end)
