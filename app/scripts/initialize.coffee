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

  $('body').append("<div class='vote-button'><div>Осталось 3 голоса</div></div>")

  $(".vote-button").data("chosen", [])
  $('#poll').removeClass('showing-thanks')

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
      $("body > .vote-button > div").data("chosen", chosen).text("#{if onlyVote then 'Остался' else 'Осталось'} #{3-chosen.length} голос#{if onlyVote then '' else 'а'}")
      $("body > .vote-button").animate({
        height: "60px", 'line-height':'60px'
      }, 200)
      $('#poll > .ui-content').animate({
        "margin-bottom": "60px"
      }, 200)
    else                
      $("body > .vote-button").animate({
        height: "160px", 'line-height':'160px'
      }, 200)
      $('#poll > .ui-content').animate({
        "margin-bottom": "160px"
      }, 200)

      $("body > .vote-button > div").empty()
      $("body > .vote-button > div").append('<span class="send-vote">ОТПРАВИТЬ ГОЛОСА</span>')
    

  showThaksForVote = ->
    $("body > .vote-button > div").empty()
    content.empty()
    $('#poll').addClass('showing-thanks')

    $("body").css({
      "height": "100%",
      "overflow": "hidden",
      "background-color": "#26b5ed"
    })

    $('#poll').css("background-color", "#26b5ed")
    $('#poll > .ui-content').css({
      "margin-bottom": "0"
    })

    draw = () -> content.append("<div class='thank-vote'><div class='happy'><img src='images/happy.svg' alt='Спасибо!'></img></div><div class='votes-count'>Ваши голоса учтены!</div><div class='powered'><span class='power'>powered by</span><img src='images/ficus-logo.svg' alt='Лого'></img></div></div>")
    setTimeout draw, 20
    

  $(".vote-button").on "tap", (e) ->
    chosen = $(this).data("chosen")
    if chosen.length is 3
      api.answer(chosen)
      showThaksForVote()

animation = (el) ->
  $(el).css("opacity","0.4")
  $(el).animate {"opacity": "1"}, 1000


API = require './server-api'
api = new API 'http://app.ficus.io/api'
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
  $("body > .vote-button").remove()
  if state is "active"
    $("body").css("background-color", "#26b5ed")
    $.mobile.navigate("#controll")
  if state is "ended"
    $("body").css("background-color", "#ffffff")
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
  $("body").css("height", "auto")
  $("body").css("overflow", "auto")
  $("body > .vote-button").remove()
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
