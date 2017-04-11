module Main exposing (..)

import Html exposing (Html, p, ul, li, text, div, button)
import Html.Events exposing (onClick)
import Keyboard.Extra as KeyEx


type Msg
    = KeyboardMsg KeyEx.Msg
    | ForceRelease


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.
-}
type alias Model =
    { keyboardState : KeyEx.State
    }


init : ( Model, Cmd Msg )
init =
    ( Model KeyEx.initialState
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | keyboardState = KeyEx.update keyMsg model.keyboardState
              }
            , Cmd.none
            )

        ForceRelease ->
            ( { model
                | keyboardState = KeyEx.forceRelease [ KeyEx.CharA ] model.keyboardState
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    let
        shiftPressed =
            KeyEx.isPressed KeyEx.Shift model.keyboardState

        arrows =
            KeyEx.arrows model.keyboardState

        wasd =
            KeyEx.wasd model.keyboardState

        keyList =
            KeyEx.pressedDown model.keyboardState
    in
        div []
            [ button [ onClick ForceRelease ] [ text "Force release of CharA" ]
            , text ("Shift: " ++ toString shiftPressed)
            , p [] [ text ("Arrows: " ++ toString arrows) ]
            , p [] [ text ("WASD: " ++ toString wasd) ]
            , p [] [ text "Currently pressed down:" ]
            , ul []
                (List.map (\key -> li [] [ text (toString key) ]) keyList)
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg KeyEx.subscriptions


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
