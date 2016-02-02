{date-range} = require \../storyboard-controls.ls
require! \moment
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Layout = create-factory pipe-storyboard.Layout
Story = create-factory pipe-storyboard.Story
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Fame

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      cache: 3600
      controls: 
        * date-range default-value: '1 day'
        ...
      location: @props.location
      record: @props.record

      Layout do
        style: 
          display: \flex
          flex-direction: \column

        Layout do 
          style:
            display: \flex
            border-bottom: '1px solid #ccc'

          # TOP CONTRIBUTORS (# of messages)
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 600
            branch-id: \prKNvF7

          # MOST ACTIVE CHANNELS
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 600
            branch-id: \prKPlop

        Layout do 
          style:
            display: \flex
            border-bottom: '1px solid #ccc'

          # MOST MENTIONED USER
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 600
            branch-id: \prKPBde

          # TOP MENTIONERS
          Story do 
            style:
              flex: 1
              height: 600
            branch-id: \prSJLMt

        Layout do 
          style:
            display: \flex
            border-bottom: '1px solid #ccc'

          # MOST THANKED USERS
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 600
            branch-id: \prVXRlo

          # MOST THANKFUL USERS
          Story do 
            style:
              flex: 1
              height: 600
            branch-id: \prVYb0r
            
        # EMOJIS
        Story do 
          style:
            height: 600
          branch-id: \prY4ZLz