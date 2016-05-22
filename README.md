# Proteus - Gulp

## About Proteus
[Proteus](http://github.com/thoughtbot/proteus) is a collection of useful
starter kits to help you prototype faster. It follows the
[thoughtbot styleguide](https://github.com/thoughtbot/guides) and includes our
favorite front end tools.

Includes
--------
* [Gulp](http://gulpjs.com): Converts files and task running
* [Jade/Pug](https://github.com/phated/gulp-jade)
  Simple, versitile template markup
* [HAML-Coffee](http://haml-coffee-online.herokuapp.com/):
  Simple template markup with coffeescript.
* [Coffeescript](http://coffeescript.org):
  Write javascript with simpler syntax. Available as filter in jade templates and Gulpfiles.
* [Sass](http://sass-lang.com):
  CSS with superpowers
* [Bourbon](http://bourbon.io):
  Sass mixin library
* [Neat](http://neat.bourbon.io):
  Semantic grid for Sass and Bourbon
* [Bitters](http://bitters.bourbon.io):
  Scaffold styles, variables and structure for Bourbon projects.
* [Express](http://expressjs.com):
  Lightweight Node web server
* [Lodash](https://lodash.com/):
  Easy javascript library for use in Jade templates
* [Markdown-it](https://markdown-it.github.io/):
  Markdown parser, done right. 100% CommonMark support, extensions, syntax plugins & high speed

[Refills](http://refills.bourbon.io/) is recommended for prepackaged interface patterns.

Getting Started
---------------
Set up your project in your code directory
```
git clone git@github.com:dpfranklin/proteus-gulp.git your-project-folder
cd your-project-folder
git remote rm origin
git remote add origin your-repo-url
```

Install the dependencies
```
npm install
```

Run the server
```
gulp
```

Read Gulpfile.litcoffee to gain a better sense on how to optimize and customize this package including how to deploy to AWS S3.


Deploy to Github Pages
```
gulp deploy
```

Deploy to AWS S3 (install [s3_website gem](https://github.com/laurilehmijoki/s3_website) first.)
```
gulp s3-deploy
```


Stylesheets, images, fonts, and javascript files go in the `/source/assets/` directory.
Vendor stylesheets and javascripts should go in each of their `/vendor/` directories.
The source folders for images and fonts have a `.keep` file in them so they can be in the repo, but you can remove those files.

Contributing
------------

If you have problems, please create a
[GitHub Issue](https://github.com/dpfranklin/proteus-gulp/issues)

Have a fix or want to add a feature? Open a
[Pull Request](https://github.com/dpfranklin/proteus-gulp/pulls)


Original Credits
-------

[![thoughtbot](http://images.thoughtbot.com/bourbon/thoughtbot-logo.svg)](http://thoughtbot.com)

This application is maintained and funded by [thoughtbot, inc](http://thoughtbot.com/community)

Thank you to all [the contributors](https://github.com/thoughtbot/proteus-middleman/contributors)!

With modification by [dpfranklin](https://github.com/dpfranklin)

License
-------

The names and logos for thoughtbot are trademarks of thoughtbot, inc.

Proteus Gulp is Copyright © 2014 thoughtbot, inc. It is free software, and may be
redistributed under the terms specified in the LICENSE file.

