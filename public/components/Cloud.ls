{get-channels} = require \../api.ls
{channel-selector, date-range, username-selector} = require \../storyboard-controls.ls
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Story = create-factory pipe-storyboard.Story
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Cloud

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      class-name: \cloud
      cache: false
      controls: 
        * date-range do 
            default-value: '1 hour'
            ranges: ['5 minutes', '30 minutes', '1 hour', '3 hours', '6 hours', '1 day', '1 week']

        * channel-selector do 
            channels: @state.channels
            multi: false
        
        * username-selector!
        ...
      location: @props.location
      record: @props.record

      # TEXT CLOUD
      Story do 
        branch-id: \prKOyno
        show-title: false

  get-initial-state: ->
    channels: []

  # component-will-mount :: () -> ()
  component-will-mount: !->
    get-channels! .then ~> @set-state channels: it
