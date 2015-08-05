request = require 'request-promise'
promise = require 'promise'
{ lists } = require '../config'


base_uri = lists.base_uri
user_agent = lists.user_agent

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object


Resource = (options) ->
    defaults = {
        baseUrl: base_uri
        headers:
            "User-Agent": user_agent
    }
    console.log "Resource", extend(options, defaults)

    request extend options, defaults


class List
    @get: (id) ->
        new Promise (resolve, reject) ->
            list = Resource {
                uri: "/lists/#{id}"
            }
            list.then (data) ->
                setTimeout ->
                    resolve JSON.parse data
                , 1500
            list.catch -> reject { error: "No List", args: arguments }

module.exports = List
