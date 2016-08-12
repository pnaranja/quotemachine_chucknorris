module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (..)
import Html.Attributes exposing (..)

import Http

-- Task is like a JS promise -> describe async behavior
import Task exposing (Task)



main : Program Never
main =
    Html.program { init = init, update = update, subscriptions = \_ -> Sub.none, view = view }



{-
   Model
   - Init model with empty values
-}


type alias Model =
    { quote : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", fetchRandomQuoteCmd )



{-
   Update
-}


type Msg
    = GetQuote
        | FetchQuoteSuccess String
        | HttpError Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetQuote ->
            ( model, fetchRandomQuoteCmd )

        FetchQuoteSuccess newQuote ->
            ({model|quote = newQuote}, Cmd.none)

        HttpError _ ->
            (model,Cmd.none)


-- API Request URLs
api : String
api = "http://localhost:3001/"


randomQuoteUrl : String
randomQuoteUrl = api ++ "api/random-quote"


-- The Chuck Norris random quote API returns strings and not json
-- Get Random quote
-- Platform.Task (if error) (if success)
fetchRandomQuote : Platform.Task Http.Error String
fetchRandomQuote = 
    -- Send Get Request to URL
    -- String -> Task Error String
    Http.getString randomQuoteUrl


-- A command is needed to request the effect (The effect (Http) is outside of this program)
-- A message is needed to NOTIFY THE UPDATE that the effect was completed and to deliver its results.
fetchRandomQuoteCmd : Cmd Msg
fetchRandomQuoteCmd = 
    -- Task.perform (if error) (if success) task
    Task.perform HttpError FetchQuoteSuccess fetchRandomQuote


{-
   View
-}


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h2 [ class "text-center" ] [ text "Chuck Norris Quotes" ]
        , p [ class "text-center" ]
            [ button [ class "btn btn-success", onClick GetQuote ] [ text "Grab a quote" ] ]
          --Blockquote with quote
        , blockquote [] [ p [] [ text model.quote ] ]
        ]
