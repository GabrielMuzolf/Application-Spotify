table 50502 "Category GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; Href; Text[1024])
        {

        }
        field(4; Picture; MediaSet)
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