/// <summary>
/// Utility Library for JSON
/// </summary>
codeunit 50504 "JSON Utility GM"
{
    procedure GetValueAsText(JsonObject: JsonObject; "Key": Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get("Key", JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsText());
    end;

    procedure GetValueAsTextFromPath(JsonObject: JsonObject; Path: Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.SelectToken(Path, JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsText());
    end;

    procedure GetValueAsInteger(JsonObject: JsonObject; "Key": Text): Integer
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.Get("Key", JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsInteger());
    end;

    procedure GetValueAsIntegerFromPath(JsonObject: JsonObject; Path: Text): Integer
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        JsonObject.SelectToken(Path, JsonToken);
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsInteger());
    end;

    procedure GetJSONArray(JsonObject: JsonObject; "Key": Text): JsonArray
    var
        JsonToken: JsonToken;
    begin
        JsonObject.Get("Key", JsonToken);
        exit(JsonToken.AsArray());
    end;

    procedure GetJSONArrayFromPath(JsonObject: JsonObject; Path: Text): JsonArray
    var
        JsonToken: JsonToken;
    begin
        JsonObject.SelectToken(Path, JsonToken);
        exit(JsonToken.AsArray());
    end;
}