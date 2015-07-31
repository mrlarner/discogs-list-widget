express = require 'express'
request = require 'request-promise'

List = require '../models/list'

lists = express.Router()

log = (req, res, next) ->
    console.log "\n\nLists:", req.route,  "---------------------\n", new Date
    next()

lists.get /\/(\d+)$/, (req, res) ->
    console.log "Get List", 1
    List.get(1).then (list) ->
        console.log "Got List", list
        res.json list

lists.use log

module.exports = lists
