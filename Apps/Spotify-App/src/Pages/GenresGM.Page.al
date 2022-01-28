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
        }
    }
}