require("tmysql4")
GBayMySQL, GBayErr = tmysql.initialize(GBayMySQLConfig.host, GBayMySQLConfig.username, GBayMySQLConfig.password, GBayMySQLConfig.database, GBayMySQLConfig.port, nil, CLIENT_MULTI_STATEMENTS )
if GBayErr != nil or tostring( type( GBayMySQL ) ) == "boolean" then
  MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error connecting to the database...\n")
  MsgC(Color(255, 255, 255), "[", Color(255, 0, 0), "GBay", Color(255, 255, 255), "] Error: ", Color(255,0,0), GBayErr.."\n")
else
  GBayMySQL:Query("SELECT * FROM players", function(result)
    MsgC(Color(255, 255, 255), "[", Color(0, 0, 255, 255), "GBay", Color(255, 255, 255), "] Connected to database... Currently stores "..#result[1].data.." players!\n")
  end)
end
