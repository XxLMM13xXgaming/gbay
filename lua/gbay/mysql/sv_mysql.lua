require("tmysql4")
local GBayMySQLInfo = sql.Query("SELECT * FROM gbaymysqlinfo")
local GBayMySQLCreateTables = [[CREATE TABLE IF NOT EXISTS `ads` (
  `id` int(11) NOT NULL,
  `asid` varchar(17) NOT NULL,
  `type` varchar(255) NOT NULL,
  `iid` int(255) NOT NULL,
  `timetoexpire` int(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL,
  `bid` varchar(17) NOT NULL,
  `aid` varchar(17) NOT NULL,
  `time` int(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `entities` (
  `id` int(11) NOT NULL,
  `sidmerchant` varchar(17) NOT NULL,
  `name` varchar(27) NOT NULL,
  `description` varchar(81) NOT NULL,
  `ent` varchar(255) NOT NULL,
  `price` int(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `orders` (
  `id` int(11) NOT NULL,
  `sidmerchant` varchar(17) NOT NULL,
  `sidcustomer` varchar(17) NOT NULL,
  `type` varchar(255) NOT NULL,
  `weapon` varchar(255) NOT NULL,
  `weaponshipname` varchar(255) NOT NULL,
  `quantity` int(255) NOT NULL,
  `pricepaid` int(255) NOT NULL,
  `timestamp` int(255) NOT NULL,
  `completed` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL,
  `sid` varchar(17) NOT NULL,
  `rank` varchar(255) NOT NULL,
  `positiverep` int(255) NOT NULL,
  `neutralrep` int(255) NOT NULL,
  `negativerep` int(255) NOT NULL,
  `rating` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `serverinfo` (
  `id` int(11) NOT NULL,
  `servername` varchar(15) NOT NULL,
  `ads` tinyint(1) NOT NULL,
  `services` tinyint(1) NOT NULL,
  `coupons` tinyint(1) NOT NULL,
  `feepost` int(255) NOT NULL,
  `maxprice` int(255) NOT NULL,
  `taxpercent` int(255) NOT NULL,
  `ttnoo` int(255) NOT NULL,
  `npcpos` varchar(255) NOT NULL,
  `npcang` varchar(255) NOT NULL,
  `npcmodel` varchar(255) NOT NULL,
  `ranks` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `service` (
  `id` int(11) NOT NULL,
  `sidmerchant` varchar(17) NOT NULL,
  `name` varchar(20) NOT NULL,
  `description` varchar(81) NOT NULL,
  `price` int(255) NOT NULL,
  `buyers` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `shipments` (
  `id` int(11) NOT NULL,
  `sidmerchant` varchar(17) NOT NULL,
  `name` varchar(27) NOT NULL,
  `description` varchar(81) NOT NULL,
  `wep` varchar(255) NOT NULL,
  `wepname` varchar(255) NOT NULL,
  `price` int(255) NOT NULL,
  `amount` int(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `ads`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `entities`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `players`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `serverinfo`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `service`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `shipments`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `ads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `entities`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `serverinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `service`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `shipments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
]]

if GBayMySQLInfo then
  local GBayMySQLInfoL = sql.Query("SELECT * FROM gbaymysqlinfo")
  local GBayMySQLHost = GBayMySQLInfoL[1].hostname
  local GBayMySQLUsername = GBayMySQLInfoL[1].username
  local GBayMySQLPassword = GBayMySQLInfoL[1].password
  local GBayMySQLDatabase = GBayMySQLInfoL[1].database
  local GBayMySQLPort = GBayMySQLInfoL[1].port

  GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
  if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr .. "\n")
  else
    GBayMySQL:Query("SELECT * FROM players", function(result)
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database...\n")
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Currently stores...\n")
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] " .. #result[1].data .. " players\n")
      GBayRefreshSettings()
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Logging Server...\n")
      http.Post("http://xxlmm13xxgaming.com/addons2/libs/serverposting/serveradd.php",{sname = tostring(GetHostName()), aid = "GBay", sip = game.GetIPAddress(), sid = "Unknown"},function(body)
          print(body)
      end,function(error)
          print(error)
      end)
      timer.Create("GBayServerStats",60 * 10,0,function()
          http.Post("http://xxlmm13xxgaming.com/addons2/libs/serverposting/serveradd.php",{sname = tostring(GetHostName()), aid = "GBay", sip = game.GetIPAddress(), sid = "Unknown"},function(body)
              print(body)
          end,function(error)
              print(error)
          end)
      end)
    end)
  end

  GBayMySQL:Query(GBayMySQLCreateTables, function(createtableresult)
    if createtableresult[1].status == false then print("GBay MySQL Error: " .. createtableresult[1].error) end
  end)

end

net.Receive("GBaySetMySQL",function(len, ply)
  if ply:IsSuperAdmin() then
    local HostEntry = SQLStr(net.ReadString(), true)
    local UsernameEntry = SQLStr(net.ReadString(), true)
    local PasswordEntry = SQLStr(net.ReadString(), true)
    local DatabaseEntry = SQLStr(net.ReadString(), true)
    local PortEntry = net.ReadFloat()

    if GBayMySQLInfo != false then
      sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
      GBayMySQLInfotest = sql.Query("INSERT INTO gbaymysqlinfo (hostname, username, password, database, port) VALUES ('" .. HostEntry .. "', '" .. UsernameEntry .. "', '" .. PasswordEntry .. "', '" .. DatabaseEntry .. "', '" .. PortEntry .. "')")
    else
      sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
      sql.Query("UPDATE gbaymysqlinfo SET hostname='" .. HostEntry .. "', username='" .. UsernameEntry .. "', password='" .. PasswordEntry .. "', database='" .. DatabaseEntry .. "', port='" .. PortEntry .. "')")
    end

    local GBayMySQLHost = HostEntry
    local GBayMySQLUsername = UsernameEntry
    local GBayMySQLPassword = PasswordEntry
    local GBayMySQLDatabase = DatabaseEntry
    local GBayMySQLPort = PortEntry
    GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
    if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
      MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
      MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr .. "\n")
      net.Start("GBayCloseSetMySQL")
        net.WriteBool(false)
        net.WriteString(GBayErr)
      net.Send(ply)
      timer.Simple(5,function()
        net.Start("GBaySetMySQL")
        net.Send(ply)
      end)
    else
        timer.Create("GBayEnterMySQLStuff",1,0,function()
            local GBayMySQLInfotest2 = sql.Query("SELECT * FROM gbaymysqlinfo")
            print(GBayMySQLInfotest2)
            if GBayMySQLInfotest2 == nil or GBayMySQLInfotest2 == false then
                if GBayMySQLInfo != false then
                    sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
                    sql.Query("INSERT INTO gbaymysqlinfo (hostname, username, password, database, port) VALUES ('" .. HostEntry .. "', '" .. UsernameEntry .. "', '" .. PasswordEntry .. "', '" .. DatabaseEntry .. "', '" .. PortEntry .. "')")
                    MsgC(Color(255,0,0), "GBay mysql saved!\n")
                else
                    sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
                    sql.Query("UPDATE gbaymysqlinfo SET hostname='" .. HostEntry .. "', username='" .. UsernameEntry .. "', password='" .. PasswordEntry .. "', database='" .. DatabaseEntry .. "', port='" .. PortEntry .. "')")
                    MsgC(Color(255,0,0), "GBay mysql saved!\n")
                end
            else
                timer.Remove("GBayEnterMySQLStuff")
                MsgC(Color(255,0,0), "GBay mysql saved!\n")
            end
        end)
        if GBayMySQLInfo != false then
          sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
          GBayMySQLInfotest = sql.Query("INSERT INTO gbaymysqlinfo (hostname, username, password, database, port) VALUES ('" .. HostEntry .. "', '" .. UsernameEntry .. "', '" .. PasswordEntry .. "', '" .. DatabaseEntry .. "', '" .. PortEntry .. "')")
        else
          sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
          sql.Query("UPDATE gbaymysqlinfo SET hostname='" .. HostEntry .. "', username='" .. UsernameEntry .. "', password='" .. PasswordEntry .. "', database='" .. DatabaseEntry .. "', port='" .. PortEntry .. "')")
        end
      GBayMySQL:Query(GBayMySQLCreateTables, function(createtableresult)
        if createtableresult[1].status == false then print("GBay MySQL Error: " .. createtableresult[1].error) end
        GBayMySQL:Query("SELECT * FROM players", function(result)
          MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database... Currently stores " .. #result[1].data .. " players!\n")
          net.Start("GBayCloseSetMySQL")
          net.WriteBool(true)
          net.WriteString("")
          net.Send(ply)
          MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Logging Server...\n")
          http.Post("http://xxlmm13xxgaming.com/addons2/libs/serverposting/serveradd.php",{sname = tostring(GetHostName()), aid = "GBay", sip = game.GetIPAddress(), sid = ply:SteamID64()},function(body)
              print(body)
          end,function(error)
              print(error)
          end)
        end)
      end)
    end
  end
  timer.Create("GBayServerStats",60 * 10,0,function()
      http.Post("http://xxlmm13xxgaming.com/addons2/libs/serverposting/serveradd.php",{sname = tostring(GetHostName()), aid = "GBay", sip = game.GetIPAddress(), sid = ply:SteamID64()},function(body)
          print(body)
      end,function(error)
          print(error)
      end)
  end)
end)

concommand.Add("mysqlcheck",function()
  GBayMySQLInfo = sql.Query("SELECT * FROM gbaymysqlinfo")
  print(GBayMySQLInfo)
end)
