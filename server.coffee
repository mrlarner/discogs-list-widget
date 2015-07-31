# TODO make an index template so public is more disposable?

express  = require 'express'
cors = require 'cors'
app = express()

app.use cors()
app.use express.static 'public'
app.use '/lists', require './routes/lists'

port = process.env.port or 3000
server = app.listen port, ->
    console.log "Listening on port:", server.address().port
