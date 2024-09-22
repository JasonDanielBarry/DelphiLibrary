unit GeometryBaseClass;

interface

    uses
        system.SysUtils, system.Math,
        Vcl.ExtCtrls,
        GeometryTypes,
        DrawingAxisConversionClass;

    type
        TGeomBase = class
            public
                constructor create();
                destructor destroy(); override;
                function boundingBox() : TGeomBox; virtual; abstract;
                function drawingPoints() : TArray<TGeomPoint>; virtual; abstract;
        end;

implementation

    constructor TGeomBase.create();
        begin
            inherited create();
        end;

    destructor TGeomBase.destroy();
        begin
            inherited Destroy();
        end;

end.
