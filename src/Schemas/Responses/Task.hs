{-# language DataKinds             #-}
{-# language DeriveAnyClass        #-}
{-# language DeriveGeneric         #-}
{-# language DuplicateRecordFields #-}
{-# language FlexibleContexts      #-}
{-# language FlexibleInstances     #-}
{-# language MultiParamTypeClasses #-}
{-# language PolyKinds             #-}
{-# language TemplateHaskell       #-}
{-# language TypeFamilies          #-}
{-# language TypeOperators         #-}

module Schemas.Responses.Task where

import Data.Text as T ( pack, Text )
import GHC.Generics ( Generic )

import Mu.Quasi.GRpc ( grpc )
import Mu.Schema ( FromSchema, ToSchema )

import Data.Aeson
    ( (.:),
      withObject,
      object,
      FromJSON(parseJSON),
      KeyValue((.=)),
      ToJSON(toJSON) )

grpc "TodoSchema" id "todolist.proto"

data Task = Task {
    storyId :: T.Text,
    taskId :: T.Text,
    description :: T.Text,
    finished :: Bool
    }
    deriving ( Eq, Show, Generic
             , ToSchema   TodoSchema "Task"
             , FromSchema TodoSchema "Task" )

instance ToJSON Task where
    toJSON Task {
                storyId = storyId,
                taskId = taskId,
                description = description,
                finished = finished
        } = object [
                T.pack "_id" .= taskId
                , T.pack "storyId" .= storyId
                , T.pack "description" .= description
                , T.pack "finished" .= finished
            ]

instance FromJSON Task where
    parseJSON = withObject "Task" $ \obj -> do
            storyId <- obj .: T.pack "storyId"
            taskId <- obj .: T.pack "_id"
            description <- obj .: T.pack "description"
            finished <- obj .: T.pack "finished"
            return (Task {
                storyId = storyId,
                taskId = taskId,
                description = description,
                finished = finished
            })

data Tasks = Tasks { tasks :: [Task] }
    deriving ( Eq, Show, Generic
            , ToSchema   TodoSchema "Tasks"
            , FromSchema TodoSchema "Tasks" )

data DeleteResult = DeleteResult { success :: Bool }
    deriving ( Eq, Show, Generic
            , ToSchema   TodoSchema "DeleteResult"
            , FromSchema TodoSchema "DeleteResult" )