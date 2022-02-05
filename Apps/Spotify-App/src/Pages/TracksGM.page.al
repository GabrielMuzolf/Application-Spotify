page 50505 "Tracks GM"
{
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "Track GM";
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
            repeater(Tracks)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies tracks name';
                    Style = Favorable;
                }
                field("Album Name"; Rec."Album Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies track album name';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies track picture';
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        ResourceTypeGM: Enum "Resource Type GM";
    begin
        CurrPage.PlayerAddin.UpdatePlayer(Format(ResourceTypeGM::track), Rec.Id);
    end;
}