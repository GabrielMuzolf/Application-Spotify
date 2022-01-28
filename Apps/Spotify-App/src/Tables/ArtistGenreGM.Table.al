table 50504 "Artist Genre GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Artist Id"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "Artist GM";
        }
        field(2; "Genre Name"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Genre GM";
        }
    }

    keys
    {
        key(Key1; "Artist Id", "Genre Name")
        {
            Clustered = true;
        }
    }
}