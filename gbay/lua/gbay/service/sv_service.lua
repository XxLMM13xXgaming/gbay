net.Receive("GBaySubmitService",function(len, ply)
  local servname = GBayEscapeString(net.ReadString())
  local servdesc = GBayEscapeString(net.ReadString())
  local servprice = GBayEscapeString(net.ReadFloat())

  if GBayConfig.ServiceToggle then
    if ply:getDarkRPVar('money') >= GBayConfig.PriceToPayToSell then
      if string.len(servname) <= 27 then
        if string.len(servdesc) <= 81 then
          if servprice <= GBayConfig.MaxPrice then
            GBayMySQL:Query("INSERT INTO service ( sidmerchant,	name,	description, price, buyers ) VALUES ('"..ply:SteamID64().."', '"..servname.."', '"..servdesc.."', '"..servprice.."', '[]')", function(createservice)
              if createservice[1].status == false then print('GBay MySQL Error: '..createservice[1].error) end
              net.Start("GBayDoneLoading")
                net.WriteString("Service")
                net.WriteTable({createservice[1].lastid, ply:SteamID64(), servname, servdesc, servprice})
              net.Send(ply)
              ply:addMoney(-GBayConfig.PriceToPayToSell)
            end)
          end
        end
      end
    else
      ply:GBayNotify("error", "You do not have enough money to post this item! (you need "..DarkRP.formatMoney(GBayConfig.PriceToPayToSell - ply:getDarkRPVar('money'))..")")
    end
  else
    ply:GBayNotify("error", "Services are NOT allowed on "..GBayConfig.ServerName)
  end
end)

net.Receive("GBayEditService",function(len, ply)
  local serv = GBayEscapeString(net.ReadTable())
  local servname = GBayEscapeString(net.ReadString())
  local servdesc = GBayEscapeString(net.ReadString())
  local servprice = GBayEscapeString(net.ReadFloat())

  if string.len(servname) <= 27 then
    if string.len(servdesc) <= 81 then
      GBayMySQL:Query("SELECT * FROM service WHERE id="..serv[1], function(servr)
        if servr[1].status == false then print('GBay MySQL Error: '..servr[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playersresult)
          if playersresult[1].status == false then print('GBay MySQL Error: '..playersresult[1].error) end
          if servr[1].data[1].sidmerchant == ply:SteamID64() or GBayIsAdmin(playersresult[1].data[1]) then
            if servprice <= GBayConfig.MaxPrice then
              GBayMySQL:Query("UPDATE service SET name='"..servname.."',description='"..servdesc.."', price='"..servprice.."' WHERE id="..serv[1], function(createshipment)
                if createshipment[1].status == false then print('GBay MySQL Error: '..createshipment[1].error) end
                net.Start("GBayDoneLoading2")
                net.Send(ply)
              end)
            end
          end
        end)
      end)
    end
  end
end)

net.Receive("GBayRemoveService",function(len, ply)
  item = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM service WHERE id="..item, function(serv)
    if serv[1].status == false then print('GBay MySQL Error: '..serv[1].error) end
    GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
      if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
      if GBayIsAdmin(adminplayersresult[1].data[1]) then
        GBayMySQL:Query("DELETE FROM service WHERE id="..item, function(deleteshipment)
          if deleteshipment[1].status == false then print('GBay MySQL Error: '..deleteshipment[1].error) end
          ply:GBayNotify("generic", "You have deleted this service! Please restart GBay to remove it!")
        end)
      end
    end)
  end)
end)

net.Receive("GBayMarkServiceAsDone",function(len, ply)
  local service = net.ReadFloat()
  local playersid = net.ReadString()
  local rate = net.ReadString()

  GBayMySQL:Query("SELECT * FROM service WHERE id="..service, function(servr)
    if servr[1].status == false then print('GBay MySQL Error: '..servr[1].error) end
    GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playersresult)
      if playersresult[1].status == false then print('GBay MySQL Error: '..playersresult[1].error) end
      if servr[1].data[1].sidmerchant == ply:SteamID64() or GBayIsAdmin(playersresult[1].data[1]) then
        local buyers = util.JSONToTable(servr[1].data[1].buyers)
        if !table.HasValue(buyers,playersid) then return end
        for k, v in pairs(buyers) do
          if v == playersid then
            table.remove(buyers,k)
          end
        end
        GBayMySQL:Query("UPDATE service SET buyers='"..util.TableToJSON(buyers).."' WHERE id="..service, function(editservice)
          if editservice[1].status == false then print('GBay MySQL Error: '..editservice[1].error) end
          GBayMySQL:Query("SELECT * FROM players WHERE sid="..playersid, function(victimsid)
            if victimsid[1].status == false then print('GBay MySQL Error: '..victimsid[1].error) end
            if victimsid[1].affected > 0 then
              local query = ""
              if rate == "Positive" then
                query = "UPDATE players SET positiverep='"..(tonumber(victimsid[1].data[1].positiverep) + 1) .."' WHERE sid="..playersid
              elseif rate == "Netural" then
                query = "UPDATE players SET neutralrep='"..(tonumber(victimsid[1].data[1].neutralrep) + 1) .."' WHERE sid="..playersid
              elseif rate == "Negative" then
                query = "UPDATE players SET negativerep='"..(tonumber(victimsid[1].data[1].negativerep) + 1) .."' WHERE sid="..playersid
              end
              GBayMySQL:Query(query, function(updateplayer)
                if updateplayer[1].status == false then print('GBay MySQL Error: '..updateplayer[1].error) end
                thenewrating = util.JSONToTable(victimsid[1].data[1].rating)
                table.insert(thenewrating,#thenewrating + 1, {ply:SteamID64(), servr[1].data[1].name})
                GBayMySQL:Query("UPDATE players SET rating='"..util.TableToJSON(thenewrating).."' WHERE sid="..playersid, function(victimsiduipdaterating)
                  if victimsiduipdaterating[1].status == false then print('GBay MySQL Error: '..victimsiduipdaterating[1].error) end
                end)
              end)
            end
          end)
        end)
      end
    end)
  end)

end)
