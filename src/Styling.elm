module Styling exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)

--#FFCB77 yellow
--#D63230  red
--#0A2342  oxford blue

mainStyle : List (Attribute msg)
mainStyle =
  [ align "center"
  , style "background-color" "#FFCB77"
  , style "height" "100vh" 
  , style "display" "flex"
  , style "flex-direction" "column"
  ]

h1Style : List (Attribute msg)
h1Style = 
  [ style "color" "#0A2342"
  , style "font-family" "Helvetica Neue, sans-serif"
  , style "font-size" "80px"
  , style "font-weight" "bold"
  , style "letter-spacing" "-1px"
  , style "line-height" "1"
  , style "text-align" "center"
  ]

inputStyle : List (Attribute msg)
inputStyle =
  [ style "display" "block"
  , style "width" "260px"
  , style "padding" "12px 20px"
  , style "margin-top" "50px"
  , style "margin-bottom" "20px"
  , style "border-radius" "4px"
  ]

nameButtonStyle : List (Attribute msg)
nameButtonStyle =
  [ style "color" "white"
  , style "padding" "14px 20px"
  , style "margin-top" "10px"
  , style "margin-right" "5px"
  , style "margin-left" "5px"
  , style "border-radius" "4px"
  , style "font-size" "16px"
  ]
addButtonStyle : List (Attribute msg)
addButtonStyle =
  [ style "color" "white"
  , style "padding" "14px 20px"
  , style "margin-top" "20px"
  , style "margin-right" "5px"
  , style "margin-left" "5px"
  , style "margin-bottom" "20px"
  , style "border-radius" "4px"
  , style "font-size" "16px"
  ]