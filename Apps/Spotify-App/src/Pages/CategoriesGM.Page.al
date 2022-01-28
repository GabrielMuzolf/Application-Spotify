page 50502 "Categories GM"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Category GM";
    ModifyAllowed = false;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Categories)
            {
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
                var
                    ImportCategoriesGM: Codeunit "Import Categories GM";
                begin
                    ImportCategoriesGM.ImportCategories();
                end;
            }
        }
    }
}