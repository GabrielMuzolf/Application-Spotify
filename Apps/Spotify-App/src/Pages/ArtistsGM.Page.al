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
            repeater(Artists)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
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
            action(AddArtists)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    ImportArtistGM: Codeunit "Import Artist GM";
                begin
                    //Message('open journal from which You can add artists with his discography');
                    ImportArtistGM.ImportArtist('2ye2Wgw4gimLv2eAKyk1NB', false);
                end;
            }
        }
    }
}