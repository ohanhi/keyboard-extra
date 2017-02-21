module TrackingKeyChanges exposing (..)

import Html exposing (Html, div, p, ul, li, text)
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
    , keyChanges : List Keyboard.KeyChange
    }


init : ( Model, Cmd Msg )
init =
    ( Model Keyboard.model []
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyboardMsg keyMsg ->
            let
                ( keyboardModel, maybeKeyChange ) =
                    Keyboard.updateWithKeyChange keyMsg model.keyboardModel

                keyChanges =
                    case maybeKeyChange of
                        Just keyChange ->
                            keyChange :: model.keyChanges

                        Nothing ->
                            model.keyChanges
            in
                ( { model
                    | keyboardModel = keyboardModel
                    , keyChanges = keyChanges
                  }
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
    model.keyChanges
        |> List.map (\change -> li [] [ text (toString change) ])
        |> ul []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map KeyboardMsg Keyboard.subscriptions
