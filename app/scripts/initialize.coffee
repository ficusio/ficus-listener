window.countChar = () ->
  len = $(".question").val().length
  if (len >= 140)
    $(".question").val($(".question").val().substring(0, 140))
  if len>= 140
    len = 140
  $('.counter .number').text(len)


setButtons = (poll) ->

  $(".fill").hide()
  $(".answer").remove()

  console.log(poll)
  if poll is false
    $.mobile.navigate("#controll")
    return
  count = poll.options.length
  $("p.empty").hide()

  for option, i in poll.options
    $("#poll .ui-content").append("<div class='answer' data-index='#{i}' data-color='#{option.color}' style='color: #{option.color}; border-color: #{option.color}; '>#{option.label}</div>")

  screenH = $("#poll").height()
  padding = ((screenH - (38*count) )- 36)/count

  $(".answer").css(
    "padding-top": "#{padding/2}px"
    "padding-bottom": "#{padding/2}px"
  ).click ->
    api.answer($(this).data("index"))
    $("#poll .fill").css("background-color", $(this).data("color"))
    $("#poll .fill").fadeIn(700)

animation = (el) ->
  $(el).css("opacity","0.4")
  $(el).animate {"opacity": "1"}, 1000


API = require './server-api'
api = new API '/api'
# api = new API 'http://codehipsters.com/api'

api.onInitialState = (initialState) ->
  console.log 'got initial state: ' + JSON.stringify(initialState, null, '  ')
  if initialState.state is "active"
    if initialState.poll and initialState.poll.options
      setButtons(initialState.poll)
      $.mobile.navigate("#poll")
    else
      $.mobile.navigate("#controll")
  else
    $.mobile.navigate("#hello")

api.onStateChanged = (state) ->
  console.log 'presentation state changed: ' + state
  if state is "active"
    $.mobile.navigate("#controll")
  if state is "ended"
    $.mobile.navigate("#hello")

api.onPollStarted = (poll) ->
  if(poll is false)
    $.mobile.navigate("#controll")
    return

  console.log 'poll started: ' + JSON.stringify(poll, null, '  ')
  setButtons(poll)
  $.mobile.navigate("#poll")

api.onPollEnded = ->
  console.log 'poll ended'
  $.mobile.navigate("#controll")


$ ->

  $(".faster").click ->
    api.voteUp()
    animation(this)

  $(".slower").click ->
    api.voteDown()
    animation(this)

  $(".send").click ->
    animation(this)
    text = $(".question").val()
    unless text is ""
      $(".question").val("")
      window.countChar()
      api.sendFeedback(text)




  $.mobile.defaultPageTransition = 'flip'
