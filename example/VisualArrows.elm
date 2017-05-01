module VisualArrows exposing (..)

import Html exposing (Html, p, div, text)
import Keyboard.Extra exposing (Key)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyboardMsg Keyboard.Extra.Msg


type alias Model =
    { pressedKeys : List Key
    , arrows : Keyboard.Extra.Direction
    , wasd : Keyboard.Extra.Direction
    }


init : ( Model, Cmd Msg )
init =
    ( Model Keyboard.Extra.initialState Keyboard.Extra.NoDirection Keyboard.Extra.NoDirection
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
        arrows =
            Keyboard.Extra.arrowsDirection model.pressedKeys

        wasd =
            Keyboard.Extra.wasdDirection model.pressedKeys
    in
        div []
            [ p [] [ text ("Arrows: " ++ toString arrows) ]
            , p [] [ text ("WASD: " ++ toString wasd) ]
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.Extra.subscriptions
