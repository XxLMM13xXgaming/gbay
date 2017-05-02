net.Receive("GBaySubmitShipment",function(len, ply)
    local shipname = GBayEscapeString(net.ReadString())
    local shipdesc = GBayEscapeString(net.ReadString())
    local ship = GBayEscapeString(net.ReadEntity())
    local shipprice = GBayEscapeString(net.ReadFloat())

    if ply:getDarkRPVar("money") < GBayConfig.PriceToPayToSell then
        ply:GBayNotify("error", "You do not have enough money to post this item! (you need " .. DarkRP.formatMoney(GBayConfig.PriceToPayToSell - ply:getDarkRPVar("money")) .. ")")
        return
    end

    if string.len(shipname) <= 27 and string.len(shipdesc) <= 81 then
        for k, v in pairs(ents.GetAll()) do
            if v == ship and ply:GetPos():Distance(v:GetPos()) < 100 and shipprice <= GBayConfig.MaxPrice then
                GBayMySQL:Query("INSERT INTO shipments ( sidmerchant,	name,	description,	wep, wepname, price, amount ) VALUES ('" .. ply:SteamID64() .. "', '" .. shipname .. "', '" .. shipdesc .. "', '" .. CustomShipments[v:Getcontents()].entity .. "', '" .. CustomShipments[v:Getcontents()].name .. "', '" .. shipprice .. "', '" .. CustomShipments[v:Getcontents()].amount .. "')", function(createshipment)
                    if createshipment[1].status == false then print("GBay MySQL Error: " .. createshipment[1].error) end
                    net.Start("GBayDoneLoading")
                        net.WriteString("Shipment")
                        net.WriteTable({createshipment[1].lastid, ply:SteamID64(), shipname, shipdesc, CustomShipments[v:Getcontents()].entity, shipprice, CustomShipments[v:Getcontents()].amount})
                    net.Send(ply)
                    ply:addMoney(-GBayConfig.PriceToPayToSell)
                end)
            end
        end
    end
end)

net.Receive("GBayEditShipment",function(len, ply)
  local shipwep = GBayEscapeString(net.ReadTable())
  local shipname = GBayEscapeString(net.ReadString())
  local shipdesc = GBayEscapeString(net.ReadString())
  local shipprice = GBayEscapeString(net.ReadFloat())

    if string.len(shipname) > 27 and string.len(shipdesc) > 81 then
        return
    end
    GBayMySQL:Query("SELECT * FROM shipments WHERE id=" .. shipwep[1], function(shipwepr)
        if shipwepr[1].status == false then print("GBay MySQL Error: " .. shipwepr[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid=" .. ply:SteamID64(), function(playersresult)
            if playersresult[1].status == false then print("GBay MySQL Error: " .. playersresult[1].error) end
            if shipwepr[1].data[1].sidmerchant == ply:SteamID64() or GBayIsAdmin(playersresult[1].data[1]) and shipprice <= GBayConfig.MaxPrice then
                GBayMySQL:Query("UPDATE shipments SET name='" .. shipname .. "',description='" .. shipdesc .. "', price='" .. shipprice .. "' WHERE id=" .. shipwep[1], function(createshipment)
                    if createshipment[1].status == false then print("GBay MySQL Error: " .. createshipment[1].error) end
                    net.Start("GBayDoneLoading2")
                    net.Send(ply)
                end)
            end
        end)
    end)
end)

net.Receive("GBayRemoveShipment",function(len, ply)
    item = GBayEscapeString(net.ReadFloat())
    GBayMySQL:Query("SELECT * FROM shipments WHERE id=" .. item, function(shipwepr)
        if shipwepr[1].status == false then print("GBay MySQL Error: " .. shipwepr[1].error) end
        GBayMySQL:Query("SELECT * FROM players WHERE sid=" .. ply:SteamID64(), function(adminplayersresult)
            if adminplayersresult[1].status == false then print("GBay MySQL Error: " .. adminplayersresult[1].error) end
            if GBayIsAdmin(adminplayersresult[1].data[1]) then
                GBayMySQL:Query("DELETE FROM shipments WHERE id=" .. item, function(deleteshipment)
                    if deleteshipment[1].status == false then print("GBay MySQL Error: " .. deleteshipment[1].error) end
                    ply:GBayNotify("generic", "You have deleted this shipment! Please restart GBay to remove it!")
                end)
            end
        end)
    end)
end)
