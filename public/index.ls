require! \../config.ls
{DOM:{div}, create-class, create-element, create-factory} = require \react
{render} = require \react-dom
require! \react-router
IndexRoute = create-factory react-router.IndexRoute
Route = create-factory react-router.Route
Router = create-factory react-router.Router
App = create-factory require \./components/App.ls
require! \./components/Cloud.ls
require! \./components/Fame.ls
require! \./components/DeadChannels.ls
require! \./components/PunchCard.ls
require! \./components/Search.ls
require! \./components/Treemap.ls
require! \./components/Trend.ls

# record :: Event -> ()
record = 
    | typeof config?.spy?.enabled == \undefined =>
    | _ =>
        {get-load-time-object, record} = (require \spy-web-client) url: config.spy?.url ? ""
        
        # record page-ready event            
        get-load-time-object (load-time-object) ->
            record do 
                event-type: \load
                event-args: load-time-object

        # record clicks
        document.add-event-listener \click, ({target, type, page-x, page-y}?) ~>
            record do
                event-type: \click
                event-args:
                    type: type 
                    element:
                        id: target.id
                        class: target.class-name
                        client-rect: target.get-bounding-client-rect!
                        tag: target.tag-name
                    x: page-x
                    y: page-y

        record

# HOC for event recording
AppWrapper = create-class do 

    # render :: () -> ReactElement
    render: -> 
        App do 
            record: (event) ~>
                record {} <<< event <<< pathname: @props.location.pathname
            location: @props.location
            @props.children

# HOC for recording route ready event
route-wrapper = (WrappedComponent) -> 
    
    create-class do 

        # render :: () -> ReactElement
        render: ->
            create-element WrappedComponent, @props

        # component-did-mount :: () -> ()
        component-did-mount: !->
            @props.record do 
                event-type: \route-ready
                event-args: 
                    component: WrappedComponent.display-name

render do 
    Router do 
        history: react-router.hash-history
        Route do 
            path: \/
            component: AppWrapper
            IndexRoute component: route-wrapper Search
            Route path: \/cloud, component: route-wrapper Cloud
            Route path: \/fame, component: route-wrapper Fame
            Route path: \/dead, component: route-wrapper DeadChannels
            Route path: \/punch, component: route-wrapper PunchCard
            Route path: \/search, component: route-wrapper Search
            Route path: \/treemap, component: route-wrapper Treemap
            Route path: \/trend, component: route-wrapper Trend
    document.get-element-by-id \mount-node