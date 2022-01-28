/// <summary>
/// Codeunit used to import predefined Spotify genres into the table.
/// </summary>
codeunit 50503 "Import Genres GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";

    internal procedure ImportGenres()
    var
        Genres: JsonArray;
    begin
        TruncateGenresTable();
        Genres := GetGenresArray();
        ImportGenres(Genres);
    end;

    local procedure TruncateGenresTable()
    var
        GenreGM: Record "Genre GM";
    begin
        GenreGM.DeleteAll();
    end;

    local procedure GetGenresArray() Categories: JsonArray;
    var
        Response: JsonObject;
    begin
        Response.ReadFrom(SendRequestToGetGenres());
        Categories := JSONUtilityGM.GetJSONArray(Response, 'genres');
    end;

    local procedure SendRequestToGetGenres(): Text
    var
        HttpGM: Codeunit "Http GM";
    begin
        PrepareRequest(HttpGM);
        exit(HttpGM.SendRequestAndGetBody());
    end;

    local procedure PrepareRequest(var HttpGM: Codeunit "Http GM")
    var
        GenerateTokenGM: Codeunit "Generate Token GM";
        HttpMethodGM: Enum "Http Method GM";
        Token: Text;
    begin
        Clear(HttpGM);
        Token := GenerateTokenGM.GenerateToken();
        HttpGM.SetHttpMethod(HttpMethodGM::GET);
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendation-genres
        HttpGM.SetUri('https://api.spotify.com/v1/recommendations/available-genre-seeds');
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure ImportGenres(Genres: JsonArray)
    var
        Genre: JsonToken;
        GenreName: JsonValue;
        i: Integer;
    begin
        if Genres.Count() = 0 then exit;
        for i := 0 to Genres.Count() - 1 do begin
            Genres.Get(i, Genre);
            GenreName := Genre.AsValue();
            ImportGenre(GenreName.AsText());
        end;
    end;

    local procedure ImportGenre(GenreName: Text)
    var
        GenreGM: Record "Genre GM";
    begin
        GenreGM.Init();
        GenreGM.Name := CopyStr(GenreName, 1, 50);
        if GenreGM.Insert() then;
    end;
}

