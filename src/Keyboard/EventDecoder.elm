module Keyboard.EventDecoder exposing (standardKey, BestGuessKey)

import Json.Decode as Json exposing (field, andThen)
import String exposing (uncons)


type BestGuessKey
    = KeyValue Char
    | KeyCode Int


{-| A `Json.Decoder` for grabbing a key/char code by using the event properties
    of the `KeyboardEvent` in an order established after my personal
    understanding of the [MDN-docs](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent)

    It is then also turned into a `BestGuessKey` that carries either a KeyCode,
    or the char value of the key that was typed.

    Bound to "keypress" might return a different result than bound to "keydown" or "keyup"

    How to translate this back into `Key`-values is still an open question.

    For debugging purposes, the decoders are wrapped with a logger to figure
    out easily which one  was successful.

    import Json.Decode as Json
    import Keyboard.EventDecoder as EventDecoder

    onKey : (Key -> msg) -> Attribute msg
    onKey tagger =
      on "keydown" (Json.map tagger EventDecoder.standardKey)
-}
standardKey : Json.Decoder BestGuessKey
standardKey =
    Json.oneOf
        [ logged "1. keyDecoder" (field "key" Json.string |> andThen validKeyValue)
          -- next one only happens on keypress
        , logged "2. charCodeDecoder" (field "charCode" Json.int |> andThen validKeyCode)
        , logged "3. keyCodeDecoder" (field "keyCode" Json.int |> andThen validKeyCode)
        , logged "4. whichDecoder" (field "which" Json.int |> andThen validKeyCode)
        , logged "5. keyIdentifierDecoder" (field "keyIdentifier" Json.int |> andThen validKeyCode)
        , logged "6. charDecoder" (field "char" Json.string |> andThen validKeyValue)
        ]
        |> andThen Json.succeed


logged : String -> Json.Decoder a -> Json.Decoder a
logged message decoder =
    decoder |> andThen (\value -> Json.succeed <| Debug.log message value)


validKeyValue : String -> Json.Decoder BestGuessKey
validKeyValue s =
    if s == "" then
        Json.fail "empty"
    else
        case String.length s of
            1 ->
                case String.uncons s of
                    Nothing ->
                        Json.fail <| "invalid string: " ++ s

                    Just ( c, _ ) ->
                        Json.succeed <| KeyValue c

            _ ->
                if s == "Unidentified" then
                    Json.fail s
                else
                    Json.fail <| "unhandled: " ++ s


validKeyCode : Int -> Json.Decoder BestGuessKey
validKeyCode s =
    if s == 0 then
        Json.fail "0"
    else
        Json.succeed <| KeyCode s
