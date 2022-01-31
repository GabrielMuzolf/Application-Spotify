/// <summary>
/// Codeunit used to import information about track
/// </summary>
codeunit 50508 "Import Track GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        TrackId: Text[100];
        Track: JsonObject;

    internal procedure ImportTrack(TrackId: Text[100])
    begin
        SetTrackId(TrackId);
        SetTrack();
        DeleteTrackIfExists();
        ImportTrack();
    end;

    local procedure SetTrackId(_TrackId: Text[100])
    begin
        TrackId := _TrackId;
    end;

    local procedure SetTrack()
    var
        ResponseBody: Text;
    begin
        ResponseBody := SendRequestToGetTrack();
        Track.ReadFrom(ResponseBody);
    end;

    local procedure SendRequestToGetTrack(): Text
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
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
        HttpGM.SetUri('https://api.spotify.com/v1/tracks/' + TrackId);
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure DeleteTrackIfExists()
    var
        TrackGM: Record "Track GM";
    begin
        TrackGM.SetRange(Id, TrackId);
        if not TrackGM.FindFirst() then exit;
        TrackGM.Delete();
    end;

    local procedure ImportTrack()
    var
        TrackGM: Record "Track GM";
    begin
        TrackGM.Init();
        TrackGM.Id := TrackId;
        TrackGM.Name := CopyStr(JSONUtilityGM.GetValueAsText(Track, 'name'), 1, 250);
        TrackGM."Album Id" := CopyStr(JSONUtilityGM.GetValueAsTextFromPath(Track, '$.album.id'), 1, 100);
        TrackGM."Preview Url" := CopyStr(JSONUtilityGM.GetValueAsText(Track, 'preview_url'), 1, 2048);
        SetTrackPicture(TrackGM);
        TrackGM.Insert();
    end;

    local procedure SetTrackPicture(var TrackGM: Record "Track GM")
    var
        MediaUtilityGM: Codeunit "Media Utility GM";
        Images: JsonArray;
        Picture: JsonToken;
    begin
        if not Track.Contains('images') then exit;
        Images := JSONUtilityGM.GetJSONArray(Track, 'images');
        if Images.Count() = 0 then exit;
        Images.Get(0, Picture);
        TrackGM.Picture.ImportStream(MediaUtilityGM.GetPictureFromUrl(GetTrackPictureUrl(Picture.AsObject())), '');
    end;

    local procedure GetTrackPictureUrl(Picture: JsonObject): Text
    begin
        exit(JSONUtilityGM.GetValueAsText(Picture, 'url'));
    end;

}