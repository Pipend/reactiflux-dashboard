{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
StoryWrapper = create-factory require \./StoryWrapper.ls
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \DeadChannels

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      class-name: \dead-channels
      cache: false
      controls: 
        * type: \number
          name: 'distanceThreshold'
          label: 'Min. days'
          default-value: 7
          parameters-from-ui-value: (days) ->
            distance-threshold: days * 24 * 60 * 60 * 1000
        ...
      location: @props.location
      record: @props.record

      StoryWrapper do 
        branch-id: \pC819GT
        show-title: false