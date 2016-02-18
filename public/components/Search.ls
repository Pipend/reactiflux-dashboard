{get-channels} = require \../api.ls
{channel-selector, date-range, username-selector} = require \../storyboard-controls.ls
{map} = require \prelude-ls
{{a, div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Layout = create-factory pipe-storyboard.Layout
StoryWrapper = create-factory require \./StoryWrapper.ls
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Search

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      cache: false
      controls: 
        * date-range default-value: '1 year'

        * name: \searchString
          label: \search
          type: \text
          placeholder: "Regex works to"
          default-value: ""

        * username-selector!

        * channel-selector channels: @state.channels

        * name: \limit
          label: \limit
          type: \number
          default-value: 100
        ...
      location: @props.location
      record: @props.record
      
      StoryWrapper do 
        branch-id: \pBoHVpe
        show-title: false
        ref: \story

  get-initial-state: ->
    channels: []

  # component-will-mount :: () -> ()
  component-will-mount: !->
    get-channels! .then ~> @set-state channels: it
