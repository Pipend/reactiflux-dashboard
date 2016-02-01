require! \body-parser
{http-port}:config = require \./config
require! \express
{map, each} = require \prelude-ls

app = express!
    ..set \views, __dirname + \/
    ..engine \.html, (require \ejs).__express
    ..set 'view engine', \ejs
    ..use body-parser.json!
    ..use body-parser.urlencoded {extended: false}
    ..use \/node_modules, express.static "#__dirname/node_modules"
    ..use \/public, express.static "#__dirname/public"

(require \./routes) {}
    |> each ([, method]:route) -> app[method].apply app, route.slice 2

app.listen http-port
console.log "Started listening on port #{http-port}"