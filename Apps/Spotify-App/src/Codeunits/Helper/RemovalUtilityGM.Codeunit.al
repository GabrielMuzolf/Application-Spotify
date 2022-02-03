/// <summary>
/// Data removal utility library
/// </summary>
codeunit 50509 "Removal Utility GM"
{
    internal procedure RemoveTracksForAlbum(AlbumGM: Record "Album GM")
    var
        TrackGM: Record "Track GM";
    begin
        TrackGM.SetRange("Album Id", AlbumGM.Id);
        if TrackGM.FindSet() then
            TrackGM.DeleteAll();
    end;

    internal procedure RemoveArtistGenres(ArtistGM: Record "Artist GM")
    var
        ArtistGenreGM: Record "Artist Genre GM";
    begin
        ArtistGenreGM.SetRange("Artist Id", ArtistGM.Id);
        if not ArtistGenreGM.FindSet() then
            ArtistGenreGM.DeleteAll();
    end;

    internal procedure RemoveArtistAlbums(ArtistGM: Record "Artist GM")
    var
        AlbumGM: Record "Album GM";
        FilterUtilityGM: Codeunit "Filter Utility GM";
    begin
        AlbumGM.SetFilter(Id, FilterUtilityGM.GetFilterForArtistAlbums(ArtistGM));
        if AlbumGM.FindSet() then
            AlbumGM.DeleteAll();
    end;
}