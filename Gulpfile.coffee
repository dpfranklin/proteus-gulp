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
reload       = browsersync.reload

paths        =
  haml   : './source/views/*.haml'
  jade   : './source/views/*.jade'
  coffee : './source/assets/javascripts/**/*.coffee'
  scss   : './source/assets/stylesheets/**/*.scss'
  images : './source/assets/images/*'
  fonts  : './source/assets/fonts/*'

locals   =
  url: 'http://localhost'
  _: _

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
    port: 4000
    notify: false
    open: false
  return
gulp.task 'watch', ->
  gulp.watch paths.haml, [ 'haml' ]
  gulp.watch paths.jade, [ 'jade' ]
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

# Deploy
gulp.task 'deploy', ->
  gulp.src('./build/**/*').pipe deploy(branch: 'master')
