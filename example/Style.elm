module Style exposing (..)

import Html
import Html.Attributes exposing (style)


container : Html.Attribute msg
container =
    style
        [ ( "background-color", "rebeccapurple" )
        , ( "color", "white" )
        , ( "font-family", "sans-serif" )
        , ( "width", "100vw" )
        , ( "height", "100vh" )
        , ( "display", "flex" )
        , ( "align-items", "center" )
        , ( "justify-content", "flex-start" )
        , ( "box-sizing", "border-box" )
        , ( "padding", "4em 2em" )
        , ( "flex-direction", "column" )
        ]
