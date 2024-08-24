unit MatrixMethods;

interface

    uses
        System.SysUtils, system.Types, system.math,
        LinearAlgebraTypes,
        VectorMethods
        ;

    //matrix determinant
        function matrixDeterminant(const matrixIn : TLAMatrix) : double;

    //matrix transpose
        function matrixTranspose(const matrixIn : TLAMatrix) : TLAMatrix;

    //matrix inverse
        function matrixInverse(const matrixIn : TLAMatrix) : TLAMatrix;

implementation

    //general methods
        //test if a matrix is square
            function matrixIsSquare(const matrixIn : TLAMatrix) : boolean;
                var
                    colN, rowN : integer;
                begin
                    colN := length(matrixIn[0]);
                    rowN := length(matrixIn);

                    result := (colN = rowN);
                end;

        //get a matrix size
            procedure getMatrixSize(out rowCountOut, colCountOut : integer;
                                    const matrixIn      : TLAMatrix);
                begin
                    rowCountOut := length(matrixIn);
                    colCountOut := length(matrixIn[0]);
                end;

        //set a matrix size
            procedure setMatrixSize(const newRowCountIn, newColCountIn  : integer;
                                    var matrixInOut                     : TLAMatrix);
                var
                    r : integer;
                begin
                    SetLength(matrixInOut, newRowCountIn);

                    for r := 0 to (newRowCountIn - 1) do
                        SetLength(matrixInOut[r], newColCountIn);
                end;

        //create a new matrix with a set size
            function newMatrix(rowCountIn, colCountIn : integer) : TLAMatrix;
                var
                    matrixOut : TLAMatrix;
                begin
                    setMatrixSize(rowCountIn, colCountIn, matrixOut);

                    result := matrixOut;
                end;

        //copy a matrix
            procedure copyMatrix(   const readMatrixIn      : TLAMatrix;
                                    var writeMatrixInOut    : TLAMatrix);
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
                                                const matrixIn      : TLAMatrix) : TLAMatrix;
                var
                    r,      c,
                    rowN,   colN    : integer;
                    matrixOut       : TLAMatrix;
                begin
                    copyMatrix(matrixIn, matrixOut);

                    getMatrixSize(rowN, colN, matrixOut);

                    for r := 0 to (rowN - 1) do
                        for c := 0 to (colN - 1) do
                            matrixOut[r, c] := scalarIn * matrixOut[r, c];

                    result := matrixOut;
                end;

        //test if 2 matrices are the same size
            function matricesAreSameSize(const matrix1In, matrix2In : TLAMatrix) : boolean;
                var
                    rowCount1, rowCount2 : integer;
                begin
                    rowCount1 := length(matrix1In);

                end;

    //matrix determinant
        //helper methods
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

    //matrix transpose
        function matrixTranspose(const matrixIn : TLAMatrix) : TLAMatrix;
            var
                r,      c,
                rowN,   colN        : integer;
                transposedMatrixOut : TLAMatrix;
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
            function cofactorMatrix(const matrixIn : TLAMatrix) : TLAMatrix;
                var
                    i,      j,
                    rowN,   colN    : integer;
                    C_ij            : double;
                    coFacMatOut     : TLAMatrix;
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

            function matrixAdjoint(const matrixIn : TLAMatrix) : TLAMatrix;
                var
                    adjointMatrixOut,
                    coFacMat            : TLAMatrix;
                begin
                    coFacMat := cofactorMatrix(matrixIn);

                    adjointMatrixOut := matrixTranspose(coFacMat);

                    result := adjointMatrixOut;
                end;

        function matrixInverse(const matrixIn : TLAMatrix) : TLAMatrix;
            var
                matDet : double;
                matAdj,
                matInv : TLAMatrix;
            begin
                matDet := matrixDeterminant(matrixIn);

                if (abs(matDet) < 1e-3) then
                    exit();

                matAdj := matrixAdjoint(matrixIn);

                matInv := matrixScalarMultiplication(1 / matDet, matAdj);

                result := matInv;
            end;


end.
