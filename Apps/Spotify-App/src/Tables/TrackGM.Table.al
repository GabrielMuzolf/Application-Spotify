table 50507 "Track GM"
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
        field(3; "Album Id"; Text[100])
        {
            DataClassification = CustomerContent;
            TableRelation = "Album GM";
        }
        field(4; "Album Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Album GM".Name where(Id = field("Album Id")));
        }

        field(10; Picture; Media)
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