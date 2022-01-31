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
        if not JsonObject.Get("Key", JsonToken) then exit;
        JsonValue := JsonToken.AsValue();
        if JsonValue.IsNull() then exit;
        exit(JsonValue.AsText());
    end;

    procedure GetValueAsTextFromPath(JsonObject: JsonObject; Path: Text): Text
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then exit;
        JsonValue := JsonToken.AsValue();
        if JsonValue.IsNull() then exit;
        exit(JsonValue.AsText());
    end;

    procedure GetValueAsInteger(JsonObject: JsonObject; "Key": Text): Integer
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        if not JsonObject.Get("Key", JsonToken) then exit;
        JsonValue := JsonToken.AsValue();
        if JsonValue.IsNull then exit;
        exit(JsonValue.AsInteger());
    end;

    procedure GetValueAsIntegerFromPath(JsonObject: JsonObject; Path: Text): Integer
    var
        JsonToken: JsonToken;
        JsonValue: JsonValue;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then exit;
        JsonValue := JsonToken.AsValue();
        exit(JsonValue.AsInteger());
    end;

    procedure GetJSONArray(JsonObject: JsonObject; "Key": Text): JsonArray
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get("Key", JsonToken) then exit;
        exit(JsonToken.AsArray());
    end;

    procedure GetJSONArrayFromPath(JsonObject: JsonObject; Path: Text): JsonArray
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then exit;
        exit(JsonToken.AsArray());
    end;
}