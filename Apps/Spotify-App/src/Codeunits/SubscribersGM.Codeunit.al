codeunit 50510 "Subscribers GM"
{
    [EventSubscriber(ObjectType::Table, Database::"Album GM", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAlbumTracks(var Rec: Record "Album GM")
    var
        RemovalUtilityGM: Codeunit "Removal Utility GM";
    begin
        RemovalUtilityGM.RemoveTracks(Rec);
        RemovalUtilityGM.RemoveArtistAlbums(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Artist GM", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteArtistAlbums(var Rec: Record "Artist GM")
    var
        RemovalUtilityGM: Codeunit "Removal Utility GM";
    begin
        RemovalUtilityGM.RemoveArtistGenres(Rec);
        RemovalUtilityGM.RemoveAlbums(Rec);
        RemovalUtilityGM.RemoveArtistAlbums(Rec);
    end;
}