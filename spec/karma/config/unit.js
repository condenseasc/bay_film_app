// Karma configuration
// Generated on Mon Feb 03 2014 16:16:15 GMT+0100 (CET)

module.exports = function(config) {
  config.set({

    // base path, based on tmp/ folder
    basePath: '..',


    // frameworks to use
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      APPLICATION_SPEC,
      'http://code.angularjs.org/1.2.7/angular-mocks.js',
      'app/assets/javascripts/angular/*.js',
      'spec/javascripts/helpers/**/*[hH]elper.js',
      'spec/javascripts/**/*[sS]pec.{coffee,js}',
      'app/assets/templates/**/*.html'
    ],

    // list of files to exclude
    exclude: [

    ],


    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_DEBUG,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera (has to be installed with `npm install karma-opera-launcher`)
    // - Safari (only Mac; has to be installed with `npm install karma-safari-launcher`)
    // - PhantomJS
    // - IE (only Windows; has to be installed with `npm install karma-ie-launcher`)
    browsers: ['PhantomJS'],


    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,


    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: false,

    // Preprocessors
    preprocessors: {
        '**/*.html': ['ng-html2js']
    },

    ngHtml2JsPreprocessor: {
      // strip this from the file path
      stripPrefix: 'app/assets/templates/',
      // prepend this to the
      prependPrefix: 'template/',

      // // or define a custom transform function
      // cacheIdFromPath: function(filepath) {
      //   return cacheId;
      // },

      // setting this option will create only a single module that contains templates
      // from all the files, so you can load them all with module('foo')
      moduleName: 'karma-templates'
    }


  });
};
