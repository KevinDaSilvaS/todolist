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

main :: IO ()
main = do
    conn <- liftIO connection
    print "Server Running in port 8080"
    runGRpcApp msgProtoBuf 8080 (server conn)

server :: Connection -> ServerIO info S.Service _
server conn = singleService (method @"AddTask" (addTask conn),
                        method @"GetTasks" (getTasks conn),
                        method @"UpdateTask" (updateTask conn),
                        method @"DeleteTask" (deleteTask conn))