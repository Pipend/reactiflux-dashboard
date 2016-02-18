require! \path
HtmlWebpackPlugin = require \html-webpack-plugin

module.exports = 
    entry: 
        * \./public/index.ls
        ...
    output:

        # this is the path where all the bundled (and/or minified) javascript will be saved by webpack
        # when invoked with -p switch (or when we make any changes to our codebase)
        path: \./public/build
        filename: \index.js

        # webpack-dev-server will serve built files at this path 
        # this is the path we will use to reference scripts in index.html file
        public-path: ""

    plugins:
        * new HtmlWebpackPlugin do
            title: 'Reactiflux on Discord'
            template: \public/index.html
        ...

    module:
        loaders:
            * test: /\JSONStream.*index.js$/
              loader: \string-replace
              query:
                search: '#! /usr/bin/env node'
                replace: ''

            * test: /\.ls$/
              loaders: <[react-hot livescript-loader]>

            * test: /\.css$/
              loader: "style-loader!css-loader"

            * test: /\.styl$/
              loader: "style-loader!css-loader!stylus-loader"

            * test: /\.(png|jpg)$/
              loader: "file?name=images/[name].[ext]"
            ...

    stylus:
        use: [(require \nib)!]
        import: ['~nib/lib/nib/index.styl']