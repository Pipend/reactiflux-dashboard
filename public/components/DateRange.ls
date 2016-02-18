require! \moment
{map} = require \prelude-ls
{{div, input, label}:DOM, create-class, create-factory} = require \react
{render} = require \react-dom
require! \react-selectize
SimpleSelect = create-factory react-selectize.SimpleSelect
LabelledComponent = create-factory (require \pipe-storyboard).LabelledComponent
require \react-selectize/themes/index.css
require \./DateRange.styl

module.exports = create-class do 

  display-name: \DateRange

  # get-default-props :: () -> Props
  get-default-props: ->
    ago: ""
    from: ""
    to: ""
    ranges: []

  # render :: a -> ReactElement
  render: ->
    div do 
      class-name: \date-range
      
      # AGO      
      LabelledComponent do 
        label: \Ago
        SimpleSelect do 
          value: 
            label: @props.ago
            value: @props.ago
          options: @props.ranges |> map ~> label: it, value: it
          on-value-change: ({value}, callback) ~>
            @props.on-change ago: value
            callback!

      if @props.ago == \custom

        # FROM & TO
        div do 
          null
          <[from to]> |> map (p) ~>
            LabelledComponent do
              key: p
              class-name: p
              label: p
              input do 
                type: \datetime-local
                value: @props[p]
                on-change: ({target:{value}}) ~>
                  @props.on-change "#{p}" : value
