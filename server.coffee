# TODO make an index template so public is more disposable?

express  = require 'express'
cors = require 'cors'
app = express()

app.use cors()
app.use express.static 'public'
app.use '/lists', require './routes/lists'

server = app.listen process.env.port or 3000, ->
    console.log "Listening on port:", server.address().port
