module VisualArrows exposing (..)

import Html exposing (Html, p, div, text)
import Keyboard.Extra as Keyboard


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyboardMsg Keyboard.Msg


type alias Model =
    { keyboardModel : Keyboard.Model
    , arrows : Keyboard.Direction
    , wasd : Keyboard.Direction
    }


init : ( Model, Cmd Msg )
init =
    let
        keyboardModel =
            Keyboard.init
    in
        ( Model keyboardModel Keyboard.NoDirection Keyboard.NoDirection
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                keyboardModel =
                    Keyboard.update keyMsg model.keyboardModel
            in
                ( { model
                    | keyboardModel = keyboardModel
                    , arrows = Keyboard.arrowsDirection keyboardModel
                    , wasd = Keyboard.wasdDirection keyboardModel
                  }
                , Cmd.none
                )


view : Model -> Html msg
view model =
    div []
        [ p [] [ text ("Arrows: " ++ toString model.arrows) ]
        , p [] [ text ("WASD: " ++ toString model.wasd) ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ Sub.map KeyboardMsg Keyboard.subscriptions ]
