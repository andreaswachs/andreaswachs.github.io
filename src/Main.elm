module Main exposing (..)

import Browser
import Json.Decode exposing (..)
import Html exposing (pre, text, img)
import Html.Attributes exposing (src)
import Http


-- URL: https://aws.random.cat/meow
main =
    Browser.element
    {
        init = init,
        update = update,
        subscriptions = subscriptions,
        view = view
    }

-- model
type Model = Failure | Loading | Success String

init : () -> (Model, Cmd Msg)
init _ = (Loading, Http.get { url = "https://aws.random.cat/meow", expect = Http.expectString GotText })

-- Update
type Msg = GotText (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
       GotText result ->
        case result of 
            Ok data -> (Success data, Cmd.none)
            Err _ -> (Failure, Cmd.none)


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


-- View : Model -> Html Msg
type alias CatData = 
    {
        file : String
    }

view model = case model of
                    Failure -> text "I was unable to load the cat image :("
                    Loading -> text "Loading.."
                    Success data -> let imgSrc = decodeString (field "file" string) data
                                    in case imgSrc of 
                                            Ok url -> pre [] [img [src url] []]
                                            Err _ -> pre [] [text "Missing image URL!"]