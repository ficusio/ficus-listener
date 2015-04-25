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
      name: 'Option 1'
      color: '#ff0000'
    }, {
      name: 'Option 2'
      color: '#0000ff'
    }, {
      name: 'Option 3'
      color: '#0f000f'
    }, {
      name: 'Option 4'
      color: '#ff00ff'
    }, {
      name: 'Option 5'
      color: '#F000ff'
    }, {
      name: 'Option 6'
      color: '#00f0ff'
    }]
  }, {
    id: '2'
    desciption: 'Test poll 2'
    options: [{
      name: 'Option 1'
      color: '#ff0000'
    }, {
      name: 'Option 2'
      color: '#00ff00'
    }, {
      name: 'Option 3'
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
