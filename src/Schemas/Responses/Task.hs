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

import Data.Text as T
import GHC.Generics

import Mu.Quasi.GRpc
import Mu.Schema

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

data Tasks = Tasks { tasks :: [Task] } 
    deriving ( Eq, Show, Generic
            , ToSchema   TodoSchema "Tasks"
            , FromSchema TodoSchema "Tasks" )

data DeleteResult = DeleteResult { success :: Bool } 
    deriving ( Eq, Show, Generic
            , ToSchema   TodoSchema "DeleteResult"
            , FromSchema TodoSchema "DeleteResult" )