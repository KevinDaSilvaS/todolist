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

module Schemas.Requests.GetTasksRequest where

import Data.Text as T
import GHC.Generics

import Mu.Quasi.GRpc
import Mu.Schema

grpc "TodoSchema" id "todolist.proto"

data GetTasksRequest = GetTasksRequest { storyId :: T.Text }
    deriving ( Eq, Show, Generic
             , ToSchema   TodoSchema "GetTasksRequest"
             , FromSchema TodoSchema "GetTasksRequest" )
