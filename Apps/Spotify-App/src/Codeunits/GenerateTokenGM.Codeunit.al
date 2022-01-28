/// <summary>
/// Codeunit used to generate token for the Spotify API.
/// </summary>
codeunit 50502 "Generate Token GM"
{
    var
        RequestFailedErr: Label 'API Request failed with code ''%1'' and respone phrase ''%2''.', Comment = '%1 = Status Code, %2 = Response Phrase';

    internal procedure GenerateToken(): Text
    var
        ResponseBody: JsonObject;
    begin
        ResponseBody.ReadFrom(SendRequestToGetToken());
        exit(GetAccessTokenFromResponse(ResponseBody));
    end;

    local procedure SendRequestToGetToken(): Text
    var
        HttpGM: Codeunit "Http GM";
    begin
        PrepareRequest(HttpGM);
        HttpGM.SendRequest();
        if HttpGM.IsResponseSuccess() then
            exit(HttpGM.GetResponseBody());
        Error(RequestFailedErr, HttpGM.GetResponseStatusCode(), HttpGM.GetResponseStatusPhrase());
    end;

    local procedure PrepareRequest(var HttpGM: Codeunit "Http GM")
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpMethodGM: Enum "Http Method GM";
        ContentHeaders: Dictionary of [Text, Text];
    begin
        Clear(HttpGM);
        ContentHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        HttpGM.SetHttpMethod(HttpMethodGM::POST);
        HttpGM.SetUri('https://accounts.spotify.com/api/token');
        HttpGM.SetRequestBody('grant_type=client_credentials', ContentHeaders);
        HttpGM.AddHeader('Authorization', 'Basic ' + Base64Convert.ToBase64('7a2dfb5d83ba4abaa8f356abf308ee1d:dc931551dc314762b35fcfdcd7f9939e'));
    end;

    local procedure GetAccessTokenFromResponse(ResponseBody: JsonObject): Text
    var
        AccessToken: JsonToken;
        TokenValue: JsonValue;
    begin
        ResponseBody.Get('access_token', AccessToken);
        TokenValue := AccessToken.AsValue();
        exit(TokenValue.AsText());
    end;
}