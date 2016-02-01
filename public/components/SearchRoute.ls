require! \../../config.ls
require! \moment
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
{render} = require \react-dom
require! \react-router
{browser-history} = react-router
require! \pipe-storyboard
Layout = create-factory pipe-storyboard.Layout
Story = create-factory pipe-storyboard.Story
Storyboard = create-factory pipe-storyboard.Storyboard
DateRange = create-factory require \./DateRange.ls

module.exports = create-class do 

  display-name: \SearchRoute

  # render :: a -> ReactElement
  render: ->
    default-from-date = moment!.subtract 3, \month .format \YYYY-MM-DDTHH:mm
    from-date = @props.location.query?.from ? default-from-date

    default-to-date = moment!.format \YYYY-MM-DDTHH:mm
    to-date = @props.location.query?.to ? default-to-date

    Storyboard do 
      url: config.pipe.url
      cache: config.pipe.cache
      state: @props.location.query

      # on-change :: StoryboardState -> ()
      on-change: (new-state) ~> 
        browser-history.replace do 
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

      controls: 
        * name: \Range
          default-value: 
            ago: '1 year'
            from-date: default-from-date
            to-date: default-to-date
          ui-value-from-state: ({ago, from, to}) -> {ago, from, to}
          state-from-ui-value: ({ago, from, to}) -> {ago, from, to}
          parameters-from-ui-value: ({ago, from, to}) ->
            if ago == \custom then {ago: "", from, to} else {from: null, to: null, ago}
          render: (value, on-change) ~>
            DateRange do 
              {} <<< value <<< on-change: (patch) ~> 
                on-change {} <<< value <<< patch

        * name: \searchString
          label: \search
          type: \text
          placeholder: "Regex works too"
          default-value: ""

        * name: \username
          label: \username
          type: \text
          default-value: ""

        * name: \channel
          label: \channel
          type: \select
          placeholder: 'Select channels'
          options: @state.channels
          multi: true

        * name: \limit
          label: \limit
          type: \number
          default-value: 100
        ...
      Story branch-id: \pBoHVpe

  get-initial-state: ->
    channels: []

  # component-will-mount :: () -> ()
  component-will-mount: !->
    fetch "#{config.pipe.url}/apis/branches/pBtfJqR/execute/#{config.pipe.cache}/transformation"
      .then (.json!)
      .then ~> @set-state channels: it
