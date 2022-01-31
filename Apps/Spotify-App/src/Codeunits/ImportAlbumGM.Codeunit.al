/// <summary>
/// Codeunit used to import information about album and album tracks
/// </summary>
codeunit 50507 "Import Album GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        AlbumID: Text[100];
        Album: JsonObject;

    internal procedure ImportAlbum(AlbumID: Text[100]; IncludeAlbumTracks: Boolean)
    begin
        SetAlbumID(AlbumID);
        SetAlbum();
        DeleteAlbumIfExists();
        ImportAlbum();
        ImportAlbumArtists();
        //TODO import album tracks if needed
    end;

    local procedure SetAlbumID(_AlbumID: Text[100])
    begin
        AlbumID := _AlbumID;
    end;

    local procedure SetAlbum()
    var
        ResponseBody: Text;
    begin
        ResponseBody := SendRequestToGetAlbum();
        Album.ReadFrom(ResponseBody);
    end;

    local procedure SendRequestToGetAlbum(): Text
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
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album
        HttpGM.SetUri('https://api.spotify.com/v1/albums/' + AlbumID);
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure DeleteAlbumIfExists()
    var
        AlbumGM: Record "Album GM";
    begin
        AlbumGM.SetRange(Id, AlbumID);
        if not AlbumGM.FindFirst() then exit;
        AlbumGM.Delete();
        //TODO add on insert trigger to delete related informations
    end;

    local procedure ImportAlbum()
    var
        AlbumGM: Record "Album GM";
    begin
        AlbumGM.Init();
        AlbumGM.Id := AlbumID;
        AlbumGM.Name := CopyStr(JSONUtilityGM.GetValueAsText(Album, 'name'), 1, 250);
        AlbumGM."Total Tracks" := JSONUtilityGM.GetValueAsInteger(Album, 'total_tracks');
        AlbumGM.Popularity := JSONUtilityGM.GetValueAsInteger(Album, 'popularity');
        SetAlbumPicture(AlbumGM);
        AlbumGM.Insert();
    end;

    local procedure SetAlbumPicture(var AlbumGM: Record "Album GM")
    var
        MediaUtilityGM: Codeunit "Media Utility GM";
        Images: JsonArray;
        Picture: JsonToken;
    begin
        //TODO maybe use path instead of array? SOmethin like $.images.url[0]?
        Images := JSONUtilityGM.GetJSONArray(Album, 'images');
        if Images.Count() = 0 then exit;
        Images.Get(0, Picture);
        AlbumGM.Picture.ImportStream(MediaUtilityGM.GetPictureFromUrl(GetAlbumUrl(Picture.AsObject())), '');
    end;

    local procedure GetAlbumUrl(Picture: JsonObject): Text
    begin
        exit(JSONUtilityGM.GetValueAsText(Picture, 'url'));
    end;

    local procedure ImportAlbumArtists()
    var
        Artists: JsonArray;
        Artist: JsonToken;
        ArtistID: JsonToken;
        i: Integer;
    begin
        Artists := JSONUtilityGM.GetJSONArray(Album, 'artists');
        if Artists.Count() = 0 then exit;
        for i := 0 to Artists.Count() - 1 do begin
            Artists.Get(i, Artist);
            Artist.AsObject().Get('id', ArtistID);
            ImportAlbumArtist(ArtistID.AsValue().AsText());
        end;
    end;

    local procedure ImportAlbumArtist(ArtistID: Text)
    var
        AlbumArtistGM: Record "Album Artist GM";
    begin
        AlbumArtistGM.Init();
        AlbumArtistGM."Album ID" := AlbumID;
        AlbumArtistGM."Artist ID" := CopyStr(ArtistID, 1, 100);
        AlbumArtistGM.Insert();
    end;
}
