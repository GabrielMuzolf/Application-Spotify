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
                    Style = Favorable;
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
                Image = Refresh;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Run this action to import predefined Spitify genres';
                trigger OnAction()
                var
                    ImportCategoriesGM: Codeunit "Import Genres GM";
                begin
                    ImportCategoriesGM.ImportGenres();
                end;
            }
            action("Show Artists")
            {
                ApplicationArea = All;
                Image = Segment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Run this action to see artist for specified genre';
                trigger OnAction()
                begin
                    OpenArtistsPageForGenre();
                end;
            }
        }
    }

    local procedure OpenArtistsPageForGenre()
    var
        ArtistGM: Record "Artist GM";
        FilterUtilityGM: Codeunit "Filter Utility GM";
        ArtistsGM: Page "Artists GM";
        ArtistsFilter: Text;
        NoArtistsMsg: Label 'There is no artist for this genre.';
    begin
        ArtistsFilter := FilterUtilityGM.GetFilterForGenreArtists(Rec);
        if ArtistsFilter = '' then begin
            Message(NoArtistsMsg);
            exit;
        end;
        ArtistGM.SetFilter(Id, ArtistsFilter);
        ArtistsGM.SetTableView(ArtistGM);
        ArtistsGM.Run();
    end;
}