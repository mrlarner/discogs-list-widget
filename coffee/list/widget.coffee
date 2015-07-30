_ = require 'underscore'
Widget = require '../widget.coffee'
template = require './template.html'
style = require './style.sass'

# Widget Controller instantiates and renders

# Render should do an api get request promise

# Wrapper element should be inserted after script in render

# Treat widget state like React

# When something happense, re-render :\

# promise = fetch
# insert wrapper to dom
# promise.then re-render template after state change


class ListItem
    constructor: (item) ->
        {
            @title
            @comment
            @image_src
        } = item


class ListAuthor
    constructor: (author) ->
        {
            @username
            @avatar_src
            @url
        } = author


class List
    constructor: (list, @options) ->
        {
            @name
            @description
            items
            author
        } = list

        @author = new ListAuthor author
        @items = _.map items, (item) -> new ListItem item

        @items.reverse() if @options.reverse

class ListWidget extends Widget
    endpoint: -> "http://localhost:3000/lists/#{@id}"
    template: -> template
    style: style
    loaded: (data) ->
        super(data)
        @list = new List data.list, @options


module.exports = ListWidget
