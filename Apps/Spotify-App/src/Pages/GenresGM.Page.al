page 50502 "Genres GM"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Genre GM";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Genres)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies genre name';
                    Caption = 'Name';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Genres")
            {
                ApplicationArea = All;
                ToolTip = 'Run this action to import predefined Spitify genres';
                trigger OnAction()
                var
                    ImportCategoriesGM: Codeunit "Import Genres GM";
                begin
                    ImportCategoriesGM.ImportGenres();
                end;
            }
            action("Artist")
            {
                ApplicationArea = All;
                ToolTip = 'Run this action to see artist for specified genre';
                trigger OnAction()
                begin
                    OpenArtistPageForGenre();
                end;
            }
        }
    }

    local procedure OpenArtistPageForGenre()
    var
        ArtistGM: Record "Artist GM";
        ArtistGenreGM: Record "Artist Genre GM";
        ArtistsGM: Page "Artists GM";
    begin
        ArtistGenreGM.SetRange("Genre Name", Rec.Name);
        if not ArtistGenreGM.FindSet() then begin
            Message('There is no artist for this genre');
            exit;
        end;
        ArtistGM.SetFilter(Id, ConstructFilterWithArtistId(ArtistGenreGM));
        ArtistsGM.SetRecord(ArtistGM);
        ArtistsGM.Run();
    end;

    local procedure ConstructFilterWithArtistId(var ArtistGenreGM: Record "Artist Genre GM") "Filter": Text
    begin
        repeat
            "Filter" += ArtistGenreGM."Artist Id" + '|';
        until ArtistGenreGM.Next() = 0;
        "Filter" := CopyStr("Filter", 1, StrLen("Filter") - 1);
    end;
}