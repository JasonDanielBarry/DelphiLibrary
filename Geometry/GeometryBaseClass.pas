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
                geomType : EGeomType;
            protected
                procedure setGeomType(); virtual; abstract;
            public
                constructor create();
                destructor destroy(); override;
                function boundingBox() : TGeomBox; virtual; abstract;
                function drawingPoints() : TArray<TGeomPoint>; virtual; abstract;
        end;

    function determineBoundingBox(arrGeom : TArray<TGeomBase>) : TGeomBox;

implementation

    constructor TGeomBase.create();
        begin
            inherited create();

            setGeomType();
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
