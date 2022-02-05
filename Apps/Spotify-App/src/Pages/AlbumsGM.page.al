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
    trigger OnAfterGetCurrRecord()
    var
        ResourceTypeGM: Enum "Resource Type GM";
    begin
        CurrPage.PlayerAddin.UpdatePlayer(Format(ResourceTypeGM::album), Rec.Id);
    end;
}