module Main exposing (..)

import Html exposing (Html, p, ul, li, text, div, button)
import Html.Events exposing (onClick)
import Keyboard.Extra as KeyEx exposing (Key)


type Msg
    = KeyboardMsg KeyEx.Msg
    | ForceRelease


{-| We don't need any other info in the model, since we can get everything we
need using the helpers right in the `view`!

This way we always have a single source of truth, and we don't need to remember
to do anything special in the update.
-}
type alias Model =
    { pressedKeys : List Key
    }


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | pressedKeys = KeyEx.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )

        ForceRelease ->
            ( { model
                | pressedKeys = List.filter ((/=) KeyEx.CharA) model.pressedKeys
              }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    let
        shiftPressed =
            KeyEx.isPressed KeyEx.Shift model.pressedKeys

        arrows =
            KeyEx.arrows model.pressedKeys

        wasd =
            KeyEx.wasd model.pressedKeys
    in
        div []
            [ button [ onClick ForceRelease ] [ text "Force release of CharA" ]
            , text ("Shift: " ++ toString shiftPressed)
            , p [] [ text ("Arrows: " ++ toString arrows) ]
            , p [] [ text ("WASD: " ++ toString wasd) ]
            , p [] [ text "Currently pressed down:" ]
            , ul []
                (List.map (\key -> li [] [ text (toString key) ]) model.pressedKeys)
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
