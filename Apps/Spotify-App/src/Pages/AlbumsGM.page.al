page 50504 "Albums GM"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Album GM";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            usercontrol(PlayerAddin; PlayerAddin)
            {
                ApplicationArea = All;
            }
            repeater(Albums)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    ToolTip = 'Specifies album name';
                }
                field("Total Tracks"; Rec."Total Tracks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies numer of album tracks';
                }
                field(Popularity; Rec.Popularity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies album popularity';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies album picture';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Show Tracks")
            {
                ApplicationArea = All;
                Image = ShowMatrix;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Run this action to see tracks for specified album.';

                trigger OnAction()
                begin
                    OpenTracksPageForAlbum();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        ResourceTypeGM: Enum "Resource Type GM";
    begin
        CurrPage.PlayerAddin.UpdatePlayer(Format(ResourceTypeGM::album), Rec.Id);
    end;

    local procedure OpenTracksPageForAlbum()
    var
        TrackGM: Record "Track GM";
        FilterUtilityGM: Codeunit "Filter Utility GM";
        TracksGM: Page "Tracks GM";
        TracksFilter: Text;
        NoTracksMsg: Label 'There is no tracks for this album.';
    begin
        TracksFilter := FilterUtilityGM.GetFilterForAlbumTracks(Rec);
        if TracksFilter = '' then begin
            Message(NoTracksMsg);
            exit;
        end;
        TrackGM.SetFilter(Id, TracksFilter);
        TracksGM.SetTableView(TrackGM);
        TracksGM.Run();
    end;
}