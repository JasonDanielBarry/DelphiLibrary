unit LinearAlgeberaMethods;

interface

    uses
        System.SysUtils, system.Types
        ;

    //line method
        //length
            function lineLength(x0, y0, z0,
                                x1, y1, z1 : double) : double;

        //intersection
            function lineIntersectionPoint( out LinesIntersectOut : boolean;
                                            const   x0, y0, u0, v0,
                                                    x1, y1, u1, v1 : double ) : TPointF;

    //matrix determinant
        function determinant(const matrixIn : TArray< TArray<double> >) : double; //overload;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;

implementation

    uses
        system.Math,
        GeneralMathMethods
        ;

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
                //U-matrix
                    function UMatrix(   u0, v0,
                                        u1, v1  : double) : TArray< TArray<double> >;
                        begin
                            result :=   [
                                            [u0, -u1],
                                            [v0, -v1]
                                        ];
                        end;

                //T - intersection parameter
                    function calculateT(x0, y0, u0, v0,
                                        x1, y1, u1, v1  : double) : TArray<double>;
                        var
                            dx, dy,
                            detU    : double;
                            TOut    : TArray<double>;
                            U       : TArray< TArray<double>>;
                        begin
                            SetLength(TOut, 2);

                            //calculate the U_matrix determinant
                                U := UMatrix(   u0, v0,
                                                u1, v1  );

                                detU := determinant(U);

                                //a determinant of zero means the lines do not intersect
                                    if (abs(detU) < 1e-3) then
                                        begin
                                            result := [0, 0];
                                            exit();
                                        end;

                            //dx, dy
                                dx := x1 - x0;
                                dy := y1 - y0;

                            //calculate the intersection T

                            TOut[0] := (dx * v1 - dy * u1) / (-detU);
                            TOut[1] := (dx * v0 - dy * u0) / (-detU);
                        end;

            function lineIntersectionPoint( out LinesIntersectOut : boolean;
                                            const   x0, y0, u0, v0,
                                                    x1, y1, u1, v1 : double) : TPointF;
                var
                    T               : TArray<double>;
                    point0, point1,
                    pointOut        : TPointF;
                function
                    _UMatrixDeterminantAlmostZero() : boolean;
                        var
                            detU    : double;
                            U       : TArray< TArray<double>>;
                        begin
                            U := UMatrix(   u0, v0,
                                            u1, v1  );

                            detU := determinant(U);

                            result := (abs(detU) < 1e-3);
                        end;
                function
                    _IntersectionPointsAreEqual() : boolean;
                        begin
                            result := ( (point0.X = point1.X) AND (point0.Y = point1.Y) );
                        end;
                begin
                    //formulae
                        //line 0
                            //|x|   |x0|     |u0|
                            //| | = |  | + t0|  |
                            //|y|   |y0|     |v0|

                        //line 1
                            //|x|   |x1|     |u1|
                            //| | = |  | + t1|  |
                            //|y|   |y1|     |v1|

                        //intersection equation
                            //|x1-x0|   |u0 -u1||t0|
                            //|     | = |      ||  |
                            //|y1-y0|   |v0 -v1||t1|

                    //test for parallel lines
                        if (_UMatrixDeterminantAlmostZero()) then
                            begin
                                LinesIntersectOut := False;
                                exit;
                            end
                        else
                            LinesIntersectOut := True;

                    //calculation t0 & t1
                        T := calculateT(x0, y0, u0, v0,
                                        x1, y1, u1, v1);

                    //calculate the intersection points from t0 & t1
                        point0 := TPointF.Create(x0 + T[0] * u0, y0 + T[0] * v0);
                        point1 := TPointF.Create(x1 + T[1] * u1, y1 + T[1] * v1);

                    //the result is only valid if two identical points are calculated from T
                        if (_IntersectionPointsAreEqual()) then
                            pointOut := point0
                        else
                            LinesIntersectOut := False;

                    result := pointOut;
                end;

    //matrix determinant
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
                            begin
                                r := i - 1;
                                c := 0;

                                for j := 0 to (dimension - 1) do
                                    begin
                                        if (j <> colIn) then
                                            begin
                                                subMatrixOut[r][c] := matrixIn[i][j];

                                                inc(c);
                                            end;
                                    end;
                            end;

                    result := subMatrixOut;
                end;

        function determinantRec(const matrixIn : TArray< TArray<double> >) : double;
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
                            a_ij := matrixIn[0][i] * power(-1, i);

                            C_ij := subMatrix(
                                                i,
                                                matrixIn
                                             );

                            determinantValueOut := determinantValueOut + a_ij * determinantRec(C_ij);
                        end;

                result := determinantValueOut;
            end;

        function determinant(const matrixIn : TArray< TArray<double> >) : double;
            begin
                result := determinantRec(matrixIn);
            end;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;
            var
                coordinateMatrix : TArray<TArray<double>>;
            begin
                coordinateMatrix := [
                                        [x1, y1, 1],
                                        [x2, y2, 1],
                                        [x3, y3, 1]
                                    ];

                result := 0.5 * determinant(coordinateMatrix);
            end;

end.
