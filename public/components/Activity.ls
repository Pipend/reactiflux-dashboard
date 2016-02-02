{date-range} = require \../storyboard-controls.ls
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
{render} = require \react-dom
require! \pipe-storyboard
Story = create-factory pipe-storyboard.Story
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Activity

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do 
      cache: false
      controls: 
        * date-range do 
            default-value: '30 minutes'
            ranges: ['5 minutes', '30 minutes', '1 hour', '3 hours', '6 hours', '1 day']
        ...
      location: @props.location
      record: @props.record

      # TREE MAP
      Story do 
        style:
          border-right: '1px solid #ccc'
          flex: 1
        show-title: false
        branch-id: \pBsY8gu