/// <summary>
/// Filter construct Library
/// </summary>
codeunit 50511 "Filter Utility GM"
{
    internal procedure GetFilterForGenreArtists(GenreGM: Record "Genre GM") "Filter": Text
    var
        ArtistGenreGM: Record "Artist Genre GM";

    begin
        ArtistGenreGM.SetRange("Genre Name", GenreGM.Name);
        if not ArtistGenreGM.FindSet() then exit;
        repeat
            "Filter" += ArtistGenreGM."Artist Id" + '|';
        until ArtistGenreGM.Next() = 0;
        "Filter" := RemoveLastChar("Filter");
    end;

    internal procedure GetFilterForArtistAlbums(ArtistGM: Record "Artist GM") "Filter": Text
    var
        AlbumArtistGM: Record "Album Artist GM";
    begin
        AlbumArtistGM.SetRange("Artist ID", ArtistGM.Id);
        if not AlbumArtistGM.FindSet() then exit;
        repeat
            "Filter" += AlbumArtistGM."Album ID" + '|';
        until AlbumArtistGM.Next() = 0;
        "Filter" := CopyStr("Filter", 1, StrLen("Filter") - 1);
    end;

    local procedure RemoveLastChar(String: Text): Text
    begin
        exit(CopyStr(String, 1, StrLen(String) - 1));
    end;
}