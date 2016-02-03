{map} = require \prelude-ls
{clone-element, create-class, create-factory, DOM:{a, div}}:React = require \react
{find-DOM-node, render} = require \react-dom
require! \react-router
Link = create-factory react-router.Link

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

            * path: <[/activity]>
              title: 'Activity'

            * path: <[/cloud]>
              title: 'Word Cloud'
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

                div do 
                    class-name: \github-buttons

                    # STAR
                    a do 
                        class-name: \github-button
                        href: \https://github.com/Pipend/pipe
                        \data-icon : \octicon-star
                        \data-style : \mega
                        \data-count-href : \/Pipend/pipe/stargazers
                        \data-count-api : \/repos/Pipend/pipe#stargazers_count
                        \data-count-aria-label : '# stargazers on GitHub'
                        \aria-label : "Star Pipend/pipe on GitHub"
                        \Star

                    # FORK
                    a do 
                        class-name: \github-button
                        href: \https://github.com/Pipend/pipe/fork
                        \data-icon : \octicon-repo-forked
                        \data-style : \mega
                        \data-count-href : \/Pipend/pipe/network
                        \data-count-api : \/repos/Pipend/pipe#forks_count
                        \data-count-aria-label : '# forks on GitHub'
                        \aria-label : "Fork Pipend/pipe on GitHub"
                        \Fork

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
        