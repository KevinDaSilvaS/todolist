{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables     #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes        #-}

module Main where

import Mu.GRpc.Server
import Mu.Server

import Schema as S
import Schemas.Requests.AddTaskRequest  as AddTask
import Schemas.Requests.GetTasksRequest as GetTasks
import Schemas.Responses.Task as T

main :: IO ()
main = do
    print "Server Running in port 8080" 
    runGRpcApp msgProtoBuf 8080 server

addTask (AddTask.AddTaskRequest {
    AddTask.storyId, 
    AddTask.description
    }) = alwaysOk $ do
    pure $ T.Task {
        T.storyId = storyId,
        taskId = storyId,
        T.description = description,
        finished = False
    }

getTasks (GetTasks.GetTasksRequest storyId) = alwaysOk $ do
        pure $ T.Tasks [ 
            T.Task {
                T.storyId = storyId,
                taskId = storyId,
                T.description = "description",
                finished = False
            },
            T.Task {
                T.storyId = storyId,
                taskId = storyId,
                T.description = "description",
                finished = True
            }]

server :: MonadServer m => SingleServerT i S.Service m _
server = singleService (method @"AddTask" addTask,
                        method @"GetTasks" getTasks)