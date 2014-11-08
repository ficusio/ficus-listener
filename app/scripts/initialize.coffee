window.countChar = (val) ->

  len = $(val).val().length
  if (len >= 140)
    $(val).val($(val).val().substring(0, 140))

  $('.counter .number').text(len)



sock = ->

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

fakeui = ->
  console.log "fakeuistarted"

  $(".answer").click ->
    letters = '0123456789ABCDEF'.split('')
    color = '#'
    for i in "123456"
      color += letters[Math.floor(Math.random() * 16)]
    $("#second .fill").css("background-color", color)
    $("#second .fill").fadeIn(700)



$ ->
  do fakeui

  $.mobile.defaultPageTransition = 'flip'
