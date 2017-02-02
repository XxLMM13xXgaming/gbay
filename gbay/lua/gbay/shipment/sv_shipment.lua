net.Receive("GBaySubmitShipment",function(len, ply)
  local shipname = GBayEscapeString(net.ReadString())
  local shipdesc = GBayEscapeString(net.ReadString())
  local ship = GBayEscapeString(net.ReadEntity())
  local shipprice = GBayEscapeString(net.ReadFloat())

  if string.len(shipname) <= 27 then
    if string.len(shipdesc) <= 81 then
      for k, v in pairs(ents.GetAll()) do
        if v == ship then
          if ( ply:GetPos():Distance(v:GetPos()) < 100)  then
            if shipprice <= GBayConfig.MaxPrice then
              GBayMySQL:Query("INSERT INTO shipments ( sidmerchant,	name,	description,	wep,	price, amount ) VALUES ('"..ply:SteamID64().."', '"..shipname.."', '"..shipdesc.."', '"..CustomShipments[v:Getcontents()].entity.."', '"..shipprice.."', '"..CustomShipments[v:Getcontents()].amount.."')", function(createshipment)
                if createshipment[1].status == false then print('GBay MySQL Error: '..createshipment[1].error) end
                net.Start("GBayDoneLoading")
                  net.WriteString("Shipment")
                  net.WriteTable({createshipment[1].lastid, ply:SteamID64(), shipname, shipdesc, CustomShipments[v:Getcontents()].entity, shipprice, CustomShipments[v:Getcontents()].amount})
                net.Send(ply)
              end)
            end
          end
        end
      end
    end
  end
end)

net.Receive("GBayEditShipment",function(len, ply)
  local shipwep = net.ReadTable()
  local shipname = GBayEscapeString(net.ReadString())
  local shipdesc = GBayEscapeString(net.ReadString())
  local shipprice = GBayEscapeString(net.ReadFloat())

  if string.len(shipname) <= 27 then
    if string.len(shipdesc) <= 81 then
      GBayMySQL:Query("SELECT * FROM shipments WHERE id="..shipwep[1], function(shipwepr)
        if shipwepr[1].status == false then print('GBay MySQL Error: '..shipwepr[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid="..ply:SteamID64(), function(playersresult)
          if playersresult[1].status == false then print('GBay MySQL Error: '..playersresult[1].error) end
          if shipwepr[1].data[1].sidmerchant == ply:SteamID64() or GBayIsAdmin(playersresult[1].data[1]) then
            if shipprice <= GBayConfig.MaxPrice then
              GBayMySQL:Query("UPDATE shipments SET name='"..shipname.."',description='"..shipdesc.."', price='"..shipprice.."' WHERE id="..shipwep[1], function(createshipment)
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
