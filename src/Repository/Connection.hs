--{-# language OverloadedStrings #-}
{-# language ExtendedDefaultRules #-}

module Repository.Connection where

import qualified Data.Text as T
import Database.MongoDB

type Connection = (Pipe, T.Text)

connection :: IO Connection
connection = do
    let txtDbName    = T.pack "admin"
    let txtUsername  = T.pack "user"
    let txtPassword  = T.pack "123"
    
    pipe <- connect (host "localhost")
    isAuthenticated <- access pipe master txtDbName (auth txtUsername txtPassword)
    print isAuthenticated
    if isAuthenticated then do
        return (pipe, txtDbName)
    else
        error "Unable to connect to database"