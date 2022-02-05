/// <summary>
/// Codeunit used to import information about artist albums
/// </summary>
codeunit 50512 "Import Artist Albums GM"
{
    var
        ArtistId: Text[100];
        Albums: List of [Text[100]];
        TotalNumberOfAlbums: Integer;

    internal procedure ImportArtistAlbums(ArtistId: Text[100])
    begin
        SetArtistId(ArtistId);
        FillAlbumsList();
        ImportAlbums();
    end;

    local procedure SetArtistId(_ArtistId: Text[100])
    begin
        ArtistId := _ArtistId;
    end;

    local procedure FillAlbumsList()
    var
        HttpGM: Codeunit "Http GM";
        ResponseBody: Text;
        Offset: Integer;
    begin
        Offset := 0;
        PrepareRequest(HttpGM, Offset);
        ResponseBody := HttpGM.SendRequestAndGetBody();
        AddAlbumsToList(ResponseBody);
        if TotalNumberOfAlbums > GetLimit() then
            repeat
                Offset += GetLimit();
                PrepareRequest(HttpGM, Offset);
                ResponseBody := HttpGM.SendRequestAndGetBody();
                AddAlbumsToList(ResponseBody);
            until Offset + GetLimit() >= TotalNumberOfAlbums
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
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums
        HttpGM.SetUri('https://api.spotify.com/v1/artists/' + ArtistId + '/albums?limit=' + Format(GetLimit()) + '&offset=' + Format(Offset));
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;


    local procedure AddAlbumsToList(ResponseBody: Text)
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        AlbumsArray: JsonArray;
        AlbumsInfo: JsonObject;
        Album: JsonToken;
        i: Integer;
    begin
        AlbumsInfo.ReadFrom(ResponseBody);
        TotalNumberOfAlbums := JSONUtilityGM.GetValueAsInteger(AlbumsInfo, 'total');
        ALbumsArray := JSONUtilityGM.GetJSONArray(AlbumsInfo, 'items');
        if AlbumsArray.Count() = 0 then exit;
        for i := 0 to AlbumsArray.Count() - 1 do begin
            AlbumsArray.Get(i, Album);
            Albums.Add(CopyStr(JSONUtilityGM.GetValueAsText(Album.AsObject(), 'id'), 1, 100));
        end;
    end;

    local procedure ImportAlbums()
    var
        ImportAlbumGM: Codeunit "Import Album GM";
        ImportAlbumTracksGM: Codeunit "Import Album Tracks GM";
        Dialog: Dialog;
        DialogMsg: Label 'Importing Artist: #1#################\ Importing album: #2### Total: #3###.', Comment = '#1 = Artist Name, #2 = Number of importing album, #3 = Total number of albums to import';
        ArtistName: Text[250];
        i: Integer;
    begin
        if Albums.Count() = 0 then exit;
        ArtistName := GetArtistName(ArtistId);
        Dialog.Open(DialogMsg, ArtistName, i, TotalNumberOfAlbums);
        for i := 1 to Albums.Count() do begin
            Dialog.Update();
            ImportAlbumGM.ImportAlbum(Albums.Get(i));
            ImportAlbumTracksGM.ImportAlbumTracks(Albums.Get(i));
        end;
        Dialog.Close();
    end;

    local procedure GetLimit(): Integer
    begin
        exit(50);
    end;

    local procedure GetArtistName(ArtistId: Text[100]): Text[250]
    var
        ArtistGM: Record "Artist GM";
    begin
        if ArtistGm.Get(ArtistId) then
            exit(ArtistGM.Name);
    end;
}