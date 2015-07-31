_ = require 'underscore'
Widget = require '../widget.coffee'
template = require './template.html'
style = require './style.sass'


class ListItem
    constructor: (item) ->
        {
            @name
            @comment
            @thumbnail
            @uri
        } = item


class ListAuthor
    constructor: (author) ->
        {
            @username
            @avatar
            @uri
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
        @list = new List data, @options


module.exports = ListWidget
