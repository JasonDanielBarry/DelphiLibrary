unit GeometryMathMethods;

interface

    uses
        System.SysUtils, system.Math,
        GeneralMathMethods, LinearAlgeberaMethods,
        GeometryTypes
        ;

    //calculate distance between 2 lines
        function geomLineLength(point1In, point2In : TGeomPoint) : double;

    //calculate triangle area
        //given two vertices
            function geomTriangleArea(point1In, point2In : TGeomPoint) : double; overload;

        //given three vertices
            function geomTriangleArea(point1In, point2In, point3In : TGeomPoint) : double; overload;

    //calculate the area of a polygon
        //shoelace formula calculation
            function geomPolygonArea(arrGeomPointsIn : TArray<TGeomPoint>) : double;

implementation

    //calculate distance between 2 lines
        function geomLineLength(point1In, point2In : TGeomPoint) : double;
            var
                x1, y1, z1,
                x2, y2, z2 : double;
            begin
                x1 := point1In.x;
                y1 := point1In.y;
                z1 := point1In.z;

                x2 := point2In.x;
                y2 := point2In.y;
                z2 := point2In.z;

                result := lineLength(   x1, y1, z1,
                                        x2, y2, z2  );
            end;

    //calculate triangle area
        //given two vertices
            function geomTriangleArea(point1In, point2In : TGeomPoint) : double;
                var
                    point3 : TGeomPoint;
                begin
                    point3 := TGeomPoint.create(0, 0, 0);

                    result := geomTriangleArea(point1In, point2In, point3);
                end;

        //given three vertices
            function geomTriangleArea(point1In, point2In, point3In : TGeomPoint) : double;
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

                    result := triangleArea( x1, y1,
                                            x2, y2,
                                            x3, y3  );
                end;

    //calculate the area of a polygon
        //shoelace formula calculation
            function geomPolygonArea(arrGeomPointsIn : TArray<TGeomPoint>) : double;
                var
                    i, arrLen   : integer;
                    areaSum     : double;
                begin
                    areaSum := 0;

                    arrLen := Length(arrGeomPointsIn);

                    //shoelace calculation
                        for i := 0 to (arrLen - 2) do
                            areaSum := areaSum + geomTriangleArea(arrGeomPointsIn[i], arrGeomPointsIn[i + 1]);

                        areaSum := areaSum + geomTriangleArea(arrGeomPointsIn[arrLen - 1], arrGeomPointsIn[0]);

                    result := areaSum;
                end;

end.
