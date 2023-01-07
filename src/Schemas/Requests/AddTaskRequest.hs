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

module Schemas.Requests.AddTaskRequest where

import Data.Text as T ( Text )
import GHC.Generics ( Generic )

import Mu.Quasi.GRpc ( grpc )
import Mu.Schema ( FromSchema, ToSchema )

grpc "TodoSchema" id "todolist.proto"

data AddTaskRequest = AddTaskRequest { 
    storyId :: T.Text,
    description :: T.Text
    }
    deriving ( Eq, Show, Generic
             , ToSchema   TodoSchema "AddTaskRequest"
             , FromSchema TodoSchema "AddTaskRequest" )
