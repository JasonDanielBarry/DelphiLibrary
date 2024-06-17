unit GeometryMathMethods;

interface

    uses
        System.SysUtils, system.Math,
        GeneralMathMethods, LinearAlgeberaMethods,
        GeometryTypes
        ;

implementation

    function triangleArea(point1In, point2In, point3In : TGeomPoint) : double;
        var
            x1, y1,
            x2, y2,
            x3, y3 : double;
        begin
            //extract values from points
                x1 := point1In.x;
                y1 := point1In.y;

                x2 := point2In.x;
                y2 := point2In.y;

                x3 := point3In.x;
                y3 := point3In.y;

            result := LinearAlgeberaMethods.triangleArea(   x1, y1,
                                                            x2, y2,
                                                            x3, y3  );
        end;

end.
