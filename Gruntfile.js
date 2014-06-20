module.exports = function(grunt){

  grunt.initConfig({

    html2js: {
      options: {
        base: '.',
        module: 'angular-templates',
        rename: function (modulePath) {
          var moduleName = modulePath.replace('app/assets/templates/', '').replace('.html', '');
          return 'template' + '/' + moduleName + '.html';
        }
      },
      main: {
        src: ['app/assets/templates/**/*.html'],
        dest: 'app/assets/templates/angular-templates.js'
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