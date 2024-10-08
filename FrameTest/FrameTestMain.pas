unit FrameTestMain;

interface

    uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, system.UITypes,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Graphic2DComponent,
        Graphic2DFrame, CustomComponentPanelClass,
        SkiaDrawingClass,
        GeometryTypes,
        GeomLineClass;

    type
        TForm1 = class(TForm)
        Graphic2D1: TGraphic2D;
        procedure Graphic2D1UpdateGeometry( ASender         : TObject;
                                            var ASkiaDrawer : TSkiaGeomDrawer);
      private
        { Private declarations }
      public
        { Public declarations }
      end;

    var
        Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Graphic2D1UpdateGeometry(  ASender: TObject;
                                            var ASkiaDrawer: TSkiaGeomDrawer);
    var
            startPoint, endPoint    : TGeomPoint;
            line                    : TGeomLine;
        begin
            //1
                startPoint  := TGeomPoint.create(10, 100);
                endPoint    := TGeomPoint.create(100, 10);

                line := TGeomLine.create(startPoint, endPoint);

                ASkiaDrawer.addLine(line, 5, TAlphaColors.Black);

            //2
                startPoint  := TGeomPoint.create(250, 150);
                endPoint    := TGeomPoint.create(500, 60);

                line := TGeomLine.create(startPoint, endPoint);

                ASkiaDrawer.addLine(line, 5, TAlphaColors.Black);
        end;

end.
