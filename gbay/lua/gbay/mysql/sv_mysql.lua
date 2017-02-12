require("tmysql4")
if file.Exists("gbay/mysql.txt","DATA") then
  local GBayMySQLInfo = util.JSONToTable(file.Read("gbay/mysql.txt", "DATA" ))
  local GBayMySQLHost = GBayMySQLInfo.host
  local GBayMySQLUsername = GBayMySQLInfo.username
  local GBayMySQLPassword = GBayMySQLInfo.password
  local GBayMySQLDatabase = GBayMySQLInfo.database
  local GBayMySQLPort = GBayMySQLInfo.port
  GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
  if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr.."\n")
  else
    GBayMySQL:Query("SELECT * FROM players", function(result)
      MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database... Currently stores "..#result[1].data.." players!\n")
    end)
  end
end

net.Receive("GBaySetMySQL",function(len, ply)
  local HostEntry = net.ReadString()
  local UsernameEntry = net.ReadString()
  local PasswordEntry = net.ReadString()
  local DatabaseEntry = net.ReadString()
  local PortEntry = net.ReadFloat()

  local GBayMySQLInfo = {}
  GBayMySQLInfo['host'] = HostEntry
  GBayMySQLInfo['username'] = UsernameEntry
  GBayMySQLInfo['password'] = PasswordEntry
  GBayMySQLInfo['database'] = DatabaseEntry
  GBayMySQLInfo['port'] = PortEntry

  if !file.Exists("gbay","DATA") then
    file.CreateDir("gbay")
  end
  file.Write("gbay/mysql.txt", util.TableToJSON(GBayMySQLInfo))
  local GBayMySQLHost = GBayMySQLInfo.host
  local GBayMySQLUsername = GBayMySQLInfo.username
  local GBayMySQLPassword = GBayMySQLInfo.password
  local GBayMySQLDatabase = GBayMySQLInfo.database
  local GBayMySQLPort = GBayMySQLInfo.port
  GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLHost, GBayMySQLUsername, GBayMySQLPassword, GBayMySQLDatabase, GBayMySQLPort, nil, CLIENT_MULTI_STATEMENTS )
  if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
    MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr.."\n")
    net.Start("GBayCloseSetMySQL")
      net.WriteBool(false)
      net.WriteString(GBayErr)
    net.Send(ply)
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
end)
