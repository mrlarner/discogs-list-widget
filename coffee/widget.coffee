_ = require 'underscore'
Promise = require 'promise'
request = require 'browser-request'

renderTemplate = (template, data)->
    try
        return _.template(template)(data)
    catch error
        throw error

WIDGET_STATUS =
    LOADING: "loading"
    LOADED: "loaded"
    ERROR: "error"

class WidgetException extends Error
    constructor: (@message) ->
        @name = "WidgetException"
    toString: -> "#{@name}: #{@message}"

class Widget
    constructor: (@element, @id) ->
        @options = @parse_options @element.attributes

        # Initial render
        @render()

        # Fetch data from @endpoint

        promise = new Promise (resolve, reject) =>
            request @endpoint(), (error, response, body) ->
                if response.status < 300
                    try
                        resolve JSON.parse body
                    catch error
                        reject error
                else
                    reject body

        success = (data) => @loaded data; @render()
        fail = (error) => @failed error

        promise.then success, fail

    status: WIDGET_STATUS.LOADING

    endpoint: -> "/"

    template: -> ""

    render: ->
        console.log "trying to render"
        try
            html = renderTemplate @template(), @
        catch error
            @failed error.message

        container = document.getElementById "discogs-list-#{@id}"
        container.parentNode.removeChild(container) if container

        if @element.insertAdjacentHTML
            @element.insertAdjacentHTML "beforebegin", html
        else
            @failed "no insertAdjacentHTML"

    loaded: (data) ->
        console.debug "Responded with", data
        @status = WIDGET_STATUS.LOADED

    failed: (message) ->
        console.log "All kinda fail", message
        @status = WIDGET_STATUS.ERROR
        throw new WidgetException message

    parse_options: (attributes) ->
        options = {}
        _.each @element.attributes, (attr) ->
            { name, value } = attr
            if name.startsWith 'data-discogs'
                name = name.replace "data-discogs-", ""
                name = name.replace "-", "_"

                value = true if value is "" or value is "true"
                value = false if value is "false" or value is "0"

                options[name] = value
        options

module.exports = Widget
