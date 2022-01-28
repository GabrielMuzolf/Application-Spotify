/// <summary>
/// Utility Library for JSON
/// </summary>
codeunit 50504 "JSON Utility GM"
{
    procedure GetValueAsTextForKey(JsonObject: JsonObject; "Key": Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get("Key", JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsText());
    end;

    procedure GetJSONArrayForKey(JsonObject: JsonObject; "Key": Text): JsonArray
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get("Key", JsonToken);
        exit(JsonToken.AsArray());
    end;
}