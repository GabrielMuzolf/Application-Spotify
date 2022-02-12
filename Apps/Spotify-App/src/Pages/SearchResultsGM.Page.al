page 50506 "Search Result GM"
{
    PageType = List;
    ApplicationArea = Basic, Suite;
    UsageCategory = Administration;
    SourceTable = "Search Result GM";
    Caption = 'Search Results';
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group("Search parametrs")
            {
                field(ResourceTypeGM; ResourceTypeGM)
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Specifies resource type';
                    Caption = 'Resource Type';
                }
                field(SearchQuery; SearchQuery)
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Specifies search query which will be used to search data on spotify';
                    Caption = 'Search Query';
                }
            }
            repeater("Search Results")
            {
                field("Resource Name"; Rec."Resource Name")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies resource name';
                    Caption = 'Resource Name';
                }
                field("Resource Type"; Rec."Resource Type")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies resource type';
                    Caption = 'Resource Type';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Search)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Run this action to search resources base on specifed conditions';
                trigger OnAction()
                begin
                    Message('Run');
                end;
            }
        }
    }

    var
        ResourceTypeGM: Enum "Resource Type GM";
        SearchQuery: Text[250];
}