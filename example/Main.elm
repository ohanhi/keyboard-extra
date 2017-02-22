module Main exposing (..)

import Html exposing (Html, p, ul, li, text)
import Keyboard.Extra


type Msg
    = KeyboardMsg Keyboard.Extra.Msg


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.
-}
type alias Model =
    { keyboardState : Keyboard.Extra.State
    }


init : ( Model, Cmd Msg )
init =
    ( Model Keyboard.Extra.initialState
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | keyboardState = Keyboard.Extra.update keyMsg model.keyboardState
              }
            , Cmd.none
            )


view : Model -> Html msg
view model =
    let
        shiftPressed =
            Keyboard.Extra.isPressed Keyboard.Extra.Shift model.keyboardState

        arrows =
            Keyboard.Extra.arrows model.keyboardState

        wasd =
            Keyboard.Extra.wasd model.keyboardState

        keyList =
            Keyboard.Extra.pressedDown model.keyboardState
    in
        p []
            [ text ("Shift: " ++ toString shiftPressed)
            , p [] [ text ("Arrows: " ++ toString arrows) ]
            , p [] [ text ("WASD: " ++ toString wasd) ]
            , p [] [ text "Currently pressed down:" ]
            , ul []
                (List.map (\key -> li [] [ text (toString key) ]) keyList)
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.Extra.subscriptions


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
