page 50503 "Artists GM"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Artist GM";
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
            repeater(Artists)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Style = Favorable;
                    ToolTip = 'Specifies artist name';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies artist picture';
                }
                field(Followers; Rec.Followers)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies number of artist followers';
                }
                field(Popularity; Rec.Popularity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies artist popularity';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Show Albums")
            {
                ApplicationArea = All;
                Image = ShowMatrix;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Run this action to see albums for specified artist.';

                trigger OnAction()
                begin
                    OpenAlbumsPageForArtist();
                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        ResourceTypeGM: Enum "Resource Type GM";
    begin
        //TODO now on after page open there is no player unt5il You change record....
        CurrPage.PlayerAddin.UpdatePlayer(Format(ResourceTypeGM::artist), Rec.Id);
    end;

    local procedure OpenAlbumsPageForArtist()
    var
        AlbumGM: Record "Album GM";
        FilterUtilityGM: Codeunit "Filter Utility GM";
        AlbumsGM: Page "Albums GM";
        AlbumsFilter: Text;
        NoAlbumsMsg: Label 'There is no albums for this artist.';
    begin
        AlbumsFilter := FilterUtilityGM.GetFilterForArtistAlbums(Rec);
        if AlbumsFilter = '' then begin
            Message(NoAlbumsMsg);
            exit;
        end;
        AlbumGM.SetFilter(Id, AlbumsFilter);
        AlbumsGM.SetTableView(AlbumGM);
        AlbumsGM.Run();
    end;
}