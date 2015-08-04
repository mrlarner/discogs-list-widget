browserify = require 'browserify'
through = require 'through2'
{ Router } = require 'express'
Promise = require 'promise'
List = require '../models/list'

lists = Router()


# browserify transform for adding list data to bundle
listify = (file) ->
    through = require 'through2'
    through (buf, enc, next) ->
        @push buf.toString('utf-8').replace(/\$LIST/g, JSON.stringify list)
        next()


# browserify bundle promise
bundlify = (file) ->
    new Promise (resolve, reject) ->
        b = browserify('./coffee/static.coffee', {debug: true})

        b.plugin('minifyify', {map: 'bundle.map.json'})
        b.transform listify
        b.transform 'coffeeify'
        b.transform 'sassify'
        b.transform 'stringify'
        b.transform 'envify'

        b.on 'error', (error) -> reject error

        b.bundle (err, src) ->
            reject err if err
            resolve src


cache = (path, contents) ->
    mkdirp = require("mkdirp")
    fs = require("fs")
    {dirname} = require("path")

    path = "./public/lists#{path}"
    console.log "Caching file #{path}"
    dir = dirname path

    write = (p, c) -> fs.writeFile path, contents

    if fs.exists dir
        console.log "dir already exists"
        write()
    else
        mkdirp dir, write
        console.log "dir does not exist"

lists.use (req, res, next) ->
    req.reject = (error) -> res.status(404).json error
    next()

lists.use '/:id', (req, res, next) ->
    req.list_id = req.params.id if 'id' of req.params
    next()

lists.get '/:id', (req, res) ->
    resolve = (list) -> res.json list

    List.get(req.list_id).then resolve, req.reject


lists.get '/:id/embed.js', (req, res, next) ->
    bundle_resolve = (bundle) ->
        cache req.path, bundle
        res.send bundle

    resolve = (list) -> bundlify().then bundle_resolve, req.reject

    List.get(req.list_id).then resolve, req.reject

module.exports = lists
