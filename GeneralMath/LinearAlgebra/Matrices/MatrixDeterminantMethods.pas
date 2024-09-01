unit MatrixDeterminantMethods;

interface

    uses
        System.SysUtils, system.Types, system.math,
        GeneralMathMethods,
        LinearAlgebraTypes,
        MatrixHelperMethods,
        VectorMethods
        ;

    //entry cofactor
        function matrixEntryCofactor(   const rowIn, colIn  : integer;
                                        const matrixIn      : TLAMatrix ) : double;

    function gaussElimination(var matrixInOut : TLAMatrix) : boolean; //this function run the gauss elimination algorithm with an identity matrix attached to it

    //determinant
        function matrixDeterminant(const matrixIn : TLAMatrix) : double;

implementation

    //determinant
        //Gauss Elimination
            //subtract factored row
                procedure factoredRowSubtraction(   const rowAboveIn, rowBelowIn    : integer;
                                                    var matrixInOut                 : TLAMatrix );
                    var
                        c, rA, rB           : integer;
                        factor              : double;
                        size                : TLAMatrixSize;
                        rowAbove, rowBelow,
                        rowAboveFactored    : TLAVector;
                    begin
                        //verify rows are valid
                            size := getMatrixSize(matrixInOut);

                            if (size.rows <= rowBelowIn) then
                                exit();

                        //get working indeces
                            c   := rowAboveIn;
                            rA  := c;
                            rB  := rowBelowIn;

                        //get the relevant rows
                            rowAbove := matrixInOut[rA];
                            rowBelow := matrixInOut[rB];

                        //calculate the factor amd multiply by row above
                            factor := rowBelow[c] / rowAbove[c];

                            rowAboveFactored := vectorScalarMultiplication(factor, rowAbove);

                        matrixInOut[rB] := vectorSubtraction(rowBelow, rowAboveFactored);
                    end;

            //zero column
                procedure zeroColumn(   const colIn     : integer;
                                        var matrixInOut : TLAMatrix );
                    var
                        rA, rB  : integer;
                        size    : TLAMatrixSize;
                    begin
                        rA   := colIn;
                        size := getMatrixSize(matrixInOut);

                        for rB := (rA + 1) to (size.rows - 1) do
                            factoredRowSubtraction(rA, rB, matrixInOut);
                    end;

            function gaussElimination(var matrixInOut : TLAMatrix) : boolean; //this function run the gauss elimination algorithm with an identity matrix attached to it
                var
                    col     : integer;
                    size    : TLAMatrixSize;
                procedure
                    _insertIdentityMatrix();
                        var
                            i, j : integer;
                        begin
                            //resize the matrix to be n x 2n
                                size := getMatrixSize(matrixInOut);

                                setMatrixSize(  size.rows, (2 * size.cols),
                                                matrixInOut                 );

                            //tag the identity matrix on the right
                                for i := 0 to (size.rows - 1) do
                                    for j := (size.cols) to (2 * size.cols - 1) do
                                        if ( i = (j - size.cols) ) then
                                            matrixInOut[i][j] := 1
                                        else
                                            matrixInOut[i][j] := 0;
                        end;
                procedure
                    _cleanMatrix();
                        var
                            i, j : integer;
                        begin
                            for i := 0 to (size.rows - 1) do
                                for j := 0 to (2 * size.cols - 1) do
                                    begin
                                        if ( isAlmostZero(matrixInOut[i][j]) ) then
                                            matrixInOut[i][j] := 0;
                                    end;
                        end;
                begin
                    //restricted to square matrices only
                        if ( NOT(matrixIsSquare(matrixInOut)) ) then
                            begin
                                result := false;
                                exit();
                            end;

                    //if the [0, 0] entry is zero gauss elimination cannot procede
                        if ( isAlmostZero( matrixInOut[0][0] ) ) then
                            begin
                                result := false;
                                exit();
                            end;

                    _insertIdentityMatrix();

                    for col := 0 to (size.cols - 2) do
                        zeroColumn(col, matrixInOut);

                    _cleanMatrix();
                end;

            function matrixGaussElimination(out successfulOut   : boolean;
                                            const matrixIn      : TLAMatrix) : TLAMatrix; overload;
                var
                    size                        : TLAMatrixSize;
                    matrixOut                   : TLAMatrix;
                begin
                    matrixCopy(matrixIn, matrixOut);

                    successfulOut := gaussElimination(matrixOut);

                    if ( NOT(successfulOut) )then
                        exit();

                    size := getMatrixSize(matrixIn);

                    setMatrixSize(size, matrixOut);

                    result := matrixOut;
                end;

            function matrixGaussElimination(const matrixIn : TLAMatrix) : TLAMatrix; overload;
                var
                    dummy : boolean;
                begin
                    result := matrixGaussElimination(dummy, matrixIn);
                end;

        function matrixDeterminantGauss(const matrixIn : TLAMatrix) : double;
            var
                gaussElimMatrix : TLAMatrix;
            begin

            end;

        //cofactor expansion methods (Laplace)
            //sub matrix
                function subMatrix( const rowIn, colIn  : integer;
                                    const matrixIn      : TLAMatrix) : TLAMatrix;
                    var
                        dimension, subDimension,
                        i,
                        r, c            : integer;
                        subMatrixOut    : TLAMatrix;
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

            //minor entry of M[i, j]
                function matrixEntryMinor(  const rowIn, colIn  : integer;
                                            const matrixIn      : TLAMatrix) : double;
                    var
                        i, j        : integer;
                        minorOut    : double;
                        subMat      : TLAMatrix;
                    begin
                        i := rowIn;
                        j := colIn;

                        subMat := subMatrix(i, j, matrixIn);

                        minorOut := matrixDeterminant(subMat);

                        result := minorOut;
                    end;

            //cofactor entry of M[i, j]
                function matrixEntryCofactor(   const rowIn, colIn  : integer;
                                                const matrixIn      : TLAMatrix) : double;
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





        function determinantRec(const matrixIn : TLAMatrix) : double;
            var
                j,
                dimension           : integer;
                a_ij, C_ij, M_ij,
                determinantValueOut : double;
                minorMatrix         : TLAMatrix;
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

        function matrixDeterminant(const matrixIn : TLAMatrix) : double;
            begin
                result := determinantRec(matrixIn);
            end;


end.
