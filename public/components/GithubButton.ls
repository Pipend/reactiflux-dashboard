require! \jsonp
{create-class, DOM:{a, div, span}}:React = require \react
{find-DOM-node} = require \react-dom
require \./GithubButton.styl

module.exports = create-class do 

    # Size :: small | large
    # Type :: star | fork | watch
    # get-default-props :: () -> {author :: String, repository :: String, type :: Type}
    get-default-props: ->
        author: ""
        repository: ""
        type: \star

    # render :: () -> ReactElement
    render: ->
        repository-url = "https://github.com/#{@props.author}/#{@props.repository}"

        [button-url, count-url] = switch @props.type 
            | \fork => ["#{repository-url}/fork", "#{repository-url}/network"]
            | \star => [repository-url, "#{repository-url}/stargazers"]
            | \watch => [repository-url, "#{repository-url}/watchers"]

        span do 
            class-name: "github-btn github-btn-large"

            a do 
                class-name: \gh-btn
                href: button-url
                target: \_blank

                # ICON
                span class-name: "gh-ico #{@props.type}"

                # TEXT
                span do 
                    class-name: \gh-text
                    @props.type

            if @state.count-ready

                # COUNT
                a do 
                    class-name: \gh-count
                    href: count-url
                    target: \_blank
                    switch @props.type
                        | \fork => @state.forks
                        | \star => @state.stars
                        | \watch => @state.watchers

    # get-initial-state :: () -> UIState
    get-initial-state: ->
        forks: 0
        stars: 0
        watchers: 0
        count-ready: false

    # component-will-mount :: () -> ()
    component-will-mount: ->
        err, result <~ jsonp do 
            "https://api.github.com/repos/#{@props.author}/#{@props.repository}"
            {}
        {forks_count, stargazers_count, watchers_count}? = result?.data
        @set-state do 
            count-ready: true
            forks: forks_count
            stars: stargazers_count
            watchers: watchers_count