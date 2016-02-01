require! \browserify
require! \gulp
require! \gulp-nodemon
require! \gulp-if
require! \gulp-livescript
{instrument, hook-require, write-reports} = (require \gulp-livescript-istanbul)!
require! \gulp-mocha
require! \gulp-streamify
require! \gulp-stylus
require! \gulp-uglify
require! \gulp-util
require! \nib
{basename, dirname, extname} = require \path
require! \run-sequence
source = require \vinyl-source-stream
require! \watchify
{once} = require \underscore
config = require \./config.ls

io = null

# emit-with-delay :: String -> IO()
emit-with-delay = (event) ->
    if !!io
        set-timeout do 
            -> io.emit event
            200


# build styles in components
gulp.task \build:components:styles, ->
    gulp.src <[./public/components/App.styl]>
    .pipe gulp-stylus {use: nib!, import: <[nib]>, compress: config.gulp.minify, "include css": true}
    .pipe gulp.dest './public/components'
    .on \end, -> emit-with-delay \build-complete if !!io

# watch styles in components
gulp.task \watch:components:styles, -> 
    gulp.watch <[./public/components/*.styl]>, <[build:components:styles]>

# create a browserify Bundler
# create-bundler :: [String] -> Bundler
create-bundler = (entries) ->
    bundler = browserify {} <<< watchify.args <<< debug: !config.gulp.minify
        ..add entries
        ..transform \liveify

# outputs a single javascript file (which is bundled and minified - depending on env)
# bundler :: Bundler -> {file :: String, directory :: String} -> IO()
bundle = (bundler, {file, directory}:output) ->
    bundler.bundle!
        .on \error, -> gulp-util.log arguments
        .pipe source file
        .pipe gulp-if config.minify, (gulp-streamify gulp-uglify!)
        .pipe gulp.dest directory


# build-and-watch :: Bundler -> {file :: String, directory :: String} -> (() -> Void) -> (() -> Void) -> (() -> Void)
build-and-watch = (bundler, {file}:output, done, on-update, on-build) ->
    # must invoke done only once
    once-done = once done

    watchified-bundler = watchify bundler

    # build once
    bundle watchified-bundler, output

    watchified-bundler
        .on \update, -> 
            if !!on-update
                on-update!
            bundle watchified-bundler, output
        .on \time, (time) ->
            if !!on-build
                on-build!
            once-done!
            gulp-util.log "#{file} built in #{time / 1000} seconds"

components-bundler = create-bundler [\./public/components/App.ls]

app-js = file: "App.js", directory: "./public/components/"

gulp.task \build:components:scripts, ->
    bundle components-bundler, app-js

gulp.task \build-and-watch:components:scripts, (done) ->
    build-and-watch do 
        components-bundler
        app-js
        done
        -> emit-with-delay \build-start
        -> emit-with-delay \build-complete

gulp.task \dev:server, ->
    if !!config?.gulp?.reload-port
        io := (require \socket.io)!
            ..listen config.gulp.reload-port

    gulp-nodemon do
        exec-map: ls: \lsc
        ext: \ls
        ignore: <[gulpfile.ls README.md *.sublime-project public/* node_modules/* migrations/*]>
        script: \./server.ls

gulp.task \coverage, ->
    gulp.src <[./routes.ls]> # files which we want coverage report
    .pipe instrument!
    .pipe hook-require!
    .on \finish, ->
        gulp.src <[./test/index.ls]>
        .pipe gulp-mocha!
        .pipe write-reports!
        .on \finish, -> process.exit!

gulp.task \build, <[build:components:styles build:components:scripts]>
gulp.task \default, -> run-sequence do 
    <[
        build:components:styles 
        watch:components:styles 
        build-and-watch:components:scripts
    ]>
    \dev:server 