module.exports = function(grunt){

  grunt.initConfig({

    html2js: {
      options: {
        base: '.',
        module: function(modulePath, gruntTask) {
          console.log("modulePath -----> ", modulePath);
          console.log("gruntTask ------>", gruntTask);
          return "oo-" + gruntTask + "-templates";
        },
        rename: function (modulePath) {
          var moduleName = modulePath.replace('app/assets/templates/', '').replace('.html', '');
          return 'template' + '/' + moduleName + '.html';
        }
      },
      calendar: {
        src: ['app/assets/templates/calendar/**/*.html'],
        dest: 'app/assets/javascripts/angular/js_templates/calendar-templates.js'
      },
      datepicker: {
        src: ['app/assets/templates/datepicker/*.html'],
        dest: 'app/assets/javascripts/angular/js_templates/datepicker-templates.js'
      }
    },

    // html2js: {
    //   options: {
    //     base: 'app/assets'
    //   },
    //   main: {
    //     src: ['app/assets/templates/**/*.html'],
    //     dest: 'vendor/assets/templates/templates.js'
    //   },
    // },
  });







  grunt.loadNpmTasks('grunt-html2js');
  grunt.registerTask('default', ['html2js']);

};