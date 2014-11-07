## Listener API
  - ~> initalState : {state, poll: {POLL}}
  - ~> pollStarted : {poll}
  - ~> pollEnded
  - ~> stateChanged
  - voteUp()
  - voteDown()
  - sendFeedback(msg)

### POLL
```JSON
{
  id: string,
  desciption: string,
  options: [
    {
      name: string,
      color: string
    }
  ]
}
```

### Poll_state
```JSON
[
  {
    count: number,
    weight: nubmber
  }
]
```