express  = require 'express'
cors = require 'cors'
compress = require 'compression'

app = express()


log = (req, res, next) ->
    req.started = new Date()
    console.log "[Request started] ", "---------------------\n", req.started
    next()


endlog = (req, res, next) ->
    ended = new Date()
    duration = ended.getTime() - req.started.getTime()
    console.log "[Request ended] ", "----------------------\n", duration
    next()

app.use log
app.use cors()
app.use compress()
app.use log
app.use express.static './public'
app.use '/lists', require './routes/lists'
app.use endlog

app.get '/async/:id', (req, res) ->
    res.render 'async.jade', id: req.params.id
app.get '/sync/:id', (req, res) ->
    res.render 'sync.jade', id: req.params.id

port = process.env.PORT or 3000
server = app.listen port, ->
    console.log "Listening on port:", server.address().port
