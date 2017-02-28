require("tmysql4")
local GBayMySQLInfo = sql.Query("SELECT * FROM gbaymysqlinfo")
if GBayMySQLInfo then
  local GBayMySQLInfo = sql.Query("SELECT * FROM gbaymysqlinfo")
  local GBayMySQLHost = GBayMySQLInfo[1].hostname
  local GBayMySQLUsername = GBayMySQLInfo[1].username
  local GBayMySQLPassword = GBayMySQLInfo[1].password
  local GBayMySQLDatabase = GBayMySQLInfo[1].database
  local GBayMySQLPort = GBayMySQLInfo[1].port
  GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
  if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr.."\n")
  else
    GBayMySQL:Query("SELECT * FROM players", function(result)
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database...\n")
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Currently stores...\n")
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] "..#result[1].data.." players\n")
      GBayRefreashSettings()
    end)
  end
end

net.Receive("GBaySetMySQL",function(len, ply)
  if ply:IsSuperAdmin() then
    local HostEntry = net.ReadString()
    local UsernameEntry = net.ReadString()
    local PasswordEntry = net.ReadString()
    local DatabaseEntry = net.ReadString()
    local PortEntry = net.ReadFloat()

    if GBayMySQLInfo != false then
      sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
      sql.Query("INSERT INTO gbaymysqlinfo (hostname, username, password, database, port) VALUES ('"..HostEntry.."', '"..UsernameEntry.."', '"..PasswordEntry.."', '"..DatabaseEntry.."', '"..PortEntry.."')")
    else
      sql.Query("CREATE TABLE IF NOT EXISTS gbaymysqlinfo ( hostname VARCHAR( 64 ), username VARCHAR( 64 ), password VARCHAR( 64 ), database VARCHAR( 64 ), port VARCHAR( 64 ) )")
      sql.Query("UPDATE gbaymysqlinfo SET hostname='"..HostEntry.."', username='"..UsernameEntry.."', password='"..PasswordEntry.."', database='"..DatabaseEntry.."', port='"..PortEntry.."')")
    end

    local GBayMySQLHost = HostEntry
    local GBayMySQLUsername = UsernameEntry
    local GBayMySQLPassword = PasswordEntry
    local GBayMySQLDatabase = DatabaseEntry
    local GBayMySQLPort = PortEntry
    GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
    if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
      MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
      MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr.."\n")
      net.Start("GBayCloseSetMySQL")
        net.WriteBool(false)
        net.WriteString(GBayErr)
      net.Send(ply)
      print(GBayMySQLHost)
      print(GBayMySQLUsername)
      print(GBayMySQLPassword)
      print(GBayMySQLDatabase)
      print(GBayMySQLPort)
      timer.Simple(5,function()
        net.Start("GBaySetMySQL")
        net.Send(ply)
      end)
    else
      GBayMySQL:Query("SELECT * FROM players", function(result)
        MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database... Currently stores "..#result[1].data.." players!\n")
        net.Start("GBayCloseSetMySQL")
          net.WriteBool(true)
          net.WriteString("")
        net.Send(ply)
        MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Logging Server...\n")
        http.Post("http://xxlmm13xxgaming.com/addons/data/serveradd.php",{sid = "gbay", sip = game.GetIPAddress(), sdate=tostring(os.time()), soid = ply:SteamID64()},function(body)
          print(body)
        end,function(error)
          print(error)
        end)
      end)
    end
  end
end)

--concommand.Add("gbayresetmysql",function()
--  sql.Query("DROP TABLE gbaymysqlinfo")
--  GBayMySQLInfo = sql.Query("SELECT * FROM gbaymysqlinfo")
--  print(GBayMySQLInfo)
--end)
