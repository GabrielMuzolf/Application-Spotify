table 50503 "Artist GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; Picture; Media)
        {
            DataClassification = CustomerContent;
        }
        field(10; Followers; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; Popularity; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }
}