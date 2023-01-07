{-# language OverloadedStrings #-}
{-# language ExtendedDefaultRules #-}
{-# language DeriveGeneric #-}
{-# language NamedFieldPuns #-}

module Repository.Repository where

import Data.Text (Text, unpack)
import Database.MongoDB
import Data.AesonBson
import Data.Aeson (Object, FromJSON, ToJSON, decode, encode)
import Control.Exception
import Repository.Connection (Connection)

import Schemas.Responses.Task as R

findTasks (pipe, dbName) storyId page limit = do
    results <- access pipe master dbName (
        rest =<< find
            (select ["storyId" =: unpack storyId] "todolist")
            {sort = [], limit = limit, skip = page}
        )
    let obj = map (aesonify)  results
    let (Just tasks) = (decode . encode) obj :: (Maybe [R.Task])
    return tasks

findOneTask (pipe, dbName) query = do
    (Just insertedResult) <- access pipe master dbName
        (findOne 
            (select query "todolist"))
    let obj = aesonify $ insertedResult
    let (Just task) = (decode . encode) obj :: (Maybe R.Task)
    return task
    

insertTask :: Connection -> Text -> Text -> IO R.Task
insertTask (pipe, dbName) storyId description = do
    let insertionData = [
            "storyId" =: storyId,
            "description" =: description,
            "finished" =: False
            ]

    insertedId <- access pipe master dbName
        (insert "todolist" insertionData)

    insertedResult <- findOneTask (pipe, dbName) ["_id" =: insertedId]

    return insertedResult
    