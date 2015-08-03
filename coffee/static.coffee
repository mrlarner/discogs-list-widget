{ StaticListWidget } = require './list/widget.coffee'

attributeNamespace = 'data-discogs-widget'
selector = "[#{attributeNamespace}]"
widgets =
    list: 'list'

require('domready') ->

    script = document.querySelector selector

    return if not script

    [ type, id ] = script.getAttribute(attributeNamespace).split('-')

    try
        new StaticListWidget(script, id, $LIST) if type is widgets.list
    catch error
        console.error error

