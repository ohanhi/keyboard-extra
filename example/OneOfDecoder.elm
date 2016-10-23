module OneOfDecoder exposing (..)

import Html exposing (..)
import Html.Events exposing (on)
import Keyboard.EventDecoder as EventDecoder exposing (standardKey, BestGuessKey)
import Json.Decode as Json


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }


type alias Model =
    { down : Maybe BestGuessKey
    , press : Maybe BestGuessKey
    , up : Maybe BestGuessKey
    }


init : Model
init =
    Model Nothing Nothing Nothing


type Msg
    = Down BestGuessKey
    | Press BestGuessKey
    | Up BestGuessKey


update : Msg -> Model -> Model
update msg model =
    case msg of
        Down char ->
            { model | down = Just char }

        Press char ->
            { model | press = Just char }

        Up char ->
            { model | up = Just char, press = Nothing, down = Nothing }


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text "Enter text below:" ]
        , textarea
            [ on "keydown" <| Json.map Down standardKey
            , on "keypress" <| Json.map Press standardKey
            , on "keyup" <| Json.map Up standardKey
            ]
            []
        , div [] <| viewKeys model
        ]


viewKeys model =
    [ (,) "Down" model.down
    , (,) "Press" model.press
    , (,) "Up" model.up
    ]
        |> List.map (\( l, m ) -> div [] [ text <| l ++ ": " ++ (toString m) ])
