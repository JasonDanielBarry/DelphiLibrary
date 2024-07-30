unit LinearAlgeberaMethods;

interface

    uses
        System.SysUtils, system.Math, system.Math.Vectors, system.Types,
        GeneralMathMethods
        ;



    //line method
        //length
            function lineLength(x0, y0, z0,
                                x1, y1, z1 : double) : double;

        //intersection
            function lineIntersectionPoint( x0, y0, u0, v0,
                                            x1, y1, u1, v1 : double) : TPointF;

    //matrix determinant
        //2x2
            function determinant(   a, b,
                                    c, d    : double) : double; overload;

        //3x3
            function determinant(   a, b, c,
                                    d, e, f,
                                    g, h, i     : double) : double; overload;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;

implementation

    //line methods
        //length
            function lineLength(x0, y0, z0,
                                x1, y1, z1 : double) : double;
                var
                    dx, dy, dz,
                    lengthOut   : double;
                begin
                    dx := x1 - x0;
                    dy := y1 - y0;
                    dz := z1 - z0;

                    lengthOut := sqrt( Power(dx, 2) + power(dy, 2) + power(dz, 2) );

                    result := lengthOut;
                end;

        //intersection
            //helper methods
                //t0
                    function calculate_t0(  dx, dy,
                                            u0, v0,
                                            r1      : double) : double;
                        var
                            denom, numer : double;
                        begin
                            denom := r1 * dx - dy;

                            numer := r1 * u0 - v0;

                            result := denom / numer;
                        end;

                //t1
                    function calculate_t1(  dx, dy,
                                            u1, v1,
                                            r0      : double) : double;
                        var
                            denom, numer : double;
                        begin
                            denom := - (r0 * dx - dy);

                            numer := r0 * u1 - v1;

                            result := denom / numer;
                        end;

            function lineIntersectionPoint( x0, y0, u0, v0,
                                            x1, y1, u1, v1 : double) : TPointF;
                var
                    dx, dy,
                    r0, r1,
                    t0, t1              : double;
                    point0, point1,
                    pointOut            : TPointF;
                function
                    _testForParallelLines() : boolean;
                        var
                            parallelError : Exception;
                        begin
                            result := False;

                            try
                                if ( isAlmostEqual(abs(u0), abs(u1)) AND isAlmostEqual(abs(v0), abs(v1)) ) then
                                    begin
                                        parallelError := Exception.Create('Lines are parallel: no intersection point');

                                        raise parallelError;
                                    end;
                            except
                                result := True;

                                FreeAndNil(parallelError);

                                pointOut := TPointF.Create(0, 0);
                            end;
                        end;
                function
                    _testForNoIntersection() : boolean;
                        var
                            intersectionError : Exception;
                        begin
                            result := False;

                            try
                                if(NOT( (point0.X = point1.X) AND (point0.Y = point1.Y) )) then
                                    begin
                                        intersectionError := Exception.Create('Intersection Point Not Found');

                                        raise intersectionError;
                                    end;
                            except
                                result := True;

                                FreeAndNil(intersectionError);

                                pointOut := TPointF.Create(0, 0);
                            end;
                        end;
                begin
                    //formulae
                        //line 0
                            //|x|   |x0|     |u0|
                            //| | = |  | + t0|  |
                            //|y|   |y0|     |v0|

                        //line 1
                            //|x|   |x1|     |u1|
                            //| | = |  | + t0|  |
                            //|y|   |y1|     |v1|

                        //intersection equation
                            //|x1-x0|   |u0 -u1||t0|
                            //|     | = |      ||  |
                            //|y1-y0|   |v0 -v1||t1|

                    //test for parallel lines
                        if (_testForParallelLines()) then
                            begin
                                result := TPointF.create(0, 0);

                                exit;
                            end;

                    //ratios
                        r0 := v0 / u0;
                        r1 := v1 / u1;

                    //dx, dy
                        dx := x1 - x0;
                        dy := y1 - y0;

                    //calculation t0 & t1

                        t0 := calculate_t0(dx, dy, u0, v0, r1);

                        t1 := calculate_t1(dx, dy, u1, v1, r0);

                    //calculate the intersection points from t0 & t1
                        point0 := TPointF.Create(x0 + t0 * u0, y0 + t0 * v0);
                        point1 := TPointF.Create(x1 + t1 * u1, y1 + t1 * v1);

                    if (_testForNoIntersection()) then
                        pointOut := point0;

                    result := pointOut;
                end;

    //matrix determinant
        //2x2
            function determinant(   a, b,
                                    c, d    : double) : double;
                begin
                    //det = |a b|
                    //      |c d|
                    //    = ad - bc

                    result := (a * d) - (b * c);
                end;

        //3x3
            function determinant(   a, b, c,
                                    d, e, f,
                                    g, h, i     : double) : double;
                begin
                    //      |a b c|
                    //det = |d e f|
                    //      |g h i|

                    //    = a|e f| - b|d f| + c|d e|
                    //       |h i|    |g i|    |g h|

                    result :=       a * determinant(e, f,
                                                    h, i)

                                -   b * determinant(d, f,
                                                    g, i)

                                +   c * determinant(d, e,
                                                    g, h);
                end;

        //any square matrix
            //helper methods
                function matrixIsSquare(const matrixIn : TArray< TArray<double> >) : boolean;
                    var
                        colN, rowN : integer;
                    begin
                        colN := length(matrixIn[0]);
                        rowN := length(matrixIn);

                        result := colN = rowN;
                    end;

                function subMatrix( const colIn     : integer;
                                    const matrixIn  : TArray< TArray<double> >) : Tarray< TArray<double> >;
                        var
                            dimension, subDimension,
                            i, j,
                            r, c                    : integer;
                            subMatrixOut            : Tarray< TArray<double> >;
                        begin
                            //get the sub-matrix dimension
                                dimension   := length(matrixIn);
                                subDimension := dimension - 1;

                            //size the sub-matrix
                                SetLength(subMatrixOut, subDimension);

                                for c := 0 to (subDimension - 1) do
                                    SetLength(subMatrixOut[c], subDimension);

                            //assign the values to the sub-matrix
                                r := 0;
                                c := 0;

                                for i := 1 to (dimension - 1) do //the second row and downward is assigned to the sub-matrix
                                    for j := 0 to (dimension - 1) do
                                        begin
                                            if (j <> colIn) then
                                                begin
                                                    subMatrixOut[r][c] := matrixIn[i][j];

                                                    inc(r);
                                                    inc(c);
                                                end;
                                        end;

                            result := subMatrixOut;
                        end;

            function determinant(const matrixIn : TArray< TArray<double> >) : double; overload;
                var
                    i,
                    dimension           : integer;
                    a_ij,
                    determinantValueOut : double;
                    C_ij                : TArray< TArray<double> >;
                begin
                    //check if the input matrix is square (N x N)
                        if ( NOT(matrixIsSquare(matrixIn)) ) then
                            begin
                                result := 0;
                                exit();
                            end;

                    //if N = 1 then the determinant is the matrix value
                        dimension := length(matrixIn);

                        if (dimension = 1) then
                            begin
                                result := matrixIn[0][0];
                                exit();
                            end;

                    //determinant = sum(a_ij * C_ij)
                        determinantValueOut := 0;

                        for i := 0 to (dimension - 1) do
                            begin
                                a_ij := matrixIn[0][i];

                                C_ij := subMatrix(
                                                    i,
                                                    matrixIn
                                                 );

                                determinantValueOut := determinantValueOut + a_ij * determinant(C_ij);
                            end;

                    result := determinantValueOut;
                end;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;
            var
                areaOut : double;
            begin
                //              |x1 y1 1|
                //A = (1/2) det(|x2 y2 1|)
                //              |x3 y3 1|

                result := 0.5 * determinant(x1, y1, 1,
                                            x2, y2, 1,
                                            x3, y3, 1);
            end;

end.
