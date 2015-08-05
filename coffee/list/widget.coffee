_ = require 'underscore'
{ StaticWidget, Widget } = require '../widget.coffee'
template = require './template.html'
style = require './style.sass'
config = require '../../config.coffee'

class ListItem
    constructor: (item) ->
        {
            @name
            @comment
            @thumbnail
            @uri
            @position
        } = item

        @position++

    format_name: ->
        [ heading, subheading ] = @name.split(' - ')
        { heading, subheading }

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
            @uri
            items
            author
        } = list

        @author = new ListAuthor author
        @items = _.map items, (item) -> new ListItem item

        @items.reverse() if @options.reverse


class Paginator
    constructor: (options) ->
        {
            @items
            @per_page
        } = options

        @per_page = @per_page ? 5
        @max_pages = Math.ceil @items.length / @per_page
        @current = 1
        @should_render = @items.length > @per_page
        @show_more = @items.length > @per_page
        console.log @

    page: -> @items.slice @current-1, @current+@per_page-1

    next: -> @current++ if @current < @max_pages

    previous: -> @current-- if @current  > 1

    more: (n) ->
        if @per_page + n <= @items.length
            @current = 1
            @per_page += n
            @show_more = @items.length > @per_page
            @per_page

class ListWidget extends Widget
    endpoint: -> "#{config.lists.base_uri}/lists/#{@id}"
    template: -> template
    style: style
    loaded: (data) ->
        super(data)
        @list = new List data, @options
        @paginator = new Paginator(items: @list.items, per_page: 1)
        @container.addEventListener 'click', _.bind @onClick, @
    onClick: (e) ->
        { target } = e

        if target.tagName.toLowerCase() is 'button'

            if target.getAttribute('rel') is 'previous'
                @render() if @paginator.previous()

            else if target.getAttribute('rel') is 'next'
                @render() if @paginator.next()

            else if target.getAttribute('rel') is 'more'
                @render() if @paginator.more(1)

class StaticListWidget extends StaticWidget
    template: -> template
    style: style
    loaded: (data) ->
        super(data)
        @list = new List data, @options

module.exports = { ListWidget, StaticListWidget }
