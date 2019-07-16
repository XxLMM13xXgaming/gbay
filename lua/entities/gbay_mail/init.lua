AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString("GBayOpenMailNPCHomePage")
util.AddNetworkString("GBayCheckOrder")
util.AddNetworkString("GBayOpenPlayerOrders")
util.AddNetworkString("GBayShipOrder")
util.AddNetworkString("GBayOpenPlayerOrdersShip")
util.AddNetworkString("GBayShipItem")
util.AddNetworkString("GBayNPCShiped")
util.AddNetworkString("GBayRetriveItem")
util.AddNetworkString("GBayOpenNPCLoading")
util.AddNetworkString("GBayCloseNPCLoading")
util.AddNetworkString("GBayMailNPCReturn")
util.AddNetworkString("GBayNPCClosed")

function ENT:Initialize()
	self:SetModel(GBayConfig.NPCModel)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_VPHYSICS)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE, CAP_TURN_HEAD)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
end

function SpawnGBayMailNPC()
	if GBayConfig.NPCModel ~= nil then
		print("Spawning Mail NPC")
		local npc = ents.Create("gbay_mail")
		npc:Spawn()
		npc:SetPos(GBayConfig.NPCPos)
		npc:SetAngles(GBayConfig.NPCAng)
		--		npc:SetMoveType( MOVETYPE_NONE )
		npc:DropToFloor()
	end
end

hook.Add("InitPostEntity", "SpawnGBayMailNPC", SpawnGBayMailNPC)

function ENT:AcceptInput(Name, Activator, Caller)
	if self.PlayerWorkingWith == nil then
		self.PlayerWorkingWith = Caller
		net.Start("GBayOpenMailNPCHomePage")
		net.Send(Caller)
	else
		Caller:GBayNotify("error", "Sorry im currently busy!")
	end
end

hook.Add("PlayerDisconnected", "GBayPlayerLeaveResetNPC", function(ply)
	for k, v in pairs(ents.FindByClass("gbay_mail")) do
		if v.PlayerWorkingWith == ply then
			v.PlayerWorkingWith = nil
		end
	end
end)

net.Receive("GBayNPCClosed", function(len, ply)
	for k, v in pairs(ents.FindByClass("gbay_mail")) do
		if v.PlayerWorkingWith == ply then
			v.PlayerWorkingWith = nil
		end
	end
end)

net.Receive("GBayCheckOrder", function(len, ply)
	net.Start("GBayOpenNPCLoading")
	net.Send(ply)

	GBayMySQL:Query("SELECT * FROM orders WHERE sidcustomer=" .. ply:SteamID64(), function(playersorders)
		if playersorders[1].status == false then
			print('GBay MySQL Error: ' .. playersorders[1].error)
		end

		if playersorders[1].affected > 0 then
			net.Start("GBayOpenPlayerOrders")
			net.WriteTable(playersorders[1].data)
			net.Send(ply)
			net.Start("GBayCloseNPCLoading")
			net.Send(ply)
		else
			net.Start("GBayCloseNPCLoading")
			net.Send(ply)
			ply:GBayNotify("error", "Sorry no orders found!")

			for k, v in pairs(ents.FindByClass("gbay_mail")) do
				v.PlayerWorkingWith = nil
			end
		end
	end)
end)

--for k, v in pairs(ents.GetAll()) do
--	if v:GetClass() == "gbay_mail" then
--		v.PlayerWorkingWith = nil
--	end
--end
net.Receive("GBayShipOrder", function(len, ply)
	net.Start("GBayOpenNPCLoading")
	net.Send(ply)

	GBayMySQL:Query("SELECT * FROM orders WHERE sidmerchant=" .. ply:SteamID64(), function(playersorders)
		if playersorders[1].status == false then
			print('GBay MySQL Error: ' .. playersorders[1].error)
		end

		if playersorders[1].affected > 0 then
			net.Start("GBayOpenPlayerOrdersShip")
			net.WriteTable(playersorders[1].data)
			net.Send(ply)
			net.Start("GBayCloseNPCLoading")
			net.Send(ply)
		else
			net.Start("GBayCloseNPCLoading")
			net.Send(ply)
			ply:GBayNotify("error", "Sorry no orders found!")

			for k, v in pairs(ents.FindByClass("gbay_mail")) do
				v.PlayerWorkingWith = nil
			end
		end
	end)
end)

net.Receive("GBayShipItem", function(len, ply)
	local itemid = net.ReadFloat()
	local thenpc = nil

	for k, v in pairs(ents.FindByClass("gbay_mail")) do
		thenpc = v
	end

	GBayMySQL:Query("SELECT * FROM orders WHERE id=" .. itemid, function(itemresult)
		if itemresult[1].status == false then
			print('GBay MySQL Error: ' .. itemresult[1].error)
		end

		if itemresult[1].affected > 0 then
			if itemresult[1].data[1].sidmerchant == ply:SteamID64() then
				ply:GBayNotify("generic", "You may now give me your item!")
				ply:ChatPrint("*drag item close to me you have 10 sec before menu reopens!*")
				ply.GBayNPCNeedsItem = true

				timer.Simple(10, function()
					if ply.GBayNPCNeedsItem then
						net.Start("GBayNPCShiped")
						net.Send(ply)
						ply.GBayNPCNeedsItem = false
					end
				end)

				timer.Create("GBayItemCheckTimer", 1, 10, function()
					for k, v in pairs(ents.GetAll()) do
						if (thenpc:GetPos():Distance(v:GetPos()) < 100) then
							if itemresult[1].data[1].type == "Shipment" then
								if v:GetClass() == "spawned_shipment" then
									if CustomShipments[v:Getcontents()].entity == itemresult[1].data[1].weapon then
										if v:Getcount() == itemresult[1].data[1].quantity then
											timer.Remove("GBayItemCheckTimer")
											v:Remove()
											ply:addMoney(itemresult[1].data[1].pricepaid)
											net.Start("GBayNPCShiped")
											net.Send(ply)
											ply.GBayNPCNeedsItem = false
											thenpc.PlayerWorkingWith = nil

											GBayMySQL:Query("UPDATE orders SET completed=1 WHERE id=" .. itemid, function(updatingorder)
												if updatingorder[1].status == false then
													print('GBay MySQL Error: ' .. updatingorder[1].error)
												end

												ply:GBayNotify("generic", "I will be shipping your item soon!")
											end)
										elseif v:Getcount() > itemresult[1].data[1].quantity then
											timer.Remove("GBayItemCheckTimer")
											v:Setcount(v:Getcount() - itemresult[1].data[1].quantity)
											ply:addMoney(itemresult[1].data[1].pricepaid)
											net.Start("GBayNPCShiped")
											net.Send(ply)
											ply.GBayNPCNeedsItem = false
											thenpc.PlayerWorkingWith = nil

											GBayMySQL:Query("UPDATE orders SET completed=1 WHERE id=" .. itemid, function(updatingorder)
												if updatingorder[1].status == false then
													print('GBay MySQL Error: ' .. updatingorder[1].error)
												end

												ply:GBayNotify("generic", "I will be shipping your item soon!")
											end)
										else
											ply:GBayNotify("error", "Not enough in this shipment!")
										end
									end
								end
							elseif itemresult[1].data[1].type == "Entity" then
								if v:GetClass() == itemresult[1].data[1].weapon then
									timer.Remove("GBayItemCheckTimer")
									v:Remove()
									ply:addMoney(itemresult[1].data[1].pricepaid)
									net.Start("GBayNPCShiped")
									net.Send(ply)
									ply.GBayNPCNeedsItem = false
									thenpc.PlayerWorkingWith = nil

									GBayMySQL:Query("UPDATE orders SET completed=1 WHERE id=" .. itemid, function(updatingorder)
										if updatingorder[1].status == false then
											print('GBay MySQL Error: ' .. updatingorder[1].error)
										end

										ply:GBayNotify("generic", "I will be shipping your item soon!")
									end)
								end
							end
						end
					end
				end)
			else
				ply:GBayNotify("error", "You dont own this item!")
			end
		else
			ply:GBayNotify("error", "Ugh oh something went wrong!")
		end
	end)
end)

net.Receive("GBayRetriveItem", function(len, ply)
	local itemid = net.ReadFloat()
	local thenpc = nil

	for k, v in pairs(ents.FindByClass("gbay_mail")) do
		thenpc = v
	end

	GBayMySQL:Query("SELECT * FROM orders WHERE id=" .. itemid, function(itemresult)
		if itemresult[1].status == false then
			print('GBay MySQL Error: ' .. itemresult[1].error)
		end

		if itemresult[1].affected > 0 then
			if tostring(itemresult[1].data[1].completed) == "1" then
				for k, v in pairs(ents.FindByClass("gbay_mail")) do
					local pos = v:GetPos() + Vector(10, 0, 20)

					if itemresult[1].data[1].type == "Shipment" then
						local found, foundKey = DarkRP.getShipmentByName(itemresult[1].data[1].weaponshipname)
						local crate = ents.Create(found.shipmentClass or "spawned_shipment")
						crate.SID = ply.SID
						crate:Setowning_ent(ply)
						crate:SetContents(foundKey, itemresult[1].data[1].quantity)
						crate:SetPos(pos)
						crate.nodupe = true
						crate.ammoadd = found.spareammo
						crate.clip1 = found.clip1
						crate.clip2 = found.clip2
						crate:Spawn()
						crate:SetPlayer(ply)
						local phys = crate:GetPhysicsObject()
						phys:Wake()

						if found.weight then
							phys:SetMass(found.weight)
						end

						if IsValid(crate) then
							GBayMySQL:Query("DELETE FROM orders WHERE id=" .. itemresult[1].data[1].id, function(deleteitem)
								if deleteitem[1].status == false then
									print('GBay MySQL Error: ' .. deleteitem[1].error)
								end

								GBayMySQL:Query("SELECT * FROM players WHERE sid=" .. ply:SteamID64(), function(playerdata)
									if playerdata[1].status == false then
										print('GBay MySQL Error: ' .. playerdata[1].error)
									end

									newrating = util.JSONToTable(playerdata[1].data[1].rating)
									table.insert(newrating, #newrating + 1, {itemresult[1].data[1].sidmerchant, itemresult[1].data[1].weaponshipname})

									GBayMySQL:Query("UPDATE players SET rating='" .. util.TableToJSON(newrating) .. "' WHERE sid=" .. ply:SteamID64(), function(result)
										ply:GBayNotify("generic", "Open GBay to rate this player!")
									end)
								end)
							end)
						else
							ply:GBayNotify("error", "Woah.. Something went wrong!")
						end

						thenpc.PlayerWorkingWith = nil
					elseif itemresult[1].data[1].type == "Entity" then
						local SpawnedEnt = ents.Create(itemresult[1].data[1].weapon)
						SpawnedEnt:Spawn()
						SpawnedEnt:SetPos(pos)
						SpawnedEnt:DropToFloor()

						if IsValid(SpawnedEnt) then
							GBayMySQL:Query("DELETE FROM orders WHERE id=" .. itemresult[1].data[1].id, function(deleteitem)
								if deleteitem[1].status == false then
									print('GBay MySQL Error: ' .. deleteitem[1].error)
								end
							end)
						else
							ply:GBayNotify("error", "Woah.. Something went wrong!")
						end

						thenpc.PlayerWorkingWith = nil
					end
				end
			end
		end
	end)
end)

net.Receive("GBayMailNPCReturn", function(len, ply)
	net.Start("GBayOpenMailNPCHomePage")
	net.Send(ply)
end)