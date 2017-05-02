module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (on)
import Keyboard.Extra as Keyboard
import Json.Decode as Json
import Style


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    Maybe Keyboard.Key


init : Model
init =
    Nothing


type Msg
    = KeyPress Keyboard.Key


update : Msg -> Model -> Model
update msg model =
    case msg of
        KeyPress char ->
            Just char


view : Model -> Html Msg
view model =
    div [ Style.container ]
        [ p [] [ text "Enter text below:" ]
        , textarea [ on "keydown" <| Json.map KeyPress Keyboard.targetKey ] []
        , p [] [ text <| toString model ]
        ]
