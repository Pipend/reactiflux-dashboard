require! \../../config.ls
{{div}:DOM, create-class, create-factory} = require \react
require! \react-router
{hash-history} = react-router
require! \pipe-storyboard
Storyboard = create-factory pipe-storyboard.Storyboard

module.exports = create-class do 

  display-name: \StoryboardWrapper

  # get-default-props :: () -> Props
  get-default-props: ->
    # cache :: Boolean
    # class-name :: String
    # controls :: [Control]
    # location :: object
    # record :: Event -> ()
    {}

  # render :: () -> ReactElement
  render: ->
    Storyboard do 
      url: config.pipe.url
      cache: @props.cache
      class-name: @props.class-name
      state: @props.location.query

      # on-change :: StoryboardState -> ()
      on-change: (new-state) ~> 
        hash-history.replace do 
          pathname: @props.location.pathname
          query: new-state
          state: new-state

      # on-execute :: Parameters -> ()
      on-execute: (parameters, will-execute) !~>
        @props.record do 
          event-type: \execute
          event-args: {parameters, will-execute}

      # on-reset :: () -> ()
      on-reset: !~>
        @props.record do
          event-type: \reset

      controls: @props.controls
      
      @props.children

