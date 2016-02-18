require! \clipboard
{{a, div}:DOM, create-class, create-factory} = require \react
{find-DOM-node} = require \react-dom
require! \pipe-storyboard
Story = create-factory pipe-storyboard.Story
require! \querystring

Links = create-factory create-class do 

  # get-default-props :: () -> Props
  get-default-props: ->
    # query-id :: String
    # branch-id :: String
    # url :: String
    # cache :: Boolean
    # parameters :: object
    # refresh :: Boolean -> ()
    {}

  # render :: () -> ReactElement
  render: ->
    {query-id, branch-id, url, cache, parameters} = @props
    segment = if branch-id then "branches/#{branch-id}" else "queries/#{query-id}"
    div do 
      class-name: \links

      # EDIT
      a do 
        href: "#{url}/#{segment}"
        target: \blank
        'Edit'

      # SHARE
      a do 
        href: "#{url}/apis/#{segment}/execute/false/presentation?#{querystring.stringify parameters}"
        target: \blank
        'Share'

      # EXPORT JSON
      a do 
        href: "#{url}/apis/#{segment}/execute/false/transformation?#{querystring.stringify parameters}"
        target: \blank
        'JSON'

      # REFRESH
      a do 
        on-click: (e) ~>
          @props.refresh false
          e.stop-propagation!
          e.prevent-default!
          false
        'Refresh'

  # component-did-mount :: () -> ()
  component-did-mount: !->
    # new clipboard find-DOM-node @refs.parameters

module.exports = create-class do 

  display-name: \StoryWrapper

  # render :: () -> ReactElement
  render: ->
    Story {} <<< @props <<<

      ref: \story

      # render-links :: object -> ReactElement
      render-links: ~>
        Links {} <<< it <<< refresh: @refs?.story?.refresh
        

  
