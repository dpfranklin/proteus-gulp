gulp         = require 'gulp'
browsersync  = require 'browser-sync'
include      = require 'gulp-include'
concat       = require 'gulp-concat'
haml         = require 'gulp-ruby-haml'
sass         = require 'gulp-ruby-sass'
neat         = require('node-neat').includePaths
sourcemaps   = require 'gulp-sourcemaps'
coffee       = require 'gulp-coffee'
deploy       = require 'gulp-gh-pages'
_            = require 'lodash'
jade         = require 'gulp-jade'
shell        = require 'gulp-shell'
reload       = browsersync.reload

paths        =
  haml     : './source/views/*.haml'
  jade     : './source/views/*.jade'
  partials : './source/views/partials/_*.jade'
  coffee   : './source/assets/javascripts/**/*.coffee'
  scss     : './source/assets/stylesheets/**/*.scss'
  images   : './source/assets/images/*'
  fonts    : './source/assets/fonts/*'

urls      =
  local   : 'http://localhost:8000'
  staging : 'http://s3staging.com.s3-website-us-east-1.amazonaws.com'
  prod    : 'http://www.s3staging.com'

locals   =
  url    : urls.staging
  images : 'assets/images'
  css    : 'assets/stylesheets'
  js     : 'assets/javascripts'
  _      : _

# Haml templates
gulp.task 'haml', ->
  gulp.src(paths.haml).pipe(haml()).pipe gulp.dest('./build')
  return

# Jade templates
gulp.task 'jade', ->
  gulp.src(paths.jade)
    .pipe jade
      pretty: true
      locals: locals
    .pipe gulp.dest('./build')
    .pipe reload({stream: true})
    return

# Scss stylesheets
gulp.task 'stylesheets', ->
  sass(paths.scss,
    sourcemap: false
    loadPath: neat).on('error', sass.logError).pipe gulp.dest('./build/assets/stylesheets')

# Coffeescript
gulp.task 'javascripts', ->
  gulp.src(paths.coffee).pipe(sourcemaps.init()).pipe(include()).pipe(coffee()).pipe(sourcemaps.write()).pipe gulp.dest('./build/assets/javascripts')
coffeeStream = coffee(bare: true)
coffeeStream.on 'error', (err) ->

# Copy images
gulp.task 'images', ->
  gulp.src(paths.images).pipe gulp.dest('./build/assets/images')
  return

# Copy fonts
gulp.task 'fonts', ->
  gulp.src(paths.fonts).pipe gulp.dest('./build/assets/fonts')
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
  gulp.watch paths.jade, [ 'jade' ]
  gulp.watch paths.partials, [ 'jade' ]
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
  'haml'
  'jade'
  'stylesheets'
  'javascripts'
  'images'
  'fonts'
  'server'
  'watch'
], ->

gulp.task 'build', [
  'haml'
  'jade'
  'stylesheets'
  'javascripts'
  'images'
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


