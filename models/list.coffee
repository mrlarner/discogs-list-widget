request = require 'request-promise'
promise = require 'promise'

base_uri = "http://api.matthax-list-api-enpoints.spinner.10.10.10.57.xip.io"
user_agent = "ListWidgetAPI/1.0"

extend = (object, properties) ->
  for key, val of properties
    object[key] = val
  object


Resource = (options) ->
    request extend options, {
        baseUrl: base_uri
        headers:
            "User-Agent": user_agent
    }


cache = {}


class List
    @get: (id) ->
        return Promise.resolve cache[id] if id of cache

        new Promise (resolve, reject) ->
            list = Resource {
                uri: "/lists/#{id}"
            }
            list.then (data) ->
                cache[id] = JSON.parse data
                cache[id].cached = new Date
                resolve cache[id]
            list.catch ->
                console.error arguments
                reject { error: "No List" }

module.exports = List
