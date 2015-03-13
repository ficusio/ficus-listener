## Quick development start

```bash
git clone git@github.com:ficusio/ficus-listener.git listener && cd listener
./hack
```

## Listener protocol

```js
~> inital_state: {state: PresentationState, poll: Poll?, pollVote: int? }
~> presentation_state: PresentationState
~> poll: Poll | false

<~ init: {clientId: String, presentationId: String}
<~ vote_up
<~ vote_down
<~ question: String
<~ poll_vote: int

PresentationState: 'not_started' | 'active' | 'ended'

Poll: {
  id: String,
  title: String,
  options: [
    {
      label: String,
      color: '#rrggbb'
    }
  ]
}
```
