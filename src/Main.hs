{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language AllowAmbiguousTypes        #-}

module Main where

import Mu.GRpc.Server
import Mu.Server

import Repository.Connection ( Connection, connection )
import Control.Monad.Trans ( liftIO )

import Schema as S ( Service )

import Services.AddTaskService ( addTask )
import Services.GetTasksService ( getTasks )
import Services.UpdateTaskService ( updateTask )
import Services.DeleteTaskService ( deleteTask )

import LoadEnv
import System.Environment (lookupEnv)

main :: IO ()
main = do
    loadEnv
    (Just mongoHost) <- lookupEnv "MONGO_HOST"
    (Just dbName)    <- lookupEnv "MONGO_DB_NAME"
    (Just username)  <- lookupEnv "MONGO_USERNAME"
    (Just password)  <- lookupEnv "MONGO_PASSWORD"
    (Just port)  <- lookupEnv "PORT"
    
    conn <- liftIO $ connection dbName username password mongoHost
    print $ "Server Running in port " <> port

    let appPort = read port :: Int
    runGRpcApp msgProtoBuf appPort (server conn)

server :: Connection -> ServerIO info S.Service _
server conn = singleService (method @"AddTask" (addTask conn),
                        method @"GetTasks" (getTasks conn),
                        method @"UpdateTask" (updateTask conn),
                        method @"DeleteTask" (deleteTask conn))