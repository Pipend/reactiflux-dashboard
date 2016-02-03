require! \moment
{id} = require \prelude-ls
{create-factory} = require \react
DateRange = create-factory require \./components/DateRange.ls

# to-gmt :: String -> String
to-gmt = (local-datetime) -> 
    (moment local-datetime, 'YYYY-MM-DDTHH:mm' .utc-offset 0 .format 'YYYY-MM-DDTHH:mm:ss') + \Z

# :: Map String, Control, where Control is used in Storyboard components
module.exports = 

    # channel-selector :: {channels :: [String], multi :: Boolean} -> Control
    channel-selector: ({channels, multi}?) ->
        label = "channel#{if multi then 's' else ''}"
        name: \channel
        label: label
        type: \select
        placeholder: "Select #{label}"
        options: channels ? []
        multi: multi ? true

    # date-range :: {default-value :: String, ranges :: [String]} -> Control
    date-range: ({default-value, ranges}) ->
        default-from-date = moment!.subtract 3, \month .format \YYYY-MM-DDTHH:mm
        default-to-date = moment!.format \YYYY-MM-DDTHH:mm

        name: \Range
        default-value: 
            ago: default-value
            from-date: default-from-date
            to-date: default-to-date

        ui-value-from-state: ({ago, from, to}?) -> 
            {ago, from, to}

        state-from-ui-value: ({ago, from, to}:ui-value) ->
            if ago == \custom then ui-value else {ago}
            
        parameters-from-ui-value: ({ago, from, to}) ->
            if ago == \custom 
                ago: ""
                from: to-gmt from
                to: to-gmt to

            else 
                {from: null, to: null, ago}

        render: (value, on-change) ~>
            DateRange {} <<< value <<< 
                ranges: ranges ? ['1 day', '1 week', '1 month', '3 months', '1 year', 'custom']
                on-change: (patch) ~> on-change {} <<< value <<< patch

    # username-selector :: () -> Control
    username-selector: ->
        name: \username
        label: \username
        type: \text
        default-value: ""