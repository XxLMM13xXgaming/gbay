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
                  net.WriteTable({createshipment[1].lastid, ply:SteamID64(), shipname, shipdesc, CustomShipments[v:Getcontents()].entity, shipprice})
                net.Send(ply)
              end)
            end
          end
        end
      end
    end
  end
end)
