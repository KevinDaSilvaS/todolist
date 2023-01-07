{-# language OverloadedStrings #-}
{-# language ExtendedDefaultRules #-}

module Repository.Repository where

import Data.Text (Text, unpack)
import Database.MongoDB
import Data.AesonBson (aesonify)
import Data.Aeson (decode, encode)
import Control.Exception
import Repository.Connection (Connection)

import Schemas.Responses.Task as R

findTasks :: Connection -> Text -> Limit -> Limit -> IO [R.Task]
findTasks (pipe, dbName) storyId page limit = do
    results <- access pipe master dbName (
        rest =<< find
            (select ["storyId" =: unpack storyId] "todolist")
            {sort = [], limit = limit, skip = page}
        )
    let obj = map (aesonify) results
    let (Just tasks) = (decode . encode) obj :: (Maybe [R.Task])
    return tasks

findOneTask :: Connection -> [Field] -> IO R.Task
findOneTask (pipe, dbName) query = do
    (Just insertedResult) <- access pipe master dbName
        (findOne
            (select query "todolist"))
    let obj = aesonify insertedResult
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

    findOneTask (pipe, dbName) ["_id" =: insertedId]

updateOneTask :: Connection -> [String] -> Text -> Bool -> Text -> IO (Either Bool R.Task)
updateOneTask (pipe, dbName) fields description finished taskId = do
        let _id = (read . unpack) taskId :: ObjectId

        let updateFields =  setFields fields description finished []
        let updateQuery = fetch
                (select ["_id" =: _id] "todolist")
                    >>= save "todolist" . merge updateFields
        updatedComments <- try
            (access pipe master dbName updateQuery) :: IO (Either SomeException ())

        case updatedComments of
            Left _ -> do
                return (Left False)
            Right _ -> do
                task <- findOneTask (pipe, dbName) ["_id" =: _id]
                return (Right task)

setFields :: [String] -> Text -> Bool -> [Field] -> [Field]
setFields [] _ _ updateFields = updateFields
setFields ("description":xs) description finished updateFields =
    setFields xs description finished newUpdateFields
    where
        newUpdateFields = ("description" =: description) : updateFields
setFields ("finished":xs) description finished updateFields =
    setFields xs description finished newUpdateFields
    where
        newUpdateFields = ("finished" =: finished) : updateFields

deleteOneTask :: (Pipe, Database) -> Text -> IO Bool
deleteOneTask (pipe, dbName) taskId = do
    let _id = (read . unpack) taskId :: ObjectId
    let deleteOperation = deleteOne (select ["_id" =: _id] "todolist")
    deleteResult <- try (access pipe master dbName
        deleteOperation) :: IO (Either SomeException ())
    case deleteResult of
        Left  _ -> return False
        Right _ -> return True
