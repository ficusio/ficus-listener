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

  content = $("#poll .ui-content")

  content.append("<div class='vote-header'><div>Проголосуйте</div><div>за участников хакатона</div></div>")

  for option, i in poll.options
    content.append("<div class='answer' data-index='#{i}'>#{option.label}</div>")

  content.append("<div class='vote-button'>Осталось 3 голоса</div>")

  $(".vote-button").data("chosen", [])

  $(".answer").click ->
    optionIndex = $(this).data("index")
    $(this).toggleClass("chosen")
    chosen = $(".vote-button").data("chosen")
    searchRes = chosen.indexOf(optionIndex)
    if searchRes > -1
      chosen.splice(searchRes,1)
    else
      chosen.push(optionIndex)
    votesLeft = 3-chosen.length
    onlyVote = votesLeft is 1
    $(".vote-button").data("chosen", chosen).text(if chosen.length < 3 then "#{if onlyVote then 'Остался' else 'Осталось'} #{3-chosen.length} голос#{if onlyVote then '' else 'а'}" else "Проголосовать!")

  showThaksForVote = ->
    content.empty()
    content.append("<div>Ваш голос принят!</div>")
    #Витя пожалуйста пиши свой код здесь

  $(".vote-button").click ->
    chosen = $(this).data("chosen")
    if chosen.length is 3
      api.answer(chosen)
      showThaksForVote()
      #$(".answer").not(".chosen").remove()
      #$(".vote-button").text("Ваш голос принят!")
      #$(this).unbind("click")
      #$(".answer").unbind("click")

animation = (el) ->
  $(el).css("opacity","0.4")
  $(el).animate {"opacity": "1"}, 1000


API = require './server-api-mock'
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

  $('.faster').on "tap", (e) ->
    api.voteUp()
    animation(this)

  $('.slower').on "tap", (e) ->
    api.voteDown()
    animation(this)

  $('.send').on "tap", (e) ->
    animation(this)
    text = $(".question").val()
    unless text is ""
      $(".question").val("")
      window.countChar()
      api.sendFeedback(text)




  $.mobile.defaultPageTransition = 'flip'
