/// <summary>
/// Codeunit used to import information about artist, his albums and tracks
/// </summary>
codeunit 50506 "Import Artist GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        ArtistId: Text[100];

    internal procedure ImportArtist(ArtistId: Text[100]; IncludeArtistAlbums: Boolean)
    var
        Artist: JsonObject;
    begin
        // What if artist exist? Replace? Modify?
        // get info about artist from spotify and insert record
        // insert dependency artist | genre to have search table
        // get info about albums 
        // for each album get tracks
        SetArtistId(ArtistId);
        Artist := GetArtist();
        ImportArtist(Artist);
    end;

    local procedure SetArtistId(_ArtistId: Text[100])
    begin
        ArtistId := _ArtistId;
    end;

    local procedure GetArtist() Artist: JsonObject
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

    local procedure ImportArtist(Artist: JsonObject)
    var
        ArtistGM: Record "Artist GM";
    begin
        ArtistGM.Init();
        ArtistGM.Id := CopyStr(ArtistId, 1, 100);
        ArtistGM.Name := CopyStr(JSONUtilityGM.GetValueAsText(Artist, 'name'), 1, 100);
        SetArtistPicture(ArtistGM, Artist);
        ArtistGM.Followers := JSONUtilityGM.GetValueAsIntegerFromPath(Artist, '$.followers.total');
        ArtistGM.Popularity := JSONUtilityGM.GetValueAsInteger(Artist, 'popularity');
        ArtistGM.Insert();
    end;

    local procedure SetArtistPicture(var ArtistGM: Record "Artist GM"; Artist: JsonObject)
    var
        MediaUtilityGM: Codeunit "Media Utility GM";
        Images: JsonArray;
        Picture: JsonToken;
    begin
        Images := JSONUtilityGM.GetJSONArray(Artist, 'images');
        if Images.Count() = 0 then exit;
        Images.Get(0, Picture);
        ArtistGM.Picture.ImportStream(MediaUtilityGM.GetPictureFromUrl(GetPictureUrl(Picture.AsObject())), '');
    end;

    local procedure GetPictureUrl(Picture: JsonObject): Text
    begin
        exit(JSONUtilityGM.GetValueAsText(Picture, 'url'));
    end;
}