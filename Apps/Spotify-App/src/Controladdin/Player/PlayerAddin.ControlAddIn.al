controladdin PlayerAddin
{
    RequestedHeight = 250;
    MaximumHeight = 250;
    VerticalStretch = true;
    VerticalShrink = true;
    HorizontalStretch = true;
    HorizontalShrink = true;
    StartupScript = 'src/Controladdin/Player/Startup.js';
    Scripts = 'src/Controladdin/Player/Scripts.js';

    procedure UpdatePlayer(PlayerType: Text; ResourceId: Text)
}