## Proteus Gulp Project Starter

### Gulpfile 

#### Required Modules
Install be issuing `npm install` at the command line.

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
    ghpages      = require 'gulp-gh-pages'
    _            = require 'lodash'
    pug          = require 'gulp-pug'
    shell        = require 'gulp-shell'
    reload       = browsersync.reload

### Project Configuation
#### Asset Paths

    paths        =
      pug      : './source/views/*.pug'
      partials : './source/views/partials/_*.pug'
      coffee   : ['./source/assets/javascripts/**/*.coffee', '!./source/assets/javascripts/**/_*.coffee' ]
      scss     : './source/assets/stylesheets/**/*.scss'
      images   : './source/assets/images/*'
      fonts    : './source/assets/fonts/**/*'
      root     : './source/root/*'

#### Urls

    urls      =
      local   : 'http://localhost:8000'
      staging : 'http://s3staging.com.s3-website-us-east-1.amazonaws.com'
      prod    : 'http://www.s3staging.com'

#### Environment
Function to set environment for development and eventual deploy.  This will set urls in templates.

** Set deploy environment here! ** Options = local, staging and prod.  Enter as a quoted string - example: "staging"  

    denv = 'local'

Select proper urls for templates.

    urlselect = switch
      when denv is 'local' then urls.local
      when denv is 'localhost' then urls.local
      when denv is 'staging' then urls.staging
      when denv is 'prod' then urls.prod
      when denv is 'production' then urls.prod
      else urls.local

#### locals Object 
This object is passed to Pug templates.  Reference the urls object to set environment i.e. `url: urls.stating` for S3 staging deployment.

    locals   =
      url    : urlselect
      _      : _
      images : 'assets/images'
      css    : 'assets/stylesheets'
      js     : 'assets/javascripts'


### Gulp Tasks
#### Pug templates

    gulp.task 'pug', ->
      gulp.src(paths.pug)
        .pipe pug
          pretty: true
          locals: locals
        .pipe gulp.dest('./build')
        .pipe reload({stream: true})
        return

#### SCSS stylesheets

    gulp.task 'stylesheets', ->
      gulp.src paths.scss
      .pipe sass(
        includePaths: neat.includePaths
        ).on('error', sass.logError)
      .pipe(postcss([
          require('autoprefixer')
        ]))
      .pipe gulp.dest('./build/assets/stylesheets')


#### Coffeescript

    gulp.task 'javascripts', ->
      gulp.src paths.coffee
        .pipe sourcemaps.init()
        .pipe include()
        .pipe coffee()
        .pipe sourcemaps.write()
        .pipe gulp.dest('./build/assets/javascripts')

Set global coffeescript environment

    coffeeStream = coffee(bare: true)
    coffeeStream.on 'error', (err) ->

#### Copy images

    gulp.task 'images', ->
      gulp.src(paths.images).pipe gulp.dest('./build/assets/images')
      return

#### Copy fonts

    gulp.task 'fonts', ->
      gulp.src(paths.fonts).pipe gulp.dest('./build/assets/fonts')
      return

#### Copy root assets

    gulp.task 'root', ->
      gulp.src(paths.root)
      .pipe gulp.dest('./build')
      .pipe reload({stream: true})
      return

#### Server

    gulp.task 'server', ->
      browsersync
        server: baseDir: './build'
        port: 8000
        notify: true
        open: false
      return

#### Watch

    gulp.task 'watch', ->
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

#### Default

    gulp.task 'default', [
      'pug'
      'stylesheets'
      'javascripts'
      'images'
      'fonts'
      'root'
      'server'
      'watch'
    ], ->

#### Build

    gulp.task 'build', [
      'pug'
      'stylesheets'
      'javascripts'
      'images'
      'root'
      'fonts'
      ], ->

#### Deploy to s3 using installed s3_website gem: https://github.com/laurilehmijoki/s3_website.
Install gem with `gem install s3_website`.

#### Standard deploy
Only changed files are uploaded

    gulp.task 's3', shell.task([
      's3_website push'
    ])

#### Forced deploy
All files are replaced

    gulp.task 's3-force', shell.task([
      's3_website push --force'
    ])

#### Combined deploy task

    gulp.task 's3-deploy', [
        'build'
        's3'
      ], ->

#### Combined forced deploy task

    gulp.task 's3-force-deploy', [
        'build'
        's3-force'
      ], ->

#### Github Deploy

    gulp.task 'gh-deploy', ->
      gulp.src('./build/**/*')
        .pipe ghpages(branch: 'master')


