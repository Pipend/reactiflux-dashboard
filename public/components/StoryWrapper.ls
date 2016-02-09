{{a, div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Story = create-factory pipe-storyboard.Story
require! \querystring

module.exports = create-class do 

  display-name: \StoryWrapper

  # render :: () -> ReactElement
  render: ->
    Story {} <<< @props <<<

      ref: \story

      # render-links :: object -> ReactElement
      render-links: ({query-id, branch-id, url, cache, parameters}) ~>
        segment = if branch-id then "branches/#{branch-id}" else "queries/#{query-id}"
        div do 
          class-name: \links

          # EDIT
          a do 
            href: "#{url}/#{segment}"
            target: \blank
            'Edit'

          # EXPORT JSON
          a do 
            href: "#{url}/apis/#{segment}/execute/false/transformation?#{querystring.stringify parameters}"
            target: \blank
            'JSON'

          # REFRESH
          a do 
            on-click: (e) ~>
              @refs.story.refresh false
              e.stop-propagation!
              e.prevent-default!
              false
            'Refresh'


