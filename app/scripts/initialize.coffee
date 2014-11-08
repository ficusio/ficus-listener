window.countChar = (val) ->
  len = $(val).val().length
  if (len >= 140)
    $(val).val($(val).val().substring(0, 140))
  if len>= 140
    len = 140
  $('.counter .number').text(len)


API = require './api'
api = new API '/api'

api.onInitialState = (initialState) ->
  console.log 'got initial state: ' + JSON.stringify(initialState, null, '  ')

api.onStateChanged = (state) ->
  console.log 'presentation state changed: ' + state

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
  do fakeui

  $.mobile.defaultPageTransition = 'flip'
