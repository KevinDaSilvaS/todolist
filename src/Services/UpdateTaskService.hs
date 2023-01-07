{-# language FlexibleContexts      #-}
{-# language PartialTypeSignatures #-}
{-# language OverloadedStrings     #-}
{-# language ScopedTypeVariables   #-}
{-# language TypeApplications      #-}
{-# OPTIONS_GHC -fno-warn-partial-type-signatures #-}
{-# language DataKinds             #-}
{-# language NamedFieldPuns        #-}
{-# language AllowAmbiguousTypes   #-}

module Services.UpdateTaskService where

import Mu.Server
import Repository.Connection ( Connection )
import Repository.Repository ( updateOneTask )
import Control.Monad.Trans ( liftIO )
import Schemas.Requests.UpdateTaskRequest as UpTask

updateTask conn UpTask.UpdateTaskRequest {
        UpTask.taskId,
        UpTask.description,
        UpTask.finished
    } = do
            liftIO $ updateOneTask conn [] description finished taskId
            if taskId == "" then
                serverError $ ServerError Invalid "taskId field is required"
            else do
                let fields = descriptionSet description ["finished"] 

                updateResult <- liftIO $ 
                    updateOneTask conn fields description finished taskId

                case updateResult of
                    (Left _) -> serverError $ 
                        ServerError Internal "Unable to update task"
                    (Right task) -> pure task
                
descriptionSet field fieldsList
    | field == "" = fieldsList
descriptionSet _ fieldsList = "description":fieldsList