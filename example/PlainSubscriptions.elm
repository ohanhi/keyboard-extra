module PlainSubscriptions exposing (..)

import Html exposing (Html, div, p, ul, li, text)
import Keyboard.Extra exposing (Key)


{- Subscribing to keyboard events without the full TEA pattern. -}


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.Extra.downs KeyDown
        , Keyboard.Extra.ups KeyUp
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = KeyDown Key
    | KeyUp Key


type alias Model =
    { events : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( { model | events = (toString msg) :: model.events }
    , Cmd.none
    )


view : Model -> Html msg
view model =
    div []
        [ p [] [ text "Try pressing, releasing and long-pressing keys." ]
        , keysView model
        ]


keysView : Model -> Html msg
keysView model =
    model.events
        |> List.map (\event -> li [] [ text event ])
        |> ul []
