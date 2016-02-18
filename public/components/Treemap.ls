{date-range} = require \../storyboard-controls.ls
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
{render} = require \react-dom
require! \pipe-storyboard
StoryWrapper = create-factory require \./StoryWrapper.ls
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Treemap

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
      StoryWrapper do 
        show-title: false
        branch-id: \pBsY8gu