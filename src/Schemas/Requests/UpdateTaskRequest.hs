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

module Schemas.Requests.UpdateTaskRequest where

import Data.Text as T
import GHC.Generics

import Mu.Quasi.GRpc
import Mu.Schema

grpc "TodoSchema" id "todolist.proto"

data UpdateTaskRequest = UpdateTaskRequest { 
        taskId :: T.Text, 
        description :: T.Text, 
        finished :: Bool 
    }
    deriving ( Eq, Show, Generic
             , ToSchema   TodoSchema "UpdateTaskRequest"
             , FromSchema TodoSchema "UpdateTaskRequest" )
