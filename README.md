# Keyboard Extra

Higher level handling for keyboard inputs in Elm 0.17.

This library is a standard component following The Elm Architecture.

It is quite tedious to find out the currently pressed down keys with just the `Keyboard` module, so this package aims to make it easier. You can also get some bonus benefits out of this:

- Keys are named values of the `Key` type, including e.g. `ArrowUp`, `CharA` and `Enter`
- You can find out whether e.g. `CharC` is pressed down when any `Msg` happens in your program
- Arrow keys and WASD can be decoded into records similarly to Elm 0.16: `{ x : Int, y : Int }`
- You can also get a full list of keys that are pressed down, if you need to


# Usage

There is a full [example module](https://github.com/ohanhi/keyboard-extra/blob/master/example/Main.elm) in the source repository.

In essence, `Keyboard.Extra` is just another component in your program. It has a model, an update function and some subscriptions. Below are the necessary parts to wire things up. Once that is done, you can go and use the helper functions such as [`isPressed`](http://package.elm-lang.org/packages/ohanhi/keyboard-extra/1.0.0/Keyboard-Extra#isPressed) and [`arrows`](http://package.elm-lang.org/packages/ohanhi/keyboard-extra/1.0.0/Keyboard-Extra#arrows). Have fun! :)


```elm
-- include the model in your component
type alias Model =
    { keyboardModel : Keyboard.Extra.Model
    , otherThing : Int
    -- ...
    }
```


```elm
-- initialize the component
init : ( Model, Cmd Msg )
init =
    let
        ( keyboardModel, keyboardCmd ) =
            Keyboard.Extra.init
    in
        ( { keyboardModel = keyboardModel
          , otherThing = 0
          -- ...
          }
        , Cmd.batch
            [ Cmd.map KeyboardExtraMsg keyboardCmd
            -- ..
            ]
        )
```


```elm
-- add the message type in your messages
type Msg
    = KeyboardExtraMsg Keyboard.Extra.Msg
    | OtherMsg
```


```elm
-- let it update its model
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardExtraMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.Extra.update keyMsg model.keyboardModel
            in
                ( { model | keyboardModel = keyboardModel }
                , Cmd.map KeyboardMsg keyboardCmd
                )
        -- ...
```

```elm
-- and finally, include the subscriptions for the events to come through
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardExtraMsg Keyboard.Extra.subscriptions
        -- ...
        ]

```
