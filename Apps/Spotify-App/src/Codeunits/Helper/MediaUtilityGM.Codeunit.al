/// <summary>
/// Media utility Library
/// </summary>
codeunit 50505 "Media Utility GM"
{
    procedure GetPictureFromUrl(PictureUrl: Text) InStream: InStream
    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
    begin
        HttpClient.Get(PictureUrl, HttpResponseMessage);
        HttpResponseMessage.Content().ReadAs(InStream);
    end;
}