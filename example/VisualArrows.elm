module VisualArrows exposing (..)

import Html exposing (Html, p, div, text)
import Html.Attributes exposing (style)
import Keyboard.Extra exposing (Key, Direction(..))
import Style


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
        div [ Style.container ]
            [ div []
                [ p [] [ text ("Arrows: " ++ toString arrows) ]
                , directionView arrows
                ]
            , div
                []
                [ p [] [ text ("WASD: " ++ toString wasd) ]
                , directionView wasd
                ]
            ]


directionView : Direction -> Html msg
directionView direction =
    let
        angle =
            directionToAngle direction
                |> toString

        char =
            case direction of
                NoDirection ->
                    "🞄"

                _ ->
                    "↑"
    in
        p
            [ style
                [ ( "transform", "rotate(" ++ angle ++ "rad)" )
                , ( "width", "1em" )
                , ( "height", "1em" )
                , ( "line-height", "1" )
                , ( "text-align", "center" )
                , ( "margin", "auto" )
                , ( "font-size", "10em" )
                ]
            ]
            [ text char
            ]


directionToAngle : Direction -> Float
directionToAngle direction =
    case direction of
        North ->
            0

        NorthEast ->
            pi * 0.25

        East ->
            pi * 0.5

        SouthEast ->
            pi * 0.75

        South ->
            pi * 1

        SouthWest ->
            pi * 1.25

        West ->
            pi * 1.5

        NorthWest ->
            pi * 1.75

        NoDirection ->
            0


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.Extra.subscriptions
