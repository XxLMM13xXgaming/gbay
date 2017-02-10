net.Receive("GBaySubmitService",function(len, ply)
  local servname = GBayEscapeString(net.ReadString())
  local servdesc = GBayEscapeString(net.ReadString())
  local servprice = GBayEscapeString(net.ReadFloat())

  if string.len(servname) <= 27 then
    if string.len(servdesc) <= 81 then
      if servprice <= GBayConfig.MaxPrice then
        GBayMySQL:Query("INSERT INTO service ( sidmerchant,	name,	description, price ) VALUES ('"..ply:SteamID64().."', '"..servname.."', '"..servdesc.."', '"..servprice.."')", function(createservice)
          if createservice[1].status == false then print('GBay MySQL Error: '..createservice[1].error) end
          net.Start("GBayDoneLoading")
            net.WriteString("Service")
            net.WriteTable({createservice[1].lastid, ply:SteamID64(), servname, servdesc, servprice})
          net.Send(ply)
        end)
      end
    end
  end
end)

net.Receive("GBayEditService",function(len, ply)
  local serv = net.ReadTable()
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
  item = net.ReadFloat()
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
