# require 
gulp = require "gulp"
coffee = require "gulp-coffee"
rename = require "gulp-rename"
uglify = require "gulp-uglify"
sass = require "gulp-sass"
jade = require "gulp-jade"
plumber = require "gulp-plumber"
autoprefixer = require "gulp-autoprefixer"
browserSync = require "browser-sync"
reload = browserSync.reload







# scripts Task
gulp.task "scripts", ->
  gulp.src("app/src/coffee/**/*.coffee")
    .pipe(plumber())
    .pipe(rename({suffix: ".min"}))
    .pipe(coffee({bare: true}))
    .pipe(uglify())
    .pipe(gulp.dest("app/js"))
    .pipe(reload({stream:true}))


# SASS  Task
gulp.task "scss", ->
  gulp.src("app/src/scss/**/*.scss")
    .pipe(plumber())
    .pipe(rename({suffix: ".min"}))
    .pipe(sass())
    .pipe(autoprefixer("last 2 versions"))
    .pipe(gulp.dest("app/css"))
    .pipe(reload({stream:true}))

# HTML Task
gulp.task "html", ->
  gulp.src("app/src/jade/*.jade")
    .pipe(plumber())
    .pipe(jade({pretty:true, doctype:"html"}))
    .pipe(gulp.dest("app/"))
    .pipe(reload({stream:true}))

# Browser-sync Task
gulp.task "browser-sync", ->
  browserSync({
    server: {
      baseDir: "./app/"
    }})




# Watch Tasks 
gulp.task "watch", ->
  gulp.watch("app/src/coffee/**/*.coffee",["scripts"])
  gulp.watch("app/src/scss/**/*.scss",["scss"])
  gulp.watch("app/src/jade/**/*.jade",["html"])




# Default Task
gulp.task "default", ["scripts","scss","html","browser-sync","watch"]

