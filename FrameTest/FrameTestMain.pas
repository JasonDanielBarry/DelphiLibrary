unit FrameTestMain;

interface

    uses
        Winapi.Windows, Winapi.Messages,
        System.SysUtils, System.Variants, System.Classes, system.UITypes, system.Math,
        Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Graphic2DComponent, CustomComponentPanelClass,
        SkiaDrawingClass,
        GeometryTypes,
        GeomLineClass, GeomPolyLineClass;

    type
        TForm1 = class(TForm)
        Graphic2D1: TGraphic2D;
        procedure Graphic2D1UpdateGeometry( ASender         : TObject;
                                            var ASkiaDrawer : TSkiaGeomDrawer   );
    procedure FormCreate(Sender: TObject);
      private
        { Private declarations }
      public
        { Public declarations }
      end;

    var
        Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
Graphic2D1.updateGeometry();
Graphic2D1.redrawGraphic();
end;

procedure TForm1.Graphic2D1UpdateGeometry(  ASender: TObject;
                                            var ASkiaDrawer: TSkiaGeomDrawer    );
    var
            i                       : integer;
            startPoint, endPoint    : TGeomPoint;
            line                    : TGeomLine;
            polyLine                : TGeomPolyLine;
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

                ASkiaDrawer.addLine(line, 5);

            //3
                polyLine := TGeomPolyLine.create();

                for i := 0 to 500 do
                    begin
                        var x, y : double;

                        x := 1 * i;
                        y := 10 * sin(x / 10) + 0.5 * x;

                        polyLine.addVertex(x, y);
                    end;

                ASkiaDrawer.addPolyline(polyLine, 3, TAlphaColors.Blueviolet);
        end;

end.
