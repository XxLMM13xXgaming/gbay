net.Receive("GBayPurchaseAd",function(len, ply)
  local adtype = GBayEscapeString(net.ReadString())
  local adid = GBayEscapeString(net.ReadString())

  if adtype == "Ship" then querytype = "shipments" elseif adtype == "Serv" then querytype = "service" elseif adtype == "Ent" then querytype = "entities" else return end
  GBayMySQL:Query("SELECT * FROM "..querytype.." WHERE id="..adid, function(ItemToAd)
    if ItemToAd[1].status == false then print('GBay MySQL Error: '..ItemToAd[1].error) end
    if ItemToAd[1].affected > 0 then
      if ItemToAd[1].data[1].sidmerchant == ply:SteamID64() then
        if ply:getDarkRPVar("money") >= ItemToAd[1].data[1].price/2 then
          local timetoexpire = os.time() + 60*60*24*1
          GBayMySQL:Query("SELECT * FROM ads WHERE type='"..querytype.."' AND iid='"..adid.."'", function(adscheckexist)
            if adscheckexist[1].status == false then print('GBay MySQL Error: '..adscheckexist[1].error) end
            if adscheckexist[1].affected == 0 then
              GBayMySQL:Query("INSERT INTO ads (asid, type, iid, timetoexpire) VALUES ('"..ply:SteamID64().."', '"..querytype.."', '"..adid.."', '"..timetoexpire.."')", function(CreateAds)
                if CreateAds[1].status == false then print('GBay MySQL Error: '..CreateAds[1].error) end
                ply:GBayNotify("generic", "Your item is now advertised!")
                ply:addMoney(-ItemToAd[1].data[1].price/2)
              end)
            else
              ply:GBayNotify("error", "This item is already advertised!")
            end
          end)
        else
          ply:GBayNotify("error", "You do not have enough money!")
        end
      end
    end
  end)

end)
