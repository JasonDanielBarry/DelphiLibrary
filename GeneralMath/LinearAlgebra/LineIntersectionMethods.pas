unit LineIntersectionMethods;

interface

    uses
        System.SysUtils, system.Types
        ;

        //intersection
            function lineIntersectionPoint( out LinesIntersectOut           : boolean;
                                            const   l1x0, l1y0, l1x1, l1y1,
                                                    l2x0, l2y0, l2x1, l2y1  : double) : TPointF; overload;

implementation

    uses
        system.Math,
        GeneralMathMethods,
        LinearAlgebraTypes,
        MatrixMethods
        ;

    //formulae for line intersection:
        //line 0
            //|x|   |x0|     |u0|
            //| | = |  | + t0|  |
            //|y|   |y0|     |v0|

        //line 1
            //|x|   |x1|     |u1|
            //| | = |  | + t1|  |
            //|y|   |y1|     |v1|

        //intersection equation
            //|x1-x0|   |u0  -u1||t0|
            //|     | = |       ||  |
            //|y1-y0|   |v0  -v1||t1|

            //<dX>=[U]<T>

    //line methods
        //length

        //intersection
            //helper methods
                //U-matrix
                    function UMatrix(const  u0, v0,
                                            u1, v1  : double) : TLAMatrix;
                        begin
                            result :=   [
                                            [u0, -u1],
                                            [v0, -v1]
                                        ];
                        end;

                //T - intersection parameter
                    function calculateT(const   x0, y0, u0, v0,
                                                x1, y1, u1, v1  : double) : TArray<double>;
                        var
                            dx, dy,
                            detU    : double;
                            TOut    : TArray<double>;
                            U       : TLAMatrix;
                        begin
                            SetLength(TOut, 2);

                            //calculate the U_matrix determinant
                                U := UMatrix(   u0, v0,
                                                u1, v1  );

                                detU := matrixDeterminant(U);

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

                            result := TOut;
                        end;

            function lineIntersectionPointUV(   out LinesIntersectOut : boolean;
                                                const   x0, y0, u0, v0,
                                                        x1, y1, u1, v1 : double ) : TPointF;
                var
                    T               : TArray<double>;
                    point0, point1,
                    pointOut        : TPointF;
                function
                    _UMatrixDeterminantAlmostZero() : boolean;
                        var
                            detU    : double;
                            U       : TLAMatrix;
                        begin
                            U := UMatrix(   u0, v0,
                                            u1, v1  );

                            detU := matrixDeterminant(U);

                            result := (abs(detU) < 1e-3);
                        end;
                function
                    _IntersectionPointsAreEqual() : boolean;
                        begin
                            result := ( isAlmostEqual(point0.X, point1.X) AND isAlmostEqual(point0.Y, point1.Y) );
                        end;
                begin
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

            function lineIntersectionPoint( out LinesIntersectOut           : boolean;
                                            const   l1x0, l1y0, l1x1, l1y1,
                                                    l2x0, l2y0, l2x1, l2y1  : double) : TPointF;
                var
                    u0, v0,
                    u1, v1  : double;
                procedure
                    _extractUnitVectors(const   x0, y0, x1, y1  : double;
                                        out     u, v            : double);
                        var
                            dx, dy,
                            linLen : double;
                        begin
                            dx := x1 - x0;
                            dy := y1 - y0;

                            linLen := lineLength(x0, y0, 0,
                                                 x1, y1, 0);

                            u := dx / linLen;
                            v := dy / linLen;
                        end;
                begin
                    //line 1 parameters
                        _extractUnitVectors(l1x0, l1y0, l1x1, l1y1,
                                            u0, v0                  );

                    //line 2 parameters
                        _extractUnitVectors(l2x0, l2y0, l2x1, l2y1,
                                            u1, v1                  );

                    begin
                        var
                            x0, y0, x1, y1  : double;

                            x0 := l1x0;
                            y0 := l1y0;
                            x1 := l2x0;
                            y1 := l2y0;

                        result := lineIntersectionPointUV(  LinesIntersectOut,
                                                            x0, y0, u0, v0,
                                                            x1, y1, u1, v1      );
                    end;
                end;

end.
