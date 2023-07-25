# Pong

(Check the live demo @ https://zesty-semifreddo-691978.netlify.app/ )

Front-end is deployed in [Netlify](https://netlify.com), and back-end is running in [Google App Engine](https://cloud.google.com/appengine)

This is a toy project I'm using to learn some new tech. I wanted to learn Elixir (and especially OTP) and figured an online game would be a good fit. I also took the opportunity to play with Svelte while I'm at it :)

Some key features to make this interesting:

- Front-end should be a thin rendering / input processing program. All computing is delegated to the back-end and communication between back-end and front-end is done through HTTP / WebSockets
- Multiple matches can be played concurrently


## Architecture

The following sequence diagram shows the back-end processes when a match is started.

![](doc/pvp-match.png)

The match's state machine runs inside the `MatchServer`. The core logic is implemented in the `Pong.Core.Match.StateMachine` module. It's implemented as a purely functional state machine so it's easy to unit test

## Running

To run the back-end:

```shell
cd backend
mix deps.get
mix run --no-halt
```

To run the front-end:

```shell
cd pong-ui
npm i
npm run dev -- --open
```

## Considerations

- There are no integration tests because I don't know how to do them in Elixir yet :D
- After a match ends the process stays alive forever. This is by design so we can see the results of previous matches. A better way would be to add another process that listens to matches and stores the final results so the MatchServer process can die without us losing that match's state.
