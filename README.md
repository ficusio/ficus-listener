## Listener API
  - ~> initalState : {state, poll: {POLL}}
  - ~> pollStarted : {poll}
  - ~> pollEnded
  - ~> stateChanged
  - voteUp()
  - voteDown()
  - sendFeedback(msg)

### POLL
```js
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
```js
[
  {
    count: number,
    weight: nubmber
  }
]
```


## Usage
```bash
$ npm install
$ bower install
$ node server.js
$ brunch w -s
```

