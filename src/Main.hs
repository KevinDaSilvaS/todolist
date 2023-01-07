{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications #-}
{-# language DataKinds #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes        #-}

module Main where

import Mu.GRpc.Server
import Mu.Server

import Repository.Connection
import Repository.Repository
import Control.Monad.Trans (liftIO)

import Schema as S
import Schemas.Requests.AddTaskRequest  as AddTask
import Schemas.Requests.GetTasksRequest as GetTasks
import Schemas.Requests.UpdateTaskRequest as UpTask
import Schemas.Requests.DeleteTaskRequest as DelTask
import Schemas.Responses.Task as T

main :: IO ()
main = do
    conn <- liftIO connection
    print "Server Running in port 8080"
    runGRpcApp msgProtoBuf 8080 (server conn)

addTask conn AddTask.AddTaskRequest {
    AddTask.storyId,
    AddTask.description
    } = alwaysOk $ do insertTask conn storyId description

getTasks conn (GetTasks.GetTasksRequest storyId) = alwaysOk $ do
        tasks <- findTasks conn storyId 0 50
        pure $ T.Tasks tasks

updateTask conn (UpTask.UpdateTaskRequest {
        UpTask.taskId,
        UpTask.description,
        UpTask.finished
    }) = alwaysOk $ do
            pure $ T.Task {
                T.storyId = "storyId",
                T.taskId = taskId,
                T.description = description,
                T.finished = finished
            }

deleteTask conn (DelTask.DeleteTaskRequest {DelTask.taskId}) =
    alwaysOk $ do
        pure $ T.DeleteResult {
            success = True
        }

server :: MonadServer m => Connection -> SingleServerT i S.Service m _
server conn = singleService (method @"AddTask" (addTask conn),
                        method @"GetTasks" (getTasks conn),
                        method @"UpdateTask" (updateTask conn),
                        method @"DeleteTask" (deleteTask conn))