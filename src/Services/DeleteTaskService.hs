{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications      #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes   #-}

module Services.DeleteTaskService where

import Mu.Server
import Repository.Connection ( Connection )
import Repository.Repository ( deleteOneTask )

import Schemas.Requests.DeleteTaskRequest as DelTask
import Schemas.Responses.Task as T

deleteTask conn DelTask.DeleteTaskRequest {DelTask.taskId} =
    alwaysOk $ do
        result <- deleteOneTask conn taskId
        pure $ T.DeleteResult {
            success = result
        }