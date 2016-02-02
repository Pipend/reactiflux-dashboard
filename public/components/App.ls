{map} = require \prelude-ls
{clone-element, create-class, create-factory, DOM:{a, div}}:React = require \react
{render} = require \react-dom
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
            * path: <[/ /trend]>
              title: 'Trend'

            * path: <[/search]>
              title: 'Search'

            * path: <[/activity]>
              title: 'Activity'

            * path: <[/cloud]>
              title: 'Word Cloud'

            * path: <[/fame]>
              title: 'Hall of fame'
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
                    menu-items |> map ({path, title}) ~>

                        # MENU ITEM
                        Link do 
                            key: title
                            to: path.0
                            class-name: switch
                                | @props.location.pathname in path => \highlight
                                | _ => undefined
                            title

                div do 
                    class-name: \github-buttons

                    # STAR
                    a do 
                        class-name: \github-button
                        href: \https://github.com/Pipend/reactiflux-dashboard
                        \data-icon : \octicon-star
                        \data-style : \mega
                        \data-count-href : \/Pipend/reactiflux-dashboard/stargazers
                        \data-count-api : \/repos/Pipend/reactiflux-dashboard#stargazers_count
                        \data-count-aria-label : '# stargazers on GitHub'
                        \aria-label : "Star Pipend/reactiflux-dashboard on GitHub"
                        \Star

                    # FORK
                    a do 
                        class-name: \github-button
                        href: \https://github.com/Pipend/reactiflux-dashboard/fork
                        \data-icon : \octicon-repo-forked
                        \data-style : \mega
                        \data-count-href : \/Pipend/reactiflux-dashboard/network
                        \data-count-api : \/repos/Pipend/reactiflux-dashboard#forks_count
                        \data-count-aria-label : '# forks on GitHub'
                        \aria-label : "Fork Pipend/reactiflux-dashboard on GitHub"
                        \Fork

            # ROUTES
            div class-name: \routes,

                # pass spy.record method as props to child component
                clone-element @props.children, {} <<< record: @props.record