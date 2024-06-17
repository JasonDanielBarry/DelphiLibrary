unit GeometryMathMethods;

interface

    uses
        System.SysUtils, system.Math,
        GeneralMathMethods,
        GeometryTypes
        ;

implementation

    function triangleArea(point1In, point2In, point3In : TGeomPoint) : double;
        var
            x1, y1, x2, y2, x3, y3 : double;
        begin
            x1 := point1In.x;
            x2 := point2In.x;
            x3 := point3In.x;

            result := triangleArea()
        end;

end.
