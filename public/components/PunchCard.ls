{get-channels} = require \../api.ls
{channel-selector, date-range, username-selector} = require \../storyboard-controls.ls
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Layout = create-factory pipe-storyboard.Layout
StoryWrapper = create-factory require \./StoryWrapper.ls
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \PunchCard

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      class-name: \punch-card
      cache: false
      controls: 
        * channel-selector do 
            channels: @state.channels
            multi: false
        
        * username-selector!
        ...
      location: @props.location
      record: @props.record

      Layout do 
        style:
          dispaly: \flex
          flex-direction: \column


        # PUNCHCARD 
        StoryWrapper do 
          branch-id: \prPxyVK
          style:
            border-bottom: '1px solid #ccc'
            height: \50%

        Layout do 
          style:
            dispaly: \flex
            height: \50%

          # RADAR
          StoryWrapper do 
            branch-id: \ps7FmFo
            style:
              border-right: '1px solid #ccc'
              width: \50%

          # BAR CHART
          StoryWrapper do 
            branch-id: \prOEk7L
            style:
              width: \50%

  get-initial-state: ->
    channels: []

  # component-will-mount :: () -> ()
  component-will-mount: !->
    get-channels! .then ~> @set-state channels: it
