{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications      #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes   #-}

module Services.GetTasksService where

import Mu.Server
import Repository.Connection ( Connection )
import Repository.Repository ( findTasks )
import Schemas.Requests.GetTasksRequest as GetTasks
import Schemas.Responses.Task as T

getTasks conn (GetTasks.GetTasksRequest storyId) = alwaysOk $ do
        tasks <- findTasks conn storyId 0 50
        pure $ T.Tasks tasks
