module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (id, class)
import Http
import Json.Decode exposing (list, field)
import Markdown.Option exposing (..)
import Markdown.Render exposing (MarkdownMsg(..), MarkdownOutput(..))

-- type aliases 
-- content data 
type alias Post = 
    { id: Int
    , date: String
    , title: String
    , body: String
    }

type alias Posts = 
    { posts: List Post }

main : Program () Model Msg
main =
    Browser.element
    {
        init = init,
        update = update,
        subscriptions = subscriptions,
        view = view
    }

-- model
type Model = Failure Http.Error | Loading | Success (List Post)

init : () -> (Model, Cmd Msg)
init _ = (Loading, Http.get { url = contentFile, expect = Http.expectJson GotData postsDecoder })
--init _ = (Loading, Http.get { url = "https://aws.random.cat/meow", expect = Http.expectString GotData })



-- Update
type Msg =
    GotData (Result Http.Error (List Post))
    | MarkdownMsg Markdown.Render.MarkdownMsg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
       GotData result ->
            case result of 
                Ok data -> (Success data, Cmd.none)
                Err errMsg -> (Failure errMsg, Cmd.none)
       MarkdownMsg _ -> (model, Cmd.none)


-- Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none



-- View : Model -> Html Msg
view model = case model of
                    Failure msg -> case msg of
                        Http.BadUrl str -> text <| "Bad url: " ++ str
                        Http.BadStatus _ -> text "bad statuxs"
                        Http.Timeout -> text "time out!"
                        Http.BadBody errMsg -> text <| "bad body" ++ errMsg
                        _ -> text "it was something else!"
    

                    Loading -> text "Loading.."
                    Success data -> 
                        div [] (List.map printPost data)


printPost : Post -> Html Msg
printPost post = 
    div [ class "post" ] 
        [ div [ class "post-title" ] 
              [ h2 [] [ text post.title ] ]
        , div [ class "small post-date" ] 
              [ span [] [ text <| "Posted on: " ++ post.date]]
        , div [ class "post-body"] [ 
                p [ class "fs-5 lh-base"] 
                    [ Markdown.Render.toHtml ExtendedMath post.body |> 
                                    Html.map MarkdownMsg ]]]
 
postsDecoder = 
    list postDecoder
postDecoder =
    Json.Decode.map4
        Post
            (field "id" Json.Decode.int)
            (field "date" Json.Decode.string)
            (field "title" Json.Decode.string)
            (field "body" Json.Decode.string)

baseUrl : String
baseUrl = "./"

dataDir : String
dataDir = baseUrl ++ "data/"

contentFile : String
contentFile = dataDir ++ "content.json"








