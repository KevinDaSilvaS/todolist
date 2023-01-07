{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications      #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes   #-}

module Services.AddTaskService where

import Mu.Server
import Repository.Connection ( Connection )
import Repository.Repository ( insertTask )

import Schemas.Requests.AddTaskRequest as AddTask

addTask conn AddTask.AddTaskRequest {
    AddTask.storyId,
    AddTask.description
    } = alwaysOk $ do insertTask conn storyId description