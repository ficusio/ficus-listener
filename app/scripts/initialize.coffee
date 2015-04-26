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


  $("#poll").css("overflow", "auto")

  content = $("#poll .ui-content")
  content.empty()
  content.append("<div class='vote-header'><div>Проголосуйте</div><div>за участников хакатона</div></div>")

  for option, i in poll.options
    content.append("<div class='answer' data-index='#{i}'><div>#{option.label}</div><div class='checkbox-wrapper'><img src='images/checkbox.svg'></div></div>")

  content.append("<div class='vote-button'><div>Осталось 3 голоса</div></div>")

  $(".vote-button").data("chosen", [])

  $(".answer").click ->
    optionIndex = $(this).data("index")
    chosen = $(".vote-button").data("chosen")
    searchRes = chosen.indexOf(optionIndex)
    if searchRes > -1
      chosen.splice(searchRes,1)
      $(this).toggleClass("chosen")
    else
      if chosen.length >=3
        return
      chosen.push(optionIndex)
      $(this).toggleClass("chosen")
    votesLeft = 3-chosen.length
    onlyVote = votesLeft is 1
    if chosen.length < 3
      $(".vote-button > div").data("chosen", chosen).text("#{if onlyVote then 'Остался' else 'Осталось'} #{3-chosen.length} голос#{if onlyVote then '' else 'а'}")
    else
      $(".vote-button > div").empty()
      $(".vote-button > div").append('<span class="send-vote">ОТПРАВИТЬ ГОЛОСА</span>')
    

  showThaksForVote = ->
    content.empty()

    $("#poll").css("overflow", "hidden")
    draw = () -> content.append("<div class='thank-vote'><div class='happy'><img src='images/happy.svg' alt='Спасибо!'></img></div><div class='votes-count'>Ваши голоса учтены!</div><div class='powered'><span class='power'>powered by</span><img src='images/ficus-logo.svg' alt='Лого'></img></div></div>")
    setTimeout draw, 20
    

  $(".vote-button").click ->
    chosen = $(this).data("chosen")
    if chosen.length is 3
      api.answer(chosen)
      showThaksForVote()

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
