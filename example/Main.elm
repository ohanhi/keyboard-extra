module Main exposing (..)

import Html exposing (Html, p, ul, li, text)
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
    , shiftPressed : Bool
    , arrows : { x : Int, y : Int }
    , wasd : { x : Int, y : Int }
    , keyList : List Keyboard.Key
    }


init : ( Model, Cmd Msg )
init =
    let
        arr =
            { x = 0, y = 0 }

        ( keyboardModel, keyboardCmd ) =
            Keyboard.init
    in
        ( Model keyboardModel False arr arr []
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
                    , shiftPressed = Keyboard.isPressed Keyboard.Shift keyboardModel
                    , arrows = Keyboard.arrows keyboardModel
                    , wasd = Keyboard.wasd keyboardModel
                    , keyList = Keyboard.pressedDown keyboardModel
                  }
                , Cmd.map KeyboardMsg keyboardCmd
                )


view : Model -> Html msg
view model =
    p []
        [ text ("Shift: " ++ toString model.shiftPressed)
        , p [] [ text ("Arrows: " ++ toString model.arrows) ]
        , p [] [ text ("WASD: " ++ toString model.wasd) ]
        , p [] [ text "Currently pressed down:" ]
        , ul []
            (List.map (\key -> li [] [ text (toString key) ]) model.keyList)
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyboardMsg Keyboard.subscriptions
        ]
