table 50506 "Album Artist GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Album ID"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "Album GM";
        }
        field(2; "Artist ID"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "Artist GM";
        }
    }

    keys
    {
        key(Key1; "Album ID", "Artist ID")
        {
            Clustered = true;
        }
    }
}