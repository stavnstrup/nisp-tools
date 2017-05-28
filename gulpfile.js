/**
 *
 * Gulp tasks for the NISP Assets (CSS/Javascript/Images).
 *
 * This file was originally created by Savaslabs.
 * See: http://savaslabs.com/2016/10/19/optimizing-jekyll-with-gulp.html
 *
 * Table of contents:
 *   1. Styles
 *   2. Scripts
 *   3. Images
 *   4. Fonts
 *   5. Misc.
 */

// Define variables.
var appendPrepend  = require('gulp-append-prepend');
var autoprefixer   = require('autoprefixer');
var browserSync    = require('browser-sync').create();
var cache          = require('gulp-cache');
var cleancss       = require('gulp-clean-css');
var concat         = require('gulp-concat');
var del            = require('del');
var gulp           = require('gulp');
var gutil          = require('gulp-util');
var imagemin       = require('gulp-imagemin');
var jpegRecompress = require('imagemin-jpeg-recompress');
var notify         = require('gulp-notify');
var postcss        = require('gulp-postcss');
var rename         = require('gulp-rename');
var run            = require('gulp-run');
var runSequence    = require('run-sequence');
var sass           = require('gulp-ruby-sass');
var uglify         = require('gulp-uglify');


/**
 * Task: build:styles:main
 *
 * Uses Sass compiler to process styles, adds vendor prefixes, minifies, then
 * outputs file to the appropriate location.
 */
gulp.task('build:styles:nisp', function() {
    return sass('scss' + '/nisp.scss', {
        style: 'compressed',
        trace: true,
        loadPath: ['scss/']
    }).pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
        .pipe(cleancss())
        .pipe(gulp.dest('xsl/css/'))
        .pipe(gulp.dest('build/css/'))
        .pipe(browserSync.stream())
        .on('error', gutil.log);
});

gulp.task('build:styles:man', function() {
    return sass('scss' + '/man.scss', {
        style: 'compressed',
        trace: true,
        loadPath: ['scss/']
    }).pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
        .pipe(cleancss())
        .pipe(gulp.dest('xsl/css/'))
        .pipe(gulp.dest('build/css/'))
        .pipe(browserSync.stream())
        .on('error', gutil.log);
});

/**
 * Task: build:styles:css
 *
 * Copies any other CSS files to the assets directory, to be used by pages/posts
 * that specify custom CSS files.
 */
gulp.task('build:styles:css', function() {
    return gulp.src(['scss' + '/*.css'])
      .pipe(postcss([ autoprefixer({ browsers: ['last 2 versions'] }) ]))
      .pipe(cleancss())
      .pipe(gulp.dest('xsl/css'))
      .pipe(gulp.dest('build/css'))
      .on('error', gutil.log);
});


/**
 * Task: build:styles
 *
 * Builds all site styles.
 */
gulp.task('build:styles', [
    'build:styles:nisp',
    'build:styles:man',
    'build:styles:css'
]);



/**
 * Task: clean:styles
 *
 * Deletes all processed site styles.
 */
gulp.task('clean:styles', function(callback) {
    del(['xsl/css/', 'build/css/']);
    callback();
});


/**
 * Task: clean
 *
 * Runs all the clean commands.
 */
gulp.task('clean', [
    'clean:styles']);

/**
 * Task: build
 *
 * Build the assets.
 */
gulp.task('build', function(callback) {
    runSequence('clean',
        ['build:styles'],
        callback);
});

/**
 * Task: build:test
 *
 * Builds the site anew using test config.
 */
gulp.task('build:test', function(callback) {
    runSequence('clean',
        ['build:styles'],
        callback);
});

/**
 * Task: build:test
 *
 * Builds the site anew using test and local config.
 */
gulp.task('build:local', function(callback) {
    runSequence('clean',
        ['build:styles'],
      callback);
});

/**
 * Task: default
 *
 * Builds the site anew.
 */
gulp.task('default', ['build']);


/**
 * Task: serve
 *
 * Static Server + watching files.
 *
 * Note: passing anything besides hard-coded literal paths with globs doesn't
 * seem to work with gulp.watch().
 */
gulp.task('serve', ['build:local'], function() {

    browserSync.init({
        server: 'build/',
        ghostMode: false, // Toggle to mirror clicks, reloads etc. (performance)
        logFileChanges: true,
        logLevel: 'debug',
        open: true        // Toggle to automatically open page when starting.
    });

    // Watch .scss files; changes are piped to browserSync.
    // Ignore style guide SCSS.
    // Rebuild the style guide to catch updates to component markup.
    gulp.watch(
      ['scss/**/*.scss'],
      ['build:styles']
    );

});


/**
 * Task: cache-clear
 *
 * Clears the gulp cache. Currently this just holds processed images.
 */
gulp.task('cache-clear', function(done) {
    return cache.clearAll(done);
});
