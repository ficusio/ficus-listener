window.countChar = (val) ->
  len = $(val).val().length
  if (len >= 140)
    $(val).val($(val).val().substring(0, 140))
  if len>= 140
    len = 140
  $('.counter .number').text(len)

# {
#   "id": "2",
#   "desciption": "Test poll 2",
#   "options": [
#     {
#       "name": "Option 1",
#       "color": "#ff0000"
#     },
#     {
#       "name": "Option 2",
#       "color": "#00ff00"
#     },
#     {
#       "name": "Option 3",
#       "color": "#0000ff"
#     }
#   ]
# }

setButtons = (poll) ->
  count = poll.options.length
  $("p.empty").hide()

  for option, i in poll.options
    $("#poll .ui-content").append("<div class='answer' data-index='#{i}' data-color='#{option.color}' style='color: #{option.color}; border-color: #{option.color}; '>#{option.name}</div>")

  screenH = $("#poll").height()
  padding = ((screenH - (44*count) )- 36)/count
  console.log padding

  $(".answer").css(
    "padding-top": "#{padding/2}px"
    "padding-bottom": "#{padding/2}px"
  ).click ->

    api.answer($(this).data("index"))



API = require './api'
api = new API '/api'

api.onInitialState = (initialState) ->
  console.log 'got initial state: ' + JSON.stringify(initialState, null, '  ')
  if initialState.state is "active"
    if initialState.poll
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

api.onPollStarted = (poll) ->
  console.log 'poll started: ' + JSON.stringify(poll, null, '  ')

api.onPollEnded = ->
  console.log 'poll ended'

# Methods:
#
# api.voteUp()
# api.voteDown()
# api.sendFeedback('message')
#
# Presentation state:
#
# API.PresentationState.NOT_STARTED
# API.PresentationState.ACTIVE
# API.PresentationState.ENDED


fakeui = ->
  $(".answer").click ->
    letters = '0123456789ABCDEF'.split('')
    color = '#'
    for i in "123456"
      color += letters[Math.floor(Math.random() * 16)]
    $("#second .fill").css("background-color", color)
    $("#second .fill").fadeIn(700)

  # window.setButtons()



$ ->


  $.mobile.defaultPageTransition = 'flip'
