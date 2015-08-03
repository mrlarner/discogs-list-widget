express  = require 'express'
cors = require 'cors'
compress = require 'compression'

app = express()

app.use cors()
app.use compress()
app.use express.static './public'
app.use '/lists', require './routes/lists'

port = process.env.PORT or 3000
server = app.listen port, ->
    console.log "Listening on port:", server.address().port
