/// <summary>
/// Codeunit used to import information about artist, his albums and tracks
/// </summary>
codeunit 50506 "Import Artist GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        Artist: JsonObject;
        ArtistId: Text[100];

    internal procedure ImportArtist(ArtistId: Text[100]; IncludeArtistAlbums: Boolean)
    begin
        SetArtistId(ArtistId);
        SetArtist();
        DeleteArtistIfExists();
        ImportArtist();
        ImportArtistGenres();
        //TODO import artis albums if needed
    end;

    local procedure SetArtistId(_ArtistId: Text[100])
    begin
        ArtistId := _ArtistId;
    end;

    local procedure DeleteArtistIfExists()
    var
        ArtistGM: Record "Artist GM";
    begin
        ArtistGM.SetRange(Id, ArtistId);
        if not ArtistGM.FindFirst() then exit;
        ArtistGM.Delete();
    end;

    local procedure SetArtist()
    var
        ResponseBody: Text;
    begin
        ResponseBody := SendRequestToGetArtist();
        Artist.ReadFrom(ResponseBody);
    end;

    local procedure SendRequestToGetArtist(): Text
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
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist
        HttpGM.SetUri('https://api.spotify.com/v1/artists/' + ArtistId);
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure ImportArtist()
    var
        ArtistGM: Record "Artist GM";
    begin
        ArtistGM.Init();
        ArtistGM.Id := ArtistId;
        ArtistGM.Name := CopyStr(JSONUtilityGM.GetValueAsText(Artist, 'name'), 1, 250);
        SetArtistPicture(ArtistGM);
        ArtistGM.Followers := JSONUtilityGM.GetValueAsIntegerFromPath(Artist, '$.followers.total');
        ArtistGM.Popularity := JSONUtilityGM.GetValueAsInteger(Artist, 'popularity');
        ArtistGM.Insert();
    end;

    local procedure SetArtistPicture(var ArtistGM: Record "Artist GM")
    var
        MediaUtilityGM: Codeunit "Media Utility GM";
        Images: JsonArray;
        Picture: JsonToken;
    begin
        //TODO check before if images exists in all functions
        Images := JSONUtilityGM.GetJSONArray(Artist, 'images');
        if Images.Count() = 0 then exit;
        Images.Get(0, Picture);
        ArtistGM.Picture.ImportStream(MediaUtilityGM.GetPictureFromUrl(GetPictureUrl(Picture.AsObject())), '');
    end;

    local procedure GetPictureUrl(Picture: JsonObject): Text
    begin
        exit(JSONUtilityGM.GetValueAsText(Picture, 'url'));
    end;

    local procedure ImportArtistGenres()
    var
        Genres: JsonArray;
        Genre: JsonToken;
        GenreName: JsonValue;
        i: Integer;
    begin
        //TODO check before if genres exists
        Genres := JSONUtilityGM.GetJSONArray(Artist, 'genres');
        if Genres.Count() = 0 then exit;
        for i := 0 to Genres.Count() - 1 do begin
            Genres.Get(i, Genre);
            GenreName := Genre.AsValue();
            ImportArtistGenre(GenreName.AsText())
        end;
    end;

    local procedure ImportArtistGenre(GenreName: Text)
    var
        ArtistGenreGM: Record "Artist Genre GM";
    begin
        ArtistGenreGM.Init();
        ArtistGenreGM."Artist Id" := ArtistId;
        ArtistGenreGM."Genre Name" := CopyStr(GenreName, 1, 50);
        ArtistGenreGM.Insert();
    end;
}