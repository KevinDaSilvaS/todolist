{-# language ExtendedDefaultRules #-}

module Repository.Connection where

import Data.Text( Text, pack )
import Database.MongoDB ( connect, host, access, auth, master, Pipe )

type Connection = (Pipe, Text)

connection :: String -> String -> String -> String -> IO (Pipe, Text)
connection dbName username password hostAddress = do
    let txtDbName    = pack dbName
    let txtUsername  = pack username
    let txtPassword  = pack password
    
    pipe <- connect (host hostAddress)
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    if isAuthenticated then do
        return (pipe, txtDbName)
    else
        error "Unable to connect to database"