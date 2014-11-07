$ ->

  sockjs_url = 'http://localhost:9999/echo'
  sockjs = new SockJS(sockjs_url)
  sockjs.onopen = ->
    console.log( 'connected ' + sockjs.protocol )

  sockjs.onmessage = (e) ->
    message = e.data

    console.log( 'recive message ' + message )

    if (message == 'flip')
      if (location.hash == '#first')
        $.mobile.navigate('#second')
      else
        $.mobile.navigate('#first')

  sockjs.onclose   = ->
    console.log( 'closed' )


  $('#foo').on "tap", (e) ->
    sockjs.send('foo')

