/// <summary>
/// Codeunit used to import information about album tracks
/// </summary>
codeunit 50513 "Import Album Tracks GM"
{
    var
        AlbumId: Text[100];
        Tracks: List of [Text[100]];
        TotalNumberOfTracks: Integer;

    internal procedure ImportAlbumTracks(AlbumId: Text[100])
    begin
        SetAlbumId(AlbumId);
        FillTrackList();
        ImportTracks();
    end;

    local procedure SetAlbumId(_AlbumId: Text[100])
    begin
        AlbumId := _AlbumId;
    end;

    local procedure FillTrackList()
    var
        HttpGM: Codeunit "Http GM";
        ResponseBody: Text;
        Offset: Integer;
    begin
        Offset := 0;
        PrepareRequest(HttpGM, Offset);
        ResponseBody := HttpGM.SendRequestAndGetBody();
        AddTrackToList(ResponseBody);
        if TotalNumberOfTracks > GetLimit() then
            repeat
                Offset += GetLimit();
                PrepareRequest(HttpGM, Offset);
                ResponseBody := HttpGM.SendRequestAndGetBody();
                AddTrackToList(ResponseBody);
            until Offset + GetLimit() >= TotalNumberOfTracks
    end;

    local procedure PrepareRequest(var HttpGM: Codeunit "Http GM"; Offset: Integer)
    var
        GenerateTokenGM: Codeunit "Generate Token GM";
        HttpMethodGM: Enum "Http Method GM";
        Token: Text;
    begin
        Clear(HttpGM);
        Token := GenerateTokenGM.GenerateToken();
        HttpGM.SetHttpMethod(HttpMethodGM::GET);
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks
        HttpGM.SetUri('https://api.spotify.com/v1/albums/' + AlbumId + '/tracks?limit=' + Format(GetLimit()) + '&offset=' + Format(Offset));
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure AddTrackToList(ResponseBody: Text)
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        TracksArray: JsonArray;
        TrackInfo: JsonObject;
        Track: JsonToken;
        i: Integer;
    begin
        TrackInfo.ReadFrom(ResponseBody);
        TotalNumberOfTracks := JSONUtilityGM.GetValueAsInteger(TrackInfo, 'total');
        TracksArray := JSONUtilityGM.GetJSONArray(TrackInfo, 'items');
        if TracksArray.Count() = 0 then exit;
        for i := 0 to TracksArray.Count() - 1 do begin
            TracksArray.Get(i, Track);
            Tracks.Add(CopyStr(JSONUtilityGM.GetValueAsText(Track.AsObject(), 'id'), 1, 100));
        end;
    end;

    local procedure ImportTracks()
    var
        ImportTrackGM: Codeunit "Import Track GM";
        i: Integer;
    begin
        if Tracks.Count() = 0 then exit;
        for i := 1 to Tracks.Count() do
            ImportTrackGM.ImportTrack(Tracks.Get(i));
    end;

    local procedure GetLimit(): Integer
    begin
        exit(50);
    end;
}