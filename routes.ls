{map} = require \prelude-ls

module.exports = ->
    <[/]> |> map (path) -> [path, \get, path, (req, res) -> res.render 'public/index.html']