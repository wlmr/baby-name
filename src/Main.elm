module Main exposing (..)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import List exposing (filter)
import Http
import Json.Decode exposing (Decoder, field, string)
import Json.Encode
import Styling exposing (addButtonStyle, h1Style, nameButtonStyle, inputStyle)
import Styling exposing (mainStyle)


-- MAIN

main : Program () Model Msg
main =
  Browser.element 
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }


-- MODEL

type alias Model = 
  { names: List Name
  , inputName: String
  , inputGender: Gender
  }

type alias Name = 
  { name: String
  , gender: Gender
  }

type Gender = Male | Female

init : () -> (Model, Cmd Msg)
init _ = 
  ( Model [] "" Male
  , Http.get
      { url = "http://localhost:3000/names"
      , expect = Http.expectJson GotNames responseToNames
      }
  )

genderToText : Gender -> String
genderToText gender =
  case gender of
    Male   -> "Boy"
    Female -> "Girl"

genderToColour : Gender -> String
genderToColour gender =
  case gender of
    Male   -> "#4D9DE0"
    Female -> "#FFC1CF"


-- UPDATE

type Msg
  = Remove String
  | Add Name 
  | InputName String
  | InputGender Gender
  | GotNames (Result Http.Error (List Name)) 
  | Saved (Result Http.Error ())

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add name -> 
      case name.name of
        "" -> ( model, Cmd.none )
        _  -> ( { model | names = ( Name name.name name.gender ) :: model.names
                , inputName = "" }
              , addNameToServer name )
    Remove name -> ( { model | names = filter ( \n -> n.name /= name ) model.names }
                    , removeNameFromServer name )
    InputName name -> ( { model | inputName = name }, Cmd.none )
    InputGender gender -> ( { model | inputGender = gender }, Cmd.none )
    GotNames result -> 
      case result of 
        Ok names -> ( { model | names = names}, Cmd.none )
        Err _ -> ( model , Cmd.none )
    Saved _ -> ( model, Cmd.none )

addNameToServer : Name -> Cmd Msg
addNameToServer name = 
  Http.post 
    { url = "http://localhost:3000/names"
    , body = Http.jsonBody (nameEncoder name)
    , expect = Http.expectWhatever Saved 
    }

removeNameFromServer : String -> Cmd Msg
removeNameFromServer name = 
  Http.request 
    { method = "DELETE"
    , headers = []
    , url = "http://localhost:3000/names/" ++ name
    , body = Http.emptyBody
    , expect = Http.expectWhatever Saved 
    , timeout = Nothing
    , tracker = Nothing 
    }


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


-- VIEW

title : String
title = "Wilmer's Name Selector"

view : Model -> Html Msg
view model =
  div mainStyle 
    [ h1 h1Style [ text title ]
    , makeNameButtons model
    , div 
        [ style "margin" "10px" ] 
        [ makeInputField model
        , makeGenderButtons model
        , makeAddButton model
        ]
  ]

makeInputField : Model -> Html Msg
makeInputField model = 
  input
    ( inputStyle ++ [ placeholder "Add a name"
                    , onInput InputName
                    , value model.inputName 
                    ]
    ) []

makeNameButtons : Model -> Html Msg 
makeNameButtons model =
  let 
    nameToButton =
      (\name ->
        button 
          ( nameButtonStyle ++ 
            [ onClick (Remove name.name)
            , style "background-color" (genderToColour name.gender) 
            ]
          ) 
          [ text name.name ])
  in
    div [] ( List.map nameToButton model.names )

makeGenderButtons : Model -> Html Msg
makeGenderButtons model =
  div [] 
    ( List.map ( \gender -> 
      label []
        [ input 
            [ type_ "radio" 
            , onClick (InputGender gender)
            , checked (gender == model.inputGender) 
            ] 
            []
        , text (genderToText gender)
        ] ) [Male, Female])

makeAddButton : Model -> Html Msg
makeAddButton model = 
  let 
    backgroundColor =
      if model.inputName /= ""
        then (genderToColour model.inputGender)
        else "#BBBBBB"
    styling = addButtonStyle ++ [ style "background-color" backgroundColor ]
    attributes = ( onClick (Add (Name model.inputName model.inputGender)) :: styling )  
  in
    button attributes [ text "Add name" ]


--DECODERS

responseToNames : Decoder (List Name)
responseToNames = Json.Decode.list nameDecoder 

nameDecoder : Decoder Name
nameDecoder = 
  Json.Decode.map2 Name
    (field "name" string)
    (field "gender" genderDecoder)

genderDecoder : Decoder Gender
genderDecoder =
  string
    |> Json.Decode.andThen (\str ->
        case str of
            "male" ->
                Json.Decode.succeed Male
            "female" ->
                Json.Decode.succeed Female
            somethingElse ->
                Json.Decode.fail <| "Unknown theme: " ++ somethingElse
    )

nameEncoder : Name -> Json.Encode.Value
nameEncoder name =
 Json.Encode.object
  [ ("name", Json.Encode.string name.name)
  , ("gender", Json.Encode.string (case name.gender of
        Male -> "male"
        Female -> "female")) 
  ]

