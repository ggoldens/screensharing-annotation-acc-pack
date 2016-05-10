var gulp = require('gulp');
var concat = require('gulp-concat');
var importCss = require('gulp-import-css');
var uglify = require('gulp-uglify');
inlineCss = require('gulp-inline-css');

gulp.task('default', ['js', 'css']);
gulp.task('dev', ['js-dev', 'css']);

gulp.task('js', function () {
  return gulp.src('src/*.js')
    .pipe(concat('screenshare-annotation-acc-pack.js'))
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});

gulp.task('js-dev', function () {
  return gulp.src('src/*.js')
    .pipe(concat('screenshare-annotation-acc-pack.js'))
    .pipe(gulp.dest('dist'));
});


gulp.task('css', function () {
  return gulp.src('css/theme.css')
    .pipe(importCss())
    .pipe(gulp.dest('dist'));
});

gulp.task('dist', ['js', 'css']);