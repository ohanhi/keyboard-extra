module Main exposing (..)

import Html exposing (Html)
import Html.App as Html
import Keyboard.Extra as Keys


main : Program Never
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeysMsg Keys.Msg


type alias Model =
    { keyboardModel : Keys.Model
    , arrowUpPressed : Bool
    , arrows : { x : Int, y : Int }
    , wasd : { x : Int, y : Int }
    }


init : ( Model, Cmd Msg )
init =
    let
        arr =
            { x = 0, y = 0 }

        ( keyboardModel, keyboardCmd ) =
            Keys.init
    in
        ( Model keyboardModel False arr arr
        , Cmd.map KeysMsg keyboardCmd
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeysMsg keyMsg ->
            let
                ( keyboardModel, keyboardCmd ) =
                    Keys.update keyMsg model.keyboardModel
            in
                ( { model
                    | keyboardModel = keyboardModel
                    , arrowUpPressed = Keys.isPressed Keys.ArrowUp keyboardModel
                    , arrows = keyboardModel.arrows
                    , wasd = keyboardModel.wasd
                  }
                , Cmd.map KeysMsg keyboardCmd
                )


view : Model -> Html msg
view model =
    Html.p []
        [ Html.text ("ArrowUp: " ++ toString model.arrowUpPressed)
        , Html.p []
            [ Html.text ("Arrows: " ++ toString model.arrows)
            ]
        , Html.p []
            [ Html.text ("WASD: " ++ toString model.wasd)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeysMsg Keys.subscriptions
        ]
