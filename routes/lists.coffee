express = require 'express'
request = require 'request-promise'

List = require '../models/list'

lists = express.Router()


log = (req, res, next) ->
    console.log "\n\nLists:", "---------------------\n", new Date
    next()


lists.use(log)


lists.get '/:id', (req, res) ->
    console.log "Get List", req.params.id
    id = req.params.id
    start = new Date()

    resolve = (list) ->
        console.log "Got List", list
        console.log "It took", new Date() - start
        res.json list
    reject = (error) ->
        console.error error
        console.log "It took to error", new Date() - start
        res.status(404).json error

    List.get(id).then resolve, reject

module.exports = lists
