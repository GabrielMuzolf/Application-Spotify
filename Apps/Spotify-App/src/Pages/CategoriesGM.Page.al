page 50502 "Categories GM"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Category GM";

    layout
    {
        area(Content)
        {
            repeater(Categories)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies category id';
                    Caption = 'Id';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies category name';
                    Caption = 'Name';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies category picture';
                    Caption = 'Picture';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Categories")
            {
                ApplicationArea = All;
                ToolTip = 'Run this action to import predefined Spitify categories';
                trigger OnAction()
                begin
                    Message('Import Categories');
                end;
            }
        }
    }


}