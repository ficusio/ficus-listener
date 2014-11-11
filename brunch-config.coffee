 exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/app-listener.js': /^app/
        'javascripts/vendor-listener.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app-listener.css'
      order:
        before: ['bower_compontnets/jquery-mobile-bower']
        after: ['app/styles/index.styl']

    templates:
      joinTo: 'javascripts/app-listener.js'

  plugins:
    jaded:
      jade:
        pretty: yes
