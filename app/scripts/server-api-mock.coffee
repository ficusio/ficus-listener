module.exports = class API

  @PresentationState:
    NOT_STARTED: 'not_started'
    ACTIVE: 'active'
    ENDED: 'ended'

  PresentationState: API.PresentationState

  constructor: (@apiEndpoint) ->
    console.log 'new API ' + @apiEndpoint
    @_ = new APIImpl this
    @onInitialState = undefined
    @onPollStarted = undefined
    @onPollEnded = undefined
    @onStateChanged = undefined

  voteUp: ->
    console.log 'API.voteUp'

  voteDown: ->
    console.log 'API.voteDown'

  answer: (index) ->
    console.log 'API.answer: ' + index

  sendFeedback: (msg) ->
    console.log "API.sendFeedback: '#{ msg }'"


POLL_MIN_TIME = 5000
POLL_MAX_TIME = 15000

INTER_POLL_MIN_DELAY = 5000
INTER_POLL_MAX_DELAY = 20000


####################################################################################################

class APIImpl

  later = (timeout, f) -> setTimeout f, timeout

  randomTimeout = (min = 1000, max = 15000) ->
    Math.floor min + (max - min) * Math.random()


  mockPolls = [{
    id: '1'
    desciption: 'Test poll 1'
    options: [{
      label: 'EasyTarget'
      color: '#ff0000'
    }, {
      label: 'IndoorNav'
      color: '#0000ff'
    }, {
      label: 'FabModules'
      color: '#0f000f'
    }, {
      label: 'Let\'s Go'
      color: '#ff00ff'
    }, {
      label: 'Рикарда'
      color: '#F000ff'
    }, {
      label: 'GoWalk'
      color: '#00f0ff'
    },{
      label: 'Бесогон'
      color: '#ff0000'
    }, {
      label: 'Русский для иностранцев'
      color: '#0000ff'
    }, {
      label: 'Кардиограф'
      color: '#0f000f'
    }, {
      label: 'Sass Scada Monitor'
      color: '#ff00ff'
    }, {
      label: 'Nesg.ru'
      color: '#F000ff'
    }, {
      label: 'Мегабикон'
      color: '#00f0ff'
    },{
      label: 'CityCode'
      color: '#ff0000'
    }, {
      label: 'Novisse'
      color: '#0000ff'
    }, {
      label: 'Космическая игра'
      color: '#0f000f'
    }, {
      label: 'Твори Добро'
      color: '#ff00ff'
    }, {
      label: 'ScoolLab'
      color: '#F000ff'
    }, {
      label: 'World Street Wars'
      color: '#00f0ff'
    },{
      label: 'Runny Jump'
      color: '#ff0000'
    }, {
      label: 'ТерраЛорды'
      color: '#0000ff'
    }, {
      label: 'Игра Марата'
      color: '#0f000f'
    }, {
      label: 'Cyber League'
      color: '#ff00ff'
    }]
  }, {
    id: '2'
    desciption: 'Test poll 2'
    options: [{
      label: 'Option 1'
      color: '#ff0000'
    }, {
      label: 'Option 2'
      color: '#00ff00'
    }, {
      label: 'Option 3'
      color: '#0000ff'
    }]
  }]

  constructor: (@intf) ->
    @pollIndex = -1
    later randomTimeout(0, 1000), => @initialize()


  callback: (name, args...) ->
    console.log '~> ' + name, args...
    @intf[name]? args...


  initialize: ->
    # if Math.random() < 0.5
    #   @callback 'onInitialState',
    #     state: API.PresentationState.NOT_STARTED
    #   later 1000, => @start()
    # else
      @pollIndex = 0
      @callback 'onInitialState',
        state: API.PresentationState.ACTIVE
        poll: mockPolls[ @pollIndex ]
      @schedulePollEnd()



  start: ->
    @callback 'onStateChanged', API.PresentationState.ACTIVE
    # @scheduleNext()


  scheduleNext: ->
    later randomTimeout(INTER_POLL_MIN_DELAY, INTER_POLL_MAX_DELAY),
      if ++@pollIndex < mockPolls.length
        => @startPoll()
      else
        => @end()


  startPoll: ->
    @callback 'onPollStarted', mockPolls[ @pollIndex ]
    @schedulePollEnd()


  schedulePollEnd: ->
    later randomTimeout(POLL_MIN_TIME, POLL_MAX_TIME), => @endPoll()


  endPoll: ->
    @callback 'onPollEnded'
    @scheduleNext()


  end: ->
    @callback 'onStateChanged', API.PresentationState.ENDED

# sock = ->

#   sockjs_url = 'http://localhost:9999/echo'
#   sockjs = new SockJS(sockjs_url)
#   sockjs.onopen = ->
#     console.log( 'connected ' + sockjs.protocol )

#   sockjs.onmessage = (e) ->
#     message = e.data

#     console.log( 'recive message ' + message )

#     if (message == 'flip')
#       if (location.hash == '#first')
#         $.mobile.navigate('#second')
#       else
#         $.mobile.navigate('#first')

#   sockjs.onclose   = ->
#     console.log( 'closed' )


#   $('#foo').on "tap", (e) ->
#     sockjs.send('foo')
