express = require 'express'
request = require 'request-promise'
browserify = require 'browserify'
through = require 'through2'

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


cache = {}
lists.get '/:id/embed.js', (req, res, next) ->
    id = req.params.id

    res.send cache[id] if id of cache

    resolve = (list) ->
        b = browserify('./coffee/static.coffee')

        b.transform (file) ->
            through (buf, enc, next) ->
                @push buf.toString('utf-8').replace(/\$LIST/g, JSON.stringify list)
                next()

        b.transform 'coffeeify'
        b.transform 'sassify'
        b.transform 'stringify'

        b.on 'error', console.error

        b.bundle (err, src) ->
            return next(err) if err

            res.send cache[id] = src

    reject = (error) ->
        console.error error
        console.log "It took to error", new Date() - start
        res.status(404).json error

    console.log "Asking for list"
    List.get(id).then resolve, reject

module.exports = lists
