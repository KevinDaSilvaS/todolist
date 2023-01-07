{-# language OverloadedStrings #-}
{-# language ExtendedDefaultRules #-}
{-# language DeriveGeneric #-}
{-# language NamedFieldPuns #-}

module Repository.Repository where

import Data.Text
import Database.MongoDB
import Data.AesonBson
import Data.Aeson (Object, FromJSON, ToJSON, decode, encode)
import Control.Exception
import Repository.Connection (Connection)

import Schemas.Responses.Task as R

findOneTask query = do
    findOne 
        (select query "todolist")

insertTask :: Connection -> Text -> Text -> IO R.Task
insertTask (pipe, dbName) storyId description = do
    let insertionData = [
            "storyId" =: storyId,
            "description" =: description,
            "finished" =: False
            ]

    insertedId <- access pipe master dbName
        (insert "todolist" insertionData)

    (Just insertedResult) <- access pipe master dbName
        (findOneTask ["_id" =: insertedId])

    let obj = aesonify $ insertedResult
    let (Just task) = (decode . encode) obj :: (Maybe R.Task)
    print task
    return task
    