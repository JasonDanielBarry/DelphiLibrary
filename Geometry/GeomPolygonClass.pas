unit GeomPolygonClass;

interface

    uses
        System.SysUtils, system.Math,
        GeometryTypes,
        GeometryMathMethods,
        GeomPolyLineClass;

    type
        TGeomPolygon = class(TGeomPolyLine)
            protected
                procedure setGeomType(); override;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //drawing points
                    function drawingPoints() : TArray<TGeomPoint>; override;
        end;

implementation

end.
