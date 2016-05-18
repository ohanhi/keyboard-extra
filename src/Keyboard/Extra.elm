module Keyboard.Extra
    exposing
        ( subscriptions
        , init
        , update
        , isPressed
        , Key(..)
        , Model
        , Msg
        )

{-| Convenience helpers for working with keyboard inputs.

# Model
@docs Model

# Keyboard key
@docs Key

# Helpers
@docs isPressed

# Wiring
@docs Msg, subscriptions, init, update
-}

import Keyboard exposing (KeyCode)
import Set exposing (Set)
import Keyboard.Arrows as Arrows exposing (Arrows)


{-| -}
type Msg
    = Down KeyCode
    | Up KeyCode


{-| You will need to add this to your program's subscriptions. Otherwise `Keyboard.Extra` won't be able to provide any information.
-}
subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Keyboard.downs Down
        , Keyboard.ups Up
        ]


{-| The set of keys that are currently pressed down.
-}
type alias Model =
    { keysDown : Set KeyCode
    , arrows : Arrows
    , wasd : Arrows
    }


{-| -}
init : ( Model, Cmd Msg )
init =
    ( Model Set.empty Arrows.init Arrows.init, Cmd.none )


{-| You need to call this to have the model update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Down code ->
            let
                keysDown =
                    Set.insert code model.keysDown
            in
                ( { model
                    | keysDown = keysDown
                    , arrows = Arrows.determineArrows keysDown
                    , wasd = Arrows.determineWasd keysDown
                  }
                , Cmd.none
                )

        Up code ->
            let
                keysDown =
                    Set.remove code model.keysDown
            in
                ( { model
                    | keysDown = keysDown
                    , arrows = Arrows.determineArrows keysDown
                    , wasd = Arrows.determineWasd keysDown
                  }
                , Cmd.none
                )


{-| -}
isPressed : Key -> Model -> Bool
isPressed key model =
    Set.member (toCode key) model.keysDown


{-| -}
type Key
    = ArrowLeft
    | ArrowRight
    | ArrowUp
    | ArrowDown
    | Other


codeBook : List ( KeyCode, Key )
codeBook =
    [ ( 37, ArrowLeft )
    , ( 38, ArrowUp )
    , ( 39, ArrowRight )
    , ( 40, ArrowDown )
    ]


fromCode : KeyCode -> Key
fromCode code =
    codeBook
        |> List.filter (((==) code) << fst)
        |> List.map snd
        |> List.head
        |> Maybe.withDefault Other


toCode : Key -> KeyCode
toCode key =
    codeBook
        |> List.filter (((==) key) << snd)
        |> List.map fst
        |> List.head
        |> Maybe.withDefault 0
