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

module Schemas.Requests.DeleteTaskRequest where

import Data.Text as T
import GHC.Generics

import Mu.Quasi.GRpc
import Mu.Schema

grpc "TodoSchema" id "todolist.proto"

data DeleteTaskRequest = DeleteTaskRequest { 
        taskId :: T.Text
    }
    deriving ( Eq, Show, Generic
             , ToSchema   TodoSchema "DeleteTaskRequest"
             , FromSchema TodoSchema "DeleteTaskRequest" )
