{date-range} = require \../storyboard-controls.ls
require! \moment
{map} = require \prelude-ls
{{div}:DOM, create-class, create-factory} = require \react
require! \pipe-storyboard
Layout = create-factory pipe-storyboard.Layout
Story = create-factory pipe-storyboard.Story
StoryboardWrapper = create-factory require \./StoryboardWrapper.ls

module.exports = create-class do 

  display-name: \Trend

  # render :: a -> ReactElement
  render: ->
    StoryboardWrapper do
      cache: 2 * 60 * 60
      controls: 
        * date-range default-value: '1 year'

        * name: \bucketSize
          label: 'Bucket size'
          type: \select
          options: ['1 day', '3 days', '1 week', '1 month']
          default-value: '1 day'
          parameters-from-ui-value: (value) ->
            [count, unit] = value.split ' '
            bucket-size: moment.duration (parse-int count), unit .as-milliseconds!

        * name: \sampleSize
          label: 'Sample size'
          type: \number
          default-value: 20
          client-side: true
        ...
      location: @props.location
      record: @props.record
      
      Layout do 
        style:
          display: \flex
          flex-direction: \column

        # MESSAGES
        Layout do 
          display: \flex

          # TREND
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 300
            branch-id: \prKNieS

          # GROWTH
          Story do 
            style:
              flex: 1
              height: 300
            branch-id: \prKRT94

        # USERS
        Layout do 
          display: \flex

          # TREND
          Story do 
            style:
              border-right: '1px solid #ccc'
              flex: 1
              height: 300
            branch-id: \prMlql1

          # GROWTH
          Story do 
            style:
              flex: 1
              height: 300
            branch-id: \prKzXdM

        # USERS ONLINE - TREND
        Story do 
          style:
            border-top: '1px solid #ccc'
            height: 500
          branch-id: \prKTpYa

        # POPULARITY TREND (in terms of count of messages)
        Layout do 
          style:
            display: \flex
            flex-direction: \column
          extras:
            limit: 10
            show-legend: true

          # CHANNELS 
          Story do 
            style:
              border-right: '1px solid #ccc'
              height: 500
            title: "Channel popularity (in terms of # of messages) - Trend"
            extras:
              fieldname: \channelName
            branch-id: \prKRkKP

          # USERS
          Story do 
            style:
              height: 500
            title: "Top contributers (in terms of # of messages) - Trend"
            extras:
              fieldname: \username
            branch-id: \prKRkKP