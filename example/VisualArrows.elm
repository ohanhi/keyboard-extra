module VisualArrows exposing (..)

import Html exposing (Html, p, div, text)
import Html.App as Html
import Keyboard.Extra as Keyboard


main : Program Never
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
        ( keyboardModel, keyboardCmd ) =
            Keyboard.init
    in
        ( Model keyboardModel Keyboard.NoDirection Keyboard.NoDirection
        , Cmd.map KeyboardMsg keyboardCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keyboard.update keyMsg model.keyboardModel
            in
                ( { model
                    | keyboardModel = keyboardModel
                    , arrows = Keyboard.arrowsDirection keyboardModel
                    , wasd = Keyboard.wasdDirection keyboardModel
                  }
                , Cmd.map KeyboardMsg keyboardCmd
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
