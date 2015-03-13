var path = require('path'),
    webpack = require('webpack'),
    ExtractTextPlugin = require('extract-text-webpack-plugin'),
    PathRewriter = require('webpack-path-rewriter')


var env = process.env, opts = {
  dstDir: env.DST_DIR || path.join(__dirname, '_dist'),
  dev: strToBool(env.DEV, true),
  livereload: strToBool(env.LIVERELOAD, false),
  hot: process.argv.indexOf('--hot') != -1,
  hash: strToBool(env.HASH, false),
  uglify: strToBool(env.UGLIFY, false)
}


module.exports = {
  entry: {
    app: [
      opts.hot && 'webpack/hot/dev-server',
      './scripts/main'
    ]
    .filter(skipFalsy)
  }
  ,
  output: {
    path: opts.dstDir,
    filename: opts.hash ? '[name]-[chunkhash].js' : '[name]-dev.js',
    pathinfo: opts.dev
  }
  ,
  resolve: {
    extensions: ['', '.js', '.json', '.jsx', '.coffee']
  }
  ,
  devtool: 'source-map'
  ,
  debug: opts.dev
  ,
  module: {
    loaders: [
      {
        test: /[.]jsx?$/,
        exclude: /node_modules/,
        loader: 'babel?optional=runtime'
      },
      {
        test: /[.]coffee$/,
        exclude: /node_modules/,
        loader: 'coffee'
      },
      {
        test: /[/]styles[/][^/]+[.]css$/,
        loader: styleLoader('css')
      },
      {
        test: /[/]styles[/][^/]+[.]styl$/,
        loader: styleLoader('css!stylus')
      },
      {
        test: /[.]jade$/,
        loader: PathRewriter.rewriteAndEmit({
          name: '[path][name].html',
          loader: 'jade-html?' + JSON.stringify({ pretty: true, opts: opts })
        })
      },
      {
        test: /[.]html$/,
        loader: PathRewriter.rewriteAndEmit({ name: '[path][name].[ext]' })
      },
      {
        test: /[/]assets[/]/,
        exclude: /[.](jade|html)$/,
        loader: 'file?name=' + (opts.hash ? '[path][name]-[hash].[ext]' : '[path][name]-dev.[ext]')
      }
    ]
  }
  ,
  plugins: [
    !opts.dev && new webpack.DefinePlugin({
      'process.env': {
        // This has effect on the react lib size
        'NODE_ENV': '"production"'
      }
    })
    ,
    new webpack.optimize.OccurenceOrderPlugin()
    ,
    !opts.hot && new ExtractTextPlugin(
      opts.hash ? '[name]-[contenthash].css' : '[name]-dev.css',
      { allChunks: true }
    )
    ,
    new PathRewriter({
      includeHash: opts.livereload,
      emitStats: false,
      silent: false
    })
    ,
    opts.uglify && new webpack.optimize.UglifyJsPlugin()
  ]
  .filter(skipFalsy)
}

/*
 * TODO: enable CSS source maps in hot mode when
 * https://github.com/webpack/css-loader/issues/29
 * get fixed
 */
function styleLoader(loader) {
  return opts.hot
    ? 'style!' + loader
    : ExtractTextPlugin.extract(loader.replace(/(?:^|!)[^!]*/g, '$&?sourceMap'))
}


function strToBool(val, def) {
  if (val == undefined)
    return def
  val = val.toLowerCase()
  return val == '1' || val == 'true' || val == 'yes' || val == 'y'
}


function skipFalsy(item){
  return !!item
}
