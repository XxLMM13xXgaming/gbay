GBayConfig = {}
local config = GBayConfig
/*
  Made By: XxLMM13xXgaming
*/
-- Currently only supports the following weapon packs
-- FAS:2 Weapons (id = fas)
-- M9K Weapons (id = m9k)
-- Hl2 Weapons (defualt with gmod) (id = hl2)
-- DarkRP Weapons (defualt with darkrp) (id = darkrp)

-- How to edit the table below...
-- Add a new entry by writing this '{},'
-- Next put in this "", ""
-- In the first qoutes put in the allowed weapon id
-- In the second qoutes put in the weapon type (id shown above)

config.AllowedWeapons = {
  {"m9k_ak47", "m9k"},
  {"weapon_ar2", "hl2"},
  {"weapon_mac102", "darkrp"},
  {"weapon_ak472", "darkrp"},
}

config.PriceToPayToSell = 100 -- Fee to sell items
config.MaxPrice = 100000 -- Max price to sell items

config.TaxToMultiplyBy = 0.08
