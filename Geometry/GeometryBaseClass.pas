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
                procedure setGeomType(); overload; virtual; abstract;
                procedure setGeomType(const geomTypeIn : EGeomType); overload;
            public
                constructor create();
                destructor destroy(); override;
                function getGeomType() : EGeomType;
                function boundingBox() : TGeomBox; virtual; abstract;
                function drawingPoints() : TArray<TGeomPoint>; virtual; abstract;
        end;

    function determineBoundingBox(arrGeom : TArray<TGeomBase>) : TGeomBox;

implementation

    procedure TGeomBase.setGeomType(const geomTypeIn : EGeomType);
        begin
            geomType := geomTypeIn;
        end;

    constructor TGeomBase.create();
        begin
            inherited create();

            setGeomType();
        end;

    destructor TGeomBase.destroy();
        begin
            inherited Destroy();
        end;

    function TGeomBase.getGeomType() : EGeomType;
        begin
            result := geomType;
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
