program FrameTestProject;

uses
  Vcl.Forms,
  FrameTestMain in 'FrameTest\FrameTestMain.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
