module Main exposing (..)

import Html exposing (Html, div, p, ul, li, text)
import Keyboard.Extra exposing (Key(..))
import Style


type Msg
    = KeyboardMsg Keyboard.Extra.Msg


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
    ( { pressedKeys = [] }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            ( { model
                | pressedKeys = Keyboard.Extra.update keyMsg model.pressedKeys
              }
            , Cmd.none
            )


view : Model -> Html msg
view model =
    let
        shiftPressed =
            List.member Shift model.pressedKeys

        arrows =
            Keyboard.Extra.arrows model.pressedKeys

        wasd =
            Keyboard.Extra.wasd model.pressedKeys
    in
        div [ Style.container ]
            [ text ("Shift: " ++ toString shiftPressed)
            , p [] [ text ("Arrows: " ++ toString arrows) ]
            , p [] [ text ("WASD: " ++ toString wasd) ]
            , p [] [ text "Currently pressed down:" ]
            , ul []
                (List.map (\key -> li [] [ text (toString key) ]) model.pressedKeys)
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
