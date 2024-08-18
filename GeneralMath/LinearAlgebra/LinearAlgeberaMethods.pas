unit LinearAlgeberaMethods;

interface

    uses
        System.SysUtils, system.Types
        ;

    //line method
        //length
            function lineLength(const   x0, y0, z0,
                                        x1, y1, z1 : double) : double;

        //intersection
            function lineIntersectionPoint( out LinesIntersectOut : boolean;
                                            const   x0, y0, u0, v0,
                                                    x1, y1, u1, v1 : double ) : TPointF;

    //matrices
        //matrix determinant
            function matrixDeterminant(const matrixIn : TArray< TArray<double> >) : double;

        //matrix transpose
            function matrixTranspose(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;

        //matrix inverse
            function matrixInverse(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;

    //triangle area given three vertices
        function triangleArea(const x1, y1,
                                    x2, y2,
                                    x3, y3  : double) : double;

implementation

    uses
        system.Math,
        GeneralMathMethods
        ;

    //line methods
        //length
            function lineLength(const   x0, y0, z0,
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
                    function UMatrix(const  u0, v0,
                                            u1, v1  : double) : TArray< TArray<double> >;
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
                            U       : TArray< TArray<double>>;
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

                            detU := matrixDeterminant(U);

                            result := (abs(detU) < 1e-3);
                        end;
                function
                    _IntersectionPointsAreEqual() : boolean;
                        begin
                            result := ( isAlmostEqual(point0.X, point1.X) AND isAlmostEqual(point0.Y, point1.Y) );
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

    //matrices
        //general methods
            //test if a matrix is square
                function matrixIsSquare(const matrixIn : TArray< TArray<double> >) : boolean;
                    var
                        colN, rowN : integer;
                    begin
                        colN := length(matrixIn[0]);
                        rowN := length(matrixIn);

                        result := (colN = rowN);
                    end;

            //get a matrix size
                procedure getMatrixSize(out rowCountOut, colCountOut : integer;
                                        const matrixIn      : TArray< TArray<double> >);
                    begin
                        rowCountOut := length(matrixIn);
                        colCountOut := length(matrixIn[0]);
                    end;

            //set a matrix size
                procedure setMatrixSize(const newRowCountIn, newColCountIn  : integer;
                                        var matrixInOut                     : TArray< TArray<double> >);
                    var
                        r : integer;
                    begin
                        SetLength(matrixInOut, newRowCountIn);

                        for r := 0 to (newRowCountIn - 1) do
                            SetLength(matrixInOut[r], newColCountIn);
                    end;

            //create a new matrix with a set size
                function newMatrix(rowCountIn, colCountIn : integer) : TArray< TArray<double> >;
                    var
                        matrixOut : TArray< TArray<double> >;
                    begin
                        setMatrixSize(rowCountIn, colCountIn, matrixOut);

                        result := matrixOut;
                    end;

            //copy a matrix
                procedure copyMatrix(   const readMatrixIn      : TArray< TArray<double> >;
                                        var writeMatrixInOut    : TArray< TArray<double> >);
                    var
                        c,      r,
                        colN,   rowN : integer;
                    begin
                        getMatrixSize(rowN, colN, readMatrixIn);

                        setMatrixSize(rowN, colN, writeMatrixInOut);

                        for r := 0 to (rowN - 1) do
                            for c := 0 to (colN - 1) do
                                writeMatrixInOut[r][c] := readMatrixIn[r][c];
                    end;

            //multiply a matrix by a scalar
                function matrixScalarMultiplication(const scalarIn : double;
                                                    const matrixIn      : TArray< TArray<double> >) : TArray< TArray<double> >;
                    var
                        r,      c,
                        rowN,   colN    : integer;
                        matrixOut       : TArray< TArray<double> >;
                    begin
                        copyMatrix(matrixIn, matrixOut);

                        getMatrixSize(rowN, colN, matrixOut);

                        for r := 0 to (rowN - 1) do
                            for c := 0 to (colN - 1) do
                                matrixOut[r, c] := scalarIn * matrixOut[r, c];

                        result := matrixOut;
                    end;

        //matrix determinant
            //helper methods
                function subMatrix( const rowIn, colIn  : integer;
                                    const matrixIn      : TArray< TArray<double> >) : Tarray< TArray<double> >;
                    var
                        dimension, subDimension,
                        i,
                        r, c            : integer;
                        subMatrixOut    : Tarray< TArray<double> >;
                    procedure
                        _populateRow(rowIn : integer);
                            var
                                col,
                                j   : integer;
                            begin
                                //start at column 0
                                    col := 0;

                                //loop through the columns
                                    for j := 0 to (dimension - 1) do
                                        begin
                                            //if the read column, j, = colIn then it must NOT be copied
                                                if (j <> colIn) then
                                                    begin
                                                        subMatrixOut[rowIn][col] := matrixIn[i][j];

                                                        inc(col);
                                                    end;
                                        end;
                            end;
                    begin
                        //get the minor-matrix dimension
                            dimension   := length(matrixIn);
                            subDimension := dimension - 1;

                        //size the minor-matrix
                            SetLength(subMatrixOut, subDimension);

                            for c := 0 to (subDimension - 1) do
                                SetLength(subMatrixOut[c], subDimension);

                        //assign the values to the minor-matrix
                            r := 0;

                            for i := 0 to (dimension - 1) do
                                begin
                                    //populate the row if i != rowIn
                                        if (i <> rowIn) then
                                            begin
                                                _populateRow(r);

                                                inc(r);
                                            end;
                                end;

                        result := subMatrixOut;
                    end;

                function matrixEntryMinor(  const rowIn, colIn  : integer;
                                            const matrixIn      : TArray< TArray<double> >) : double;
                    var
                        i, j        : integer;
                        minorOut    : double;
                        subMat      : TArray< TArray<double> >;
                    begin
                        i := rowIn;
                        j := colIn;

                        subMat := subMatrix(i, j, matrixIn);

                        minorOut := matrixDeterminant(subMat);

                        result := minorOut;
                    end;

                function matrixEntryCofactor(   const rowIn, colIn  : integer;
                                                const matrixIn      : TArray< TArray<double> >) : double;
                    var
                        i, j                : integer;
                        entryMinor,
                        entryCofactorOut    : double;
                    begin
                        i := rowIn;
                        j := colIn;

                        entryMinor := matrixEntryMinor(i, j, matrixIn);

                        entryCofactorOut := power( -1, (i + j) ) * entryMinor;

                        result := entryCofactorOut;
                    end;

            function determinantRec(const matrixIn : TArray< TArray<double> >) : double;
                var
                    j,
                    dimension           : integer;
                    a_ij, C_ij, M_ij,
                    determinantValueOut : double;
                    minorMatrix         : TArray< TArray<double> >;
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

                        for j := 0 to (dimension - 1) do
                            begin
                                a_ij := matrixIn[0][j];

                                if (NOT(a_ij = 0)) then
                                    begin
                                        C_ij := matrixEntryCofactor(0, j, matrixIn);

                                        determinantValueOut := determinantValueOut + (a_ij * C_ij);
                                    end;
                            end;

                    result := determinantValueOut;
                end;

            function matrixDeterminant(const matrixIn : TArray< TArray<double> >) : double;
                begin
                    result := determinantRec(matrixIn);
                end;

        //matrix transpose
            function matrixTranspose(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;
                var
                    r,      c,
                    rowN,   colN        : integer;
                    transposedMatrixOut : TArray< TArray<double> >;
                begin
                    getMatrixSize(rowN, colN, matrixIn);

                    transposedMatrixOut := newMatrix(colN, rowN);

                    for r := 0 to (rowN - 1) do
                        for c := 0 to (colN - 1) do
                            transposedMatrixOut[c][r] := matrixIn[r][c];

                    result := transposedMatrixOut;
                end;

        //matrix inverse
            //helper methods
                function cofactorMatrix(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;
                    var
                        i,      j,
                        rowN,   colN    : integer;
                        C_ij            : double;
                        coFacMatOut     : TArray< TArray<double> >;
                    begin
                        if ( NOT(matrixIsSquare(matrixIn)) ) then
                            exit();

                        getMatrixSize(rowN, colN, matrixIn);

                        coFacMatOut := newMatrix(rowN, colN);

                        for i := 0 to (rowN - 1) do
                            for j := 0 to (colN - 1) do
                                begin
                                    C_ij := matrixEntryCofactor(i, j, matrixIn);

                                    coFacMatOut[i][j] := C_ij;
                                end;

                        result := coFacMatOut;
                    end;

                function matrixAdjoint(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;
                    var
                        adjointMatrixOut,
                        coFacMat            : TArray< TArray<double> >;
                    begin
                        coFacMat := cofactorMatrix(matrixIn);

                        adjointMatrixOut := matrixTranspose(coFacMat);

                        result := adjointMatrixOut;
                    end;

            function matrixInverse(const matrixIn : TArray< TArray<double> >) : TArray< TArray<double> >;
                var
                    matDet : double;
                    matAdj,
                    matInv : TArray< TArray<double> >;
                begin
                    matDet := matrixDeterminant(matrixIn);

                    if (matDet < 1e-3) then
                        exit();

                    matAdj := matrixAdjoint(matrixIn);

                    matInv := matrixScalarMultiplication(1 / matDet, matAdj);

                    result := matInv;
                end;

    //triangle area given three vertices
        function triangleArea(const x1, y1,
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

                result := 0.5 * matrixDeterminant(coordinateMatrix);
            end;

end.
