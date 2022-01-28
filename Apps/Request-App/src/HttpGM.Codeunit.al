///<summary>Codeunit represents Http Request</summary>
codeunit 50500 "Http GM"
{

    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        HttpResponseMessage: HttpResponseMessage;
        RequestFailedErr: Label 'API Request failed with code ''%1'' and respone phrase ''%2''.', Comment = '%1 = Status Code, %2 = Response Phrase';

    procedure SetHttpMethod(HttpMethod: Enum "Http Method GM")
    begin
        HttpRequestMessage.Method(Format(HttpMethod));
    end;

    procedure SetUri(RequestUri: Text)
    begin
        HttpRequestMessage.SetRequestUri(RequestUri);
    end;

    procedure SetRequestBody(RequestBody: Text; ContentHeaders: Dictionary of [Text, Text])
    begin
        SetRequestBody(RequestBody);
        AddContentHeaders(ContentHeaders);
    end;

    local procedure AddContentHeaders(ContentHeaders: Dictionary of [Text, Text])
    var
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        Headers: List of [Text];
        Header: Text;
    begin
        HttpContent := HttpRequestMessage.Content();
        HttpContent.GetHeaders(HttpHeaders);
        Headers := ContentHeaders.Keys();
        foreach Header in Headers do
            AddHeader(HttpHeaders, Header, ContentHeaders.Get(Header));
        HttpRequestMessage.Content(HttpContent);
    end;

    procedure SetRequestBody(RequestBody: Text)
    var
        HttpContent: HttpContent;
    begin
        HttpContent.WriteFrom(RequestBody);
        HttpRequestMessage.Content(HttpContent);
    end;

    procedure AddHeader(HeaderName: Text; HeaderValue: Text)
    var
        HttpHeaders: HttpHeaders;
    begin
        HttpRequestMessage.GetHeaders(HttpHeaders);
        AddHeader(HttpHeaders, HeaderName, HeaderValue);
    end;

    local procedure AddHeader(var HttpHeaders: HttpHeaders; HeaderName: Text; HeaderValue: Text)
    begin
        if HttpHeaders.Contains(HeaderName) then
            HttpHeaders.Remove(HeaderName);
        HttpHeaders.Add(HeaderName, HeaderValue);
    end;

    procedure SendRequest()
    begin
        if HttpClient.Send(HttpRequestMessage, HttpResponseMessage) then;
    end;

    procedure IsResponseSuccess(): Boolean
    begin
        exit(HttpResponseMessage.IsSuccessStatusCode());
    end;

    procedure GetResponseStatusCode(): Integer
    begin
        exit(HttpResponseMessage.HttpStatusCode());
    end;

    procedure GetResponseStatusPhrase(): Text
    begin
        exit(HttpResponseMessage.ReasonPhrase());
    end;

    procedure GetResponseBody() ResponseBody: Text
    var
        HttpContent: HttpContent;
    begin
        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(ResponseBody);
    end;

    procedure SendRequestAndGetBody(): Text
    begin
        SendRequest();
        if not IsResponseSuccess() then
            Error(RequestFailedErr, GetResponseStatusCode(), GetResponseStatusPhrase());
        exit(GetResponseBody());
    end;
}