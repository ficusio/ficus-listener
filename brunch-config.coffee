 exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app.css'
      order:
        before: ['bower_compontnets/jquery-mobile-bower']
        after: ['app/styles/index.styl']

    templates:
      joinTo: 'javascripts/app.js'

  plugins:
    jaded:
      jade:
        pretty: yes
