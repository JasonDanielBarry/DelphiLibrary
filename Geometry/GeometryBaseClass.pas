unit GeometryBaseClass;

interface

    uses
        system.SysUtils, system.Math,
        Vcl.ExtCtrls,
        GeometryTypes,
        DrawingTypes, DrawingAxisConversionClass;

    type
        TGeomBase = class
            protected
                drawingAxisConverter    : TDrawingAxisConverter;
                drawingPaintBox         : TPaintBox;
            public
                constructor create(); overload;
                constructor create(drawingPaintBoxIn : TPaintBox); overload;
                destructor destroy(); override;
                function boundingBox() : TGeomBox; virtual; abstract;
                procedure draw(); virtual; abstract;
        end;

implementation

    constructor TGeomBase.create();
        begin
            inherited create();

            FreeAndNil(drawingPaintBox);

            drawingAxisConverter.create();
        end;

    constructor TGeomBase.create(drawingPaintBoxIn : TPaintBox);
        begin
            create();

            drawingPaintBox := drawingPaintBoxIn;
        end;

    destructor TGeomBase.destroy();
        begin
            inherited Destroy();

            FreeAndNil(drawingAxisConverter);
        end;

end.
