require! \../../config.ls
{last} = require \prelude-ls
{clone-element, create-class, create-factory, DOM:{div}}:React = require \react
{render} = require \react-dom
require! \react-router
Router = create-factory react-router.Router
Route = create-factory react-router.Route
IndexRoute = create-factory react-router.IndexRoute
Link = create-factory react-router.Link

require! \./SearchRoute.ls

App = create-class do

    display-name: \App

    # render :: a -> ReactElement
    render: ->
        div null,

            # ROUTES
            div null,

                # pass spy.record method as props to child component
                clone-element @props.children, {} <<< config <<< 
                    record: @state.record

            div {class-name: \building}, \Building... if @state.building

    # get-initial-state :: a -> UIState
    get-initial-state: -> 
        building: false
        record: (->)

    # component-did-mount :: a -> Void
    component-will-mount: !->
        if !!config?.gulp?.reload-port
            (require \socket.io-client) "http://localhost:#{config.gulp.reload-port}"
                ..on \build-start, ~> @set-state building: true
                ..on \build-complete, -> window.location.reload!

        if !!config?.spy?.enabled

            {get-load-time-object, record} = (require \spy-web-client) do 
                url: config.spy.url
                common-event-properties : ~> 
                    pathname: @props.location.pathname
                    
            <~ @set-state {record}

            # record page-ready event            
            get-load-time-object (load-time-object) ~>
                record do 
                    event-type: \load
                    event-args: load-time-object

            # record clicks
            @click-listener = ({target, type, page-x, page-y}:e?) ~>

                # find-parent-id :: DOMElement -> String
                find-parent-id = (element) ->
                    return switch
                        | element.parent-element == null => \unknown
                        | typeof element.id == \string and element.id.length > 0 => element.id
                        | _ => find-parent-id element.parent-element

                record do
                    event-type: \click
                    event-args:
                        type: type 
                        element:
                            parent-id: find-parent-id target
                            id: target.id
                            class: target.class-name
                            client-rect: target.get-bounding-client-rect!
                            tag: target.tag-name
                        x: page-x
                        y: page-y

            document.add-event-listener \click, @click-listener

    # component-will-unmount :: a -> Void
    component-will-unmount: !-> 
        if !!@click-listener
            document.remove-event-listener \click, @click-listener 

<- window.add-event-listener \load
<- set-timeout _, 0

render do 
    Router do 
        history: react-router.browser-history
        Route do 
            name: \app
            path: \/
            component: App
            IndexRoute component: SearchRoute
            Route name: \search, path: \/search, component: SearchRoute
    document.get-element-by-id \mount-node