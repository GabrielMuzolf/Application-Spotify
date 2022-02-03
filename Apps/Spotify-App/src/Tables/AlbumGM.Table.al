table 50505 "Album GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Total Tracks"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(5; Popularity; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(10; Picture; Media)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Id")
        {
            Clustered = true;
        }
    }
}