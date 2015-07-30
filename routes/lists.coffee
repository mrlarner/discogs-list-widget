express = require 'express'
Discogs = require('disconnect').Client

lists = express.Router()

log = (req, res, next) ->
    console.log "\n\nLists:", req.route,  "---------------------\n", new Date
    next()

mockResponse =
    list:
        name: "A List, B, List"
        description: "<p>My list of things.</p>"
        author:
            username: "sixy"
            url: "http://discogs.com/sixy"
            avatar_src: "http://www.gravatar.com/avatar/e6af92408baacecb540ea1d05ed091a7?s=100"
        items: [
            title: "Windowlicker"
            comment: "<p>Nothing more to say</p>"
            image_src: "http://17seconds.co.uk/blog/wp-content/uploads/2014/01/Windowlicker.jpg"
        ,
            title: "Selected Ambient Works 85-92"
            comment: "<p>I LOVE this!</p>"
            image_src: "http://ecx.images-amazon.com/images/I/415-ZDopaZL.jpg"
        ]

lists.get "/", (req, res) ->
    res.json [ mockResponse ]

lists.get /\/(\d+)$/, (req, res) ->
    setTimeout ->
        res.json mockResponse
    , 5000

lists.use log

module.exports = lists
