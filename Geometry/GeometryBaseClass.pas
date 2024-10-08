unit GeometryBaseClass;

interface

    uses
        system.SysUtils, system.Math,
        Vcl.ExtCtrls,
        GeometryTypes,
        DrawingAxisConversionClass;

    type
        TGeomBase = class
            private
                //
            protected
                //
            public
                constructor create();
                destructor destroy(); override;
                function getGeomType() : EGeomType; virtual; abstract;
                function boundingBox() : TGeomBox; virtual; abstract;
                function drawingPoints() : TArray<TGeomPoint>; virtual; abstract;
        end;

    function determineBoundingBox(arrGeom : TArray<TGeomBase>) : TGeomBox;

implementation

    constructor TGeomBase.create();
        begin
            inherited create();
        end;

    destructor TGeomBase.destroy();
        begin
            inherited Destroy();
        end;

    function determineBoundingBox(arrGeom : TArray<TGeomBase>) : TGeomBox;
        var
            i, geomCount    : integer;
            boxOut          : TGeomBox;
            arrGeomBox      : TArray<TGeomBox>;
        begin
            geomCount := length(arrGeom);

            SetLength(arrGeomBox, geomCount);

            for i := 0 to (geomCount - 1) do
                arrGeomBox[i] := arrGeom[i].boundingBox();

            boxOut := TGeomBox.create(arrGeomBox);
        end;

end.
