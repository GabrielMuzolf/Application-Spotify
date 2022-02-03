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
        FilterUtilityGM: Codeunit "Filter Utility GM";
        ArtistsGM: Page "Artists GM";
    begin
        ArtistGM.SetFilter(Id, FilterUtilityGM.GetFilterForGenreArtists(Rec));
        if ArtistGM.IsEmpty then begin
            Message('There is no artist for this genre'); //TODO add label
            exit;
        end;
        ArtistsGM.SetRecord(ArtistGM);
        ArtistsGM.Run();
    end;
}