# Keyboard Extra

Nice keyboard inputs in Elm.

It is quite tedious to find out the currently pressed down keys with just the `Keyboard` module, so this package aims to make it easier.

You can use Keyboard.Extra in two ways:

1. The "Intelligent Helper" way, which has some setting up to do but has a bunch of ways to help you get the information you need.
2. The "Plain Subscriptions" way, where you get subscriptions for keys' down and up events, and handle the rest on your own.


## Intelligent Helper

If you use the "Intelligent Helper" way, you will get the most help, such as:

- All keyboard keys are named values of the `Key` type, such as `ArrowUp`, `CharA` and `Enter`
- You can find out whether e.g. `Shift` is pressed down when any kind of a `Msg` happens in your program
- Arrow keys and WASD can be used as `{ x : Int, y : Int }` or as a union type (e.g. `South`, `NorthEast`)
- You can also get a full list of keys that are pressed down

When using the library like this, it follows The Elm Architecture.


### Set up

There is a full [example module](https://github.com/ohanhi/keyboard-extra/blob/master/example/Main.elm) in the source repository.

In essence, `Keyboard.Extra` is just another component in your program. It has a model (called `State`), an `update` function and some `subscriptions`. Below are the necessary parts to wire things up. Once that is done, you can get useful information using the numerous helper functions such as [`isPressed`](http://package.elm-lang.org/packages/ohanhi/keyboard-extra/latest/Keyboard-Extra#isPressed), [`arrows`](http://package.elm-lang.org/packages/ohanhi/keyboard-extra/latest/Keyboard-Extra#arrows) and [`arrowsDirection`](http://package.elm-lang.org/packages/ohanhi/keyboard-extra/latest/Keyboard-Extra#arrowsDirection).

------

Include the Keyboard.Extra state in your program's model

```elm
type alias Model =
    { keyboardState : Keyboard.Extra.State
    , otherThing : Int
    -- ...
    }

init : ( Model, Cmd Msg )
init =
    ( { keyboardState = Keyboard.Extra.initialState
      , otherThing = 0
      -- ...
      }
    , Cmd.none
    )
```


Add the message type in your messages

```elm
type Msg
    = KeyboardExtraMsg Keyboard.Extra.Msg
    -- ...
```

Include the subscriptions for the events to come through

```elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        -- ...
        ]

```


And finally, let it update its model

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardExtraMsg keyMsg ->
            ( { model | keyboardState = Keyboard.Extra.update keyMsg model.keyboardState }
            , Cmd.none
            )
        -- ...
```

Now you can get all the information anywhere where you have access to the model, for example like so:

```elm
calculateSpeed : Model -> Float
calculateSpeed model =
    let
        arrows =
            Keyboard.Extra.arrows model.keyboardState
    in
        model.currentSpeed + arrows.x
```


Have fun! :)

---

**PS.** The [Tracking Key Changes](https://github.com/ohanhi/keyboard-extra/blob/master/example/TrackingKeyChanges.elm) example shows how to use `updateWithKeyChange` to find out exactly which key was pressed down / released on that update cycle.


## Plain Subscriptions

With the "plain subscriptions" way, you get the bare minimum:

- All keyboard keys are named values of the `Key` type, such as `ArrowUp`, `CharA` and `Enter`

Setting up is very straight-forward, though:

```elm
type Msg
    = KeyDown Key
    | KeyUp Key
    -- ...


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.Extra.downs KeyDown
        , Keyboard.Extra.ups KeyUp
        -- ...
        ]
```

There's an example for this, too: [Plain Subscriptions](https://github.com/ohanhi/keyboard-extra/blob/master/example/PlainSubscriptions.elm)
