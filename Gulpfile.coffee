gulp         = require 'gulp'
browsersync  = require 'browser-sync'
include      = require 'gulp-include'
postcss      = require 'gulp-postcss'
autprefixer  = require 'autoprefixer'
concat       = require 'gulp-concat'
sass         = require 'gulp-sass'
bourbon      = require 'node-bourbon'
neat         = require 'node-neat'
sourcemaps   = require 'gulp-sourcemaps'
coffee       = require 'gulp-coffee'
deploy       = require 'gulp-gh-pages'
_            = require 'lodash'
pug          = require 'gulp-pug'
shell        = require 'gulp-shell'
webpack      = require 'webpack-stream'
reload       = browsersync.reload

paths        =
  haml     : './source/views/*.haml'
  pug      : './source/views/*.pug'
  partials : './source/views/partials/_*.pug'
  coffee   : ['./source/assets/javascripts/**/*.coffee', '!./source/assets/javascripts/**/_*.coffee']
  scss     : './source/assets/stylesheets/**/*.scss'
  images   : './source/assets/images/*'
  fonts    : './source/assets/fonts/**/*'
  root     : './source/root/*'


urls      =
  local   : 'http://localhost:8000'
  staging : 'http://s3staging.com.s3-website-us-east-1.amazonaws.com'
  prod    : 'http://www.s3staging.com'

locals   =
  url    : urls.local
  images : 'assets/images'
  css    : 'assets/stylesheets'
  js     : 'assets/javascripts'
  _      : _

# Pug templates
gulp.task 'pug', ->
  gulp.src(paths.pug)
    .pipe pug
      pretty: true
      locals: locals
    .pipe gulp.dest('./build')
    .pipe reload({stream: true})
    return

# Scss stylesheets
gulp.task 'stylesheets', ->
  gulp.src paths.scss
  .pipe sass(
    includePaths: neat.includePaths
    ).on('error', sass.logError)
  .pipe(postcss([
      require('autoprefixer')
    ]))
  .pipe gulp.dest('./build/assets/stylesheets')


# Coffeescript
gulp.task 'javascripts', ->
  gulp.src(paths.coffee)
    .pipe(sourcemaps.init())
    .pipe(include())
    .pipe(coffee())
    .pipe(sourcemaps.write())
    .pipe gulp.dest('./build/assets/javascripts')

coffeeStream = coffee(bare: true)
coffeeStream.on 'error', (err) ->


# Test Webpack Task
gulp.task 'webpack', ->
  gulp.src './source/assets/javascripts/_app2.js'
  .pipe webpack( require('./webpack.config.js') )
  .pipe gulp.dest('./build/assets/javascripts')
  .pipe reload({stream: true})

# Copy images
gulp.task 'images', ->
  gulp.src(paths.images)
    .pipe gulp.dest('./build/assets/images')
  return

# Copy fonts
gulp.task 'fonts', ->
  gulp.src(paths.fonts)
    .pipe gulp.dest('./build/assets/fonts')
  return

# Copy root assets
gulp.task 'root', ->
  gulp.src(paths.root)
  .pipe gulp.dest('./build')
  .pipe reload({stream: true})
  return

# Server
gulp.task 'server', ->
  browsersync
    server: baseDir: './build'
    port: 8000
    notify: true
    open: false
  return
gulp.task 'watch', ->
  gulp.watch paths.haml, [ 'haml' ]
  gulp.watch paths.pug, [ 'pug' ]
  gulp.watch paths.partials, [ 'pug' ]
  gulp.watch paths.scss, [ 'stylesheets' ]
  gulp.watch paths.coffee, [ 'javascripts' ]
  gulp.watch paths.images, [ 'images' ]
  gulp.watch paths.fonts, [ 'fonts' ]
  gulp.watch './build/*.html', browsersync.reload
  gulp.watch './build/assets/stylesheets/*.css', browsersync.reload
  gulp.watch './build/assets/javascripts/*.js', browsersync.reload
  gulp.watch './build/assets/images/*', browsersync.reload
  gulp.watch './build/assets/fonts/*', browsersync.reload
  return

# Run
gulp.task 'default', [
  'webpack'
  'pug'
  'stylesheets'
  'javascripts'
  'images'
  'fonts'
  'root'
  'server'
  'watch'
], ->

gulp.task 'build', [
  'pug'
  'stylesheets'
  'javascripts'
  'images'
  'root'
  'fonts'
  ], ->

# Deploy to s3 using installed s3_website gem: https://github.com/laurilehmijoki/s3_website
gulp.task 's3', shell.task([
  's3_website push'
])

gulp.task 's3-force', shell.task([
  's3_website push --force'
])

gulp.task 's3-deploy', [
    'build'
    's3'
  ], ->

gulp.task 's3-force-deploy', [
    'build'
    's3-force'
  ], ->

# Deploy
gulp.task 'gh-deploy', ->
  gulp.src('./build/**/*').pipe deploy(branch: 'master')


