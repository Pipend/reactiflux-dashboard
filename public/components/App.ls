{map} = require \prelude-ls
{clone-element, create-class, create-factory, DOM:{a, div, iframe}}:React = require \react
{find-DOM-node, render} = require \react-dom
GithubButton = create-factory require \./GithubButton.ls
require! \react-router
Link = create-factory react-router.Link
require \./App.styl

module.exports = create-class do 

    display-name: \App

    # get-default-props :: () -> Props
    get-default-props: ->
        record: (->)

    # render :: a -> ReactElement
    render: ->
        menu-items = 
            * path: <[/ /search]>
              title: 'Search'
            
            * path: <[/fame]>
              title: 'Hall of fame'
              
            * path: <[/trend]>
              title: 'Trend'

            * path: <[/punch]>
              title: 'Punch card'

            * path: <[/treemap]>
              title: 'Tree map'

            * path: <[/cloud]>
              title: 'Word cloud'

            * path: <[/dead]>
              title: 'Dead channels'
            ...

        div class-name: \app,

            # MENU
            div do 
                class-name: \menu

                # LOGO
                Link do
                    class-name: \logo
                    to: \/
                    'Reactiflux on Discord'

                # NAV
                div do 
                    class-name: \nav

                    # ORANGE BAR
                    div do 
                        class-name: \bar, ref: \bar

                    menu-items |> map ({path, title}) ~>
                        highlight = @props.location.pathname in path

                        # MENU ITEM
                        Link do 
                            key: title
                            to: path.0
                            class-name: if highlight then \highlight else undefined
                            ref: if highlight then \highlight else undefined
                            title

                # GITHUB BUTTONS
                div do 
                    class-name: \github-buttons
                    <[star fork]> |> map ~>
                        GithubButton do
                            key: it
                            author: \pipend
                            repository: \pipe 
                            type: it

            # ROUTES
            div class-name: \routes,

                # pass spy.record method as props to child component
                clone-element @props.children, {} <<< record: @props.record

    # updated-bar-location :: () -> ()
    update-bar-location: !->
        bar = find-DOM-node @refs.bar 
        highlight = find-DOM-node @refs.highlight
        bar.style <<<
            left: highlight.offset-left
            width: highlight.offset-width

    # component-did-mount :: () -> ()
    component-did-mount: !-> @update-bar-location!

    # component-did-update :: () -> ()
    component-did-update: !-> @update-bar-location!
        