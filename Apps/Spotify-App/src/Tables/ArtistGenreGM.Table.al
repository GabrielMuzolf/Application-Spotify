table 50504 "Artist Genre GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Artist; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "Artist GM";
        }
        field(2; Genre; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = "Genre GM";
        }
    }

    keys
    {
        key(Key1; Artist, Genre)
        {
            Clustered = true;
        }
    }
}