unit GeometryMathMethods;

interface

    uses
        System.SysUtils, system.Math,
        GeneralMathMethods, LinearAlgeberaMethods,
        GeometryTypes
        ;

    //calculate triangle area
        //given two vertices
            function triangleArea(point1In, point2In : TGeomPoint) : double; overload;

        //given three vertices
            function triangleArea(point1In, point2In, point3In : TGeomPoint) : double; overload;

    //calculate the area of a polygon
        //shoelace formula calculation
            function polygonArea(arrGeomPointsIn : TArray<TGeomPoint>) : double;

implementation

    //calculate triangle area
        //given two vertices
            function triangleArea(point1In, point2In : TGeomPoint) : double;
                var
                    point3 : TGeomPoint;
                begin
                    point3 := TGeomPoint.create(0, 0, 0);

                    result := triangleArea(point1In, point2In, point3);
                end;

        //given three vertices
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

    //calculate the area of a polygon
        //shoelace formula calculation
            function polygonArea(arrGeomPointsIn : TArray<TGeomPoint>) : double;
                var
                    i, arrLen   : integer;
                    areaSum     : double;
                begin
                    areaSum := 0;

                    arrLen := Length(arrGeomPointsIn);

                    //shoelace calculation
                        for i := 0 to (arrLen - 2) do
                            areaSum := areaSum + triangleArea(arrGeomPointsIn[i], arrGeomPointsIn[i + 1]);

                        areaSum := areaSum + triangleArea(arrGeomPointsIn[arrLen - 1], arrGeomPointsIn[0]);

                    result := areaSum;
                end;

end.
