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

class BaseWidget
    constructor: (@element, @id, data = {}) ->
        console.debug "BaseWidget parsing Options", @
        @options = @parse_options @element.attributes

        # Initial render
        @render()

        if not _.isEmpty data
            console.debug "Data passed"
            @loaded data
            @render()

    status: WIDGET_STATUS.LOADING

    template: -> ""

    render: ->
        console.log "trying to render"
        try
            html = renderTemplate @template(), @
        catch error
            @failed error.message

        @container = document.getElementById "discogs-list-#{@id}"
        if @container
            @container.innerHTML = html
        else
            # make container and insert html
            div = document.createElement 'div'
            div.id = "discogs-list-#{@id}"
            div.innerHTML = html
            @element.parentNode.insertBefore div, @element
            @container = document.getElementById "discogs-list-#{@id}"

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


class Widget extends BaseWidget
    constructor: (@element, @id) ->
        super @element, @id

        success = (data) => @loaded data; @render()
        fail = (error) => 
            try
                @failed error
            catch
                @render()

        promise = new Promise (resolve, reject) =>
            console.debug "Promising"
            request @endpoint(), (error, response, body) ->
                if response.status < 300
                    try
                        resolve JSON.parse body
                    catch error
                        reject error
                else reject body

        promise.then success, fail

    endpoint: -> "/"

class StaticWidget extends BaseWidget
    constructor: (@element, @id, data ={}) ->
        super @element, @id, data


module.exports = {StaticWidget, Widget }
