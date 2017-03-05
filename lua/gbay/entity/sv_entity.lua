net.Receive("GBaySubmitEntity",function(len, ply)
  local entname = GBayEscapeString(net.ReadString())
  local entdesc = GBayEscapeString(net.ReadString())
  local ent = GBayEscapeString(net.ReadEntity())
  local entprice = GBayEscapeString(net.ReadFloat())

  print("logging")
  if ply:getDarkRPVar('money') >= GBayConfig.PriceToPayToSell then
    print("logging2")
    if string.len(entname) <= 27 then
      print("logging3")
      if string.len(entdesc) <= 81 then
        print("logging4")
        for k, v in pairs(ents.GetAll()) do
          print("logging5")
          if v == ent then
            if ( ply:GetPos():Distance(v:GetPos()) < 100)  then
              print(entprice)
              print(GBayConfig.MaxPrice)
              if entprice <= GBayConfig.MaxPrice then
                print("logging6")
                GBayMySQL:Query("INSERT INTO entities ( sidmerchant, name,	description, ent, price ) VALUES ('"..ply:SteamID64().."', '"..entname.."', '"..entdesc.."', '"..v:GetClass().."', '"..entprice.."')", function(createentity)
                  print("logging7")
                  if createentity[1].status == false then print('GBay MySQL Error: '..createentity[1].error) end
                  net.Start("GBayDoneLoading")
                    net.WriteString("Entity")
                    net.WriteTable({createentity[1].lastid, ply:SteamID64(), entname, entdesc, v:GetClass(), entprice})
                  net.Send(ply)
                  ply:addMoney(-GBayConfig.PriceToPayToSell)
                end)
              end
            end
          end
        end
      end
    end
  else
    ply:GBayNotify("error", "You do not have enough money to post this item! (you need "..DarkRP.formatMoney(GBayConfig.PriceToPayToSell - ply:getDarkRPVar('money'))..")")
  end
end)

net.Receive("GBayEditEntity",function(len, ply)
  local entent = GBayEscapeString(net.ReadTable())
  local entname = GBayEscapeString(net.ReadString())
  local entdesc = GBayEscapeString(net.ReadString())
  local entprice = GBayEscapeString(net.ReadFloat())

  if string.len(entname) <= 27 then
    if string.len(entdesc) <= 81 then
      GBayMySQL:Query("SELECT * FROM entities WHERE id="..entent[1], function(ententr)
        if ententr[1].status == false then print('GBay MySQL Error: '..ententr[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playersresult)
          if playersresult[1].status == false then print('GBay MySQL Error: '..playersresult[1].error) end
          if ententr[1].data[1].sidmerchant == ply:SteamID64() or GBayIsAdmin(playersresult[1].data[1]) then
            if entprice <= GBayConfig.MaxPrice then
              GBayMySQL:Query("UPDATE entities SET name='"..entname.."',description='"..entdesc.."', price='"..entprice.."' WHERE id="..entent[1], function(createentity)
                if createentity[1].status == false then print('GBay MySQL Error: '..createentity[1].error) end
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

net.Receive("GBayRemoveEntity",function(len, ply)
  item = GBayEscapeString(net.ReadFloat())
  GBayMySQL:Query("SELECT * FROM entities WHERE id="..item, function(ententr)
    if ententr[1].status == false then print('GBay MySQL Error: '..ententr[1].error) end
    GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(adminplayersresult)
      if adminplayersresult[1].status == false then print('GBay MySQL Error: '..adminplayersresult[1].error) end
      if GBayIsAdmin(adminplayersresult[1].data[1]) then
        GBayMySQL:Query("DELETE FROM entities WHERE id="..item, function(deleteent)
          if deleteent[1].status == false then print('GBay MySQL Error: '..deleteent[1].error) end
          ply:GBayNotify("generic", "You have deleted this entities! Please restart GBay to remove it!")
        end)
      end
    end)
  end)
end)
