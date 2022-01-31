table 50502 "Genre GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Name)
        {
            Clustered = true;
        }
    }

}