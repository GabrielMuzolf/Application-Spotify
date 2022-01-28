table 50502 "Genre GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Name; Text[50])
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