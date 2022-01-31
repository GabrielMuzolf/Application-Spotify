page 50505 "Tracks GM"
{
    UsageCategory = Administration;
    SourceTable = "Track GM";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Tracks)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies tracks name';
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
}