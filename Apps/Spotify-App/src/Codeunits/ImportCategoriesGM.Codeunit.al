/// <summary>
/// Codeunit used to import predefined Spotify categories into the table.
/// </summary>
codeunit 50503 "Import Categories GM"
{
    var
        JSONUtilityGM: Codeunit "JSON Utility GM";
        MediaUtilityGM: Codeunit "Media Utility GM";
        RequestFailedErr: Label 'API Request failed with code ''%1'' and respone phrase ''%2''.', Comment = '%1 = Status Code, %2 = Response Phrase';

    internal procedure ImportCategories()
    var
        ResponseBody: JsonObject;
    begin
        TruncateCategoryTable();
        ResponseBody.ReadFrom(SendRequestToGetCategories());
        ImportCategoriesIntoCategoryTable(ResponseBody);
    end;

    local procedure TruncateCategoryTable()
    var
        CategoryGM: Record "Category GM";
    begin
        CategoryGM.DeleteAll();
    end;

    local procedure SendRequestToGetCategories(): Text
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
        GenerateTokenGM: Codeunit "Generate Token GM";
        HttpMethodGM: Enum "Http Method GM";
        Token: Text;
    begin
        Clear(HttpGM);
        Token := GenerateTokenGM.GenerateToken();
        HttpGM.SetHttpMethod(HttpMethodGM::GET);
        //API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-categories
        HttpGM.SetUri('https://api.spotify.com/v1/browse/categories?offset=0&limit=50');
        HttpGM.AddHeader('Authorization', 'Bearer ' + Token);
    end;

    local procedure ImportCategoriesIntoCategoryTable(ResponseBody: JsonObject)
    var
        ItemsArray: JsonArray;
        Category: JsonToken;
        i: Integer;
    begin
        ItemsArray := JSONUtilityGM.GetJSONArrayFromPath(ResponseBody, '$.categories.items');
        if ItemsArray.Count() = 0 then exit;
        for i := 0 to ItemsArray.Count() - 1 do
            if ItemsArray.Get(i, Category) then
                ImportCategory(Category.AsObject());
    end;

    local procedure ImportCategory(Category: JsonObject)
    var
        CategoryGM: Record "Category GM";
    begin
        CategoryGM.Init();
        CategoryGM.Id := CopyStr(JSONUtilityGM.GetValueAsText(Category, 'id'), 1, 50);
        CategoryGM.Name := CopyStr(JSONUtilityGM.GetValueAsText(Category, 'name'), 1, 50);
        CategoryGM.Href := CopyStr(JSONUtilityGM.GetValueAsText(Category, 'href'), 1, 1024);
        SetCategoryPicture(CategoryGm, Category);
        if CategoryGM.Insert() then;
    end;

    local procedure SetCategoryPicture(var CategoryGm: Record "Category GM"; Category: JsonObject)
    var
        Icons: JsonArray;
        Picture: JsonToken;
    begin
        Icons := JSONUtilityGM.GetJSONArray(Category, 'icons');
        if Icons.Count() = 0 then exit;
        Icons.Get(0, Picture);
        CategoryGM.Picture.ImportStream(MediaUtilityGM.GetPictureFromUrl(JSONUtilityGM.GetValueAsText(Picture.AsObject(), 'url')), '');
    end;
}

