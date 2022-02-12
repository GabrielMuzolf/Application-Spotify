table 50508 "Search Result GM"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Resource Id"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Resource Name"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Resource Type"; Enum "Resource Type GM")
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Resource Id", "Resource Type")
        {
            Clustered = true;
        }
    }
}