unit MatrixMethods;

interface

    uses
        System.SysUtils, system.Types, system.math,
        GeneralMathMethods,
        LinearAlgebraTypes,
        VectorMethods
        ;

    //determinant
        function matrixDeterminant(const matrixIn : TLAMatrix) : double;

    //equality
        function matricesEqual(matrix1In, matrix2In : TLAMatrix) : boolean;

    //inverse
        function matrixInverse(const matrixIn : TLAMatrix) : TLAMatrix;

    //multiplication
        function matrixMultiplication(const matrix1In, matrix2In : TLAMatrix) : TLAMatrix; overload;
        function matrixMultiplication(  const matrixIn : TLAMatrix;
                                        const vectorIn : TLAVector  ) : TLAVector; overload;

    //solve linear equation system
        function solveLinearSystem( const coefficientmatrixIn   : TLAMatrix;
                                    const constantVectorIn      : TLAVector ) : TLAVector;

    //transpose
        function matrixTranspose(const matrixIn : TLAMatrix) : TLAMatrix;

implementation

    //general methods
        //get a matrix size
            function getMatrixSize(const matrixIn : TLAMatrix) : TLAMatrixSize;
                var
                    r,
                    rowCount, colCount  : integer;
                    matrixDimensionsOut : TLAMatrixSize;
                begin
                    rowCount := length(matrixIn);
                    colCount := length(matrixIn[0]);

                    for r := 1 to (rowCount - 1) do
                        if (length(matrixIn[r]) <> colCount) then
                            begin
                                colCount := -1;
                                exit();
                            end;

                    matrixDimensionsOut.rows := rowCount;
                    matrixDimensionsOut.cols := colCount;

                    result := matrixDimensionsOut;
                end;

        //test if a matrix is square
            function matrixIsSquare(const matrixIn : TLAMatrix) : boolean;
                var
                    matrixDimensions : TLAMatrixSize;
                begin
                    matrixDimensions := getMatrixSize(matrixIn);

                    result := matrixDimensions.isSquare();
                end;

        //set a matrix size
            procedure setMatrixSize(const newRowCountIn, newColCountIn  : integer;
                                    var matrixInOut                     : TLAMatrix); overload;
                var
                    r : integer;
                begin
                    SetLength(matrixInOut, newRowCountIn);

                    for r := 0 to (newRowCountIn - 1) do
                        SetLength(matrixInOut[r], newColCountIn);
                end;

            procedure setMatrixSize(const newSizeIn : TLAMatrixSize;
                                    var matrixInOut : TLAMatrix     ); overload;
                begin
                    setMatrixSize(newSizeIn.rows, newSizeIn.cols, matrixInOut);
                end;

        //create a new matrix with a set size
            function newMatrix(rowCountIn, colCountIn : integer) : TLAMatrix; overload;
                var
                    matrixOut : TLAMatrix;
                begin
                    setMatrixSize(rowCountIn, colCountIn, matrixOut);

                    result := matrixOut;
                end;

            function newMatrix(const newSizeIn : TLAMatrixSize) : TLAMatrix; overload;
                begin
                    result := newMatrix(newSizeIn.rows, newSizeIn.cols);
                end;

        //copy a matrix
            procedure copyMatrix(   const readMatrixIn      : TLAMatrix;
                                    var writeMatrixInOut    : TLAMatrix );
                var
                    c, r        : integer;
                    matrixSize  : TLAMatrixSize;
                begin
                    matrixSize := getMatrixSize(readMatrixIn);

                    setMatrixSize(  matrixSize.rows, matrixSize.cols,
                                    writeMatrixInOut                    );

                    for r := 0 to (matrixSize.rows - 1) do
                        for c := 0 to (matrixSize.cols - 1) do
                            writeMatrixInOut[r][c] := readMatrixIn[r][c];
                end;

        //multiply a matrix by a scalar
            function matrixScalarMultiplication(const scalarIn : double;
                                                const matrixIn      : TLAMatrix) : TLAMatrix;
                var
                    c, r        : integer;
                    matrixSize  : TLAMatrixSize;
                    matrixOut   : TLAMatrix;
                begin
                    copyMatrix(matrixIn, matrixOut);

                    matrixSize := getMatrixSize(matrixIn);

                    for r := 0 to (matrixSize.rows - 1) do
                        for c := 0 to (matrixSize.cols - 1) do
                            matrixOut[r, c] := scalarIn * matrixOut[r, c];

                    result := matrixOut;
                end;

        //test if 2 matrices are the same size
            function matricesAreSameSize(const matrix1In, matrix2In : TLAMatrix) : boolean;
                var
                    colCount1,  colCount2,
                    row,
                    rowCount1,  rowCount2   : integer;
                    rowVector1, rowVector2  : TLAVector;
                begin
                    //the row count of both matrices must be equal
                        rowCount1 := length(matrix1In);
                        rowCount2 := Length(matrix2In);

                        if (rowCount1 <> rowCount2) then
                            begin
                                result := False;
                                exit();
                            end;

                    //each column of both matrices must be equal in size
                        for row := 0 to (rowCount1 - 1) do
                            begin
                                rowVector1 := matrix1In[row];
                                rowVector2 := matrix2In[row];

                                if ( NOT(vectorsAreSameSize(rowVector1, rowVector2)) ) then
                                    begin
                                        result := False;
                                        exit();
                                    end;
                            end;

                    result := True;
                end;

    //determinant
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

    //equality
        function matricesEqual(matrix1In, matrix2In : TLAMatrix) : boolean;
            var
                r,      c       : integer;
                size1,  size2   : TLAMatrixSize;
            function
                _elementsAreEqual(const rowIn, colIn : integer) : boolean;
                    var
                        value1, value2 : double;
                    begin
                        value1 := matrix1In[rowIn][colIn];
                        value2 := matrix2In[rowIn][colIn];

                        result := isAlmostEqual(value1, value2);
                    end;
            begin
                //get sizes
                    size1 := getMatrixSize(matrix1In);
                    size2 := getMatrixSize(matrix2In);

                //if the sizes are not equal the matrices are not equal
                    if ( NOT(size1.isEqual(size2)) ) then
                        begin
                            result := False;
                            exit();
                        end;

                //test each eleement for equality
                    for r := 0 to (size1.rows - 1) do
                        for c := 0 to (size1.cols - 1) do
                            if ( NOT(_elementsAreEqual(r, c)) ) then
                                begin
                                    result := False;
                                    exit();
                                end;

                result := True;
            end;

    //inverse
        //helper methods
            function cofactorMatrix(const matrixIn : TLAMatrix) : TLAMatrix;
                var
                    i, j        : integer;
                    C_ij        : double;
                    matrixSize  : TLAMatrixSize;
                    coFacMatOut : TLAMatrix;
                begin
                    if ( NOT(matrixIsSquare(matrixIn)) ) then
                        exit();

                    matrixSize := getMatrixSize(matrixIn);

                    coFacMatOut := newMatrix(matrixSize);

                    for i := 0 to (matrixSize.rows - 1) do
                        for j := 0 to (matrixSize.cols - 1) do
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

    //multiplication
        //helper methods
            function getMatrixColumn(   const colIn     : integer;
                                        const matrixIn  : TLAMatrix ) : TLAVector;
                var
                    i, rowCount     : integer;
                    columnVectorOut : TLAVector;
                begin
                    rowCount := length(matrixIn);

                    SetLength(columnVectorOut, rowCount);

                    for i := 0 to (rowCount - 1) do
                        columnVectorOut[i] := matrixIn[i][colIn];

                    result := columnVectorOut;
                end;

            function getMatrixRow(  const rowIn     : integer;
                                    const matrixIn  : TLAMatrix ) : TLAVector;
                begin
                    result := matrixIn[rowIn];
                end;

        function matrixMultiplication(const matrix1In, matrix2In : TLAMatrix) : TLAMatrix;
            var
                r, c            : integer;
                vectorProduct   : double;
                size1, size2    : TLAMatrixSize;
                newMatrixOut    : TLAMatrix;
            function
                _matrixSizesAreCompatible() : boolean;
                    begin
                        //matrix1 must be m x r
                        //matrix2 must be r x n

                        size1 := getMatrixSize(matrix1In);
                        size2 := getMatrixSize(matrix2In);

                        _matrixSizesAreCompatible := (size1.cols = size2.rows);
                    end;
            function
                _multiplyRowAndColVectors(const rowIn, colIn : integer) : double;
                    var
                        colVector, rowVector : TLAVector;
                    begin
                        //row vector from matrix 1
                            rowVector := getMatrixRow(rowIn, matrix1In);

                        //column vector from matrix 2
                            colVector := getMatrixColumn(colIn, matrix2In);

                        _multiplyRowAndColVectors := vectorDotProduct(rowVector, colVector);
                    end;
            begin
                if ( NOT(_matrixSizesAreCompatible()) ) then
                    exit();

                newMatrixOut := newMatrix(size1.rows, size2.cols);

                for r := 0 to (size1.rows - 1) do
                    for c := 0 to (size2.cols - 1) do
                        begin
                            vectorProduct := _multiplyRowAndColVectors(r, c);

                            newMatrixOut[r][c] := vectorProduct;
                        end;

                result := newMatrixOut;
            end;

        function matrixMultiplication(  const matrixIn : TLAMatrix;
                                        const vectorIn : TLAVector  ) : TLAVector;
            var
                rowVectorMat,
                columnVectorMat,
                multMat         : TLAMatrix;
                vectorOut       : TLAVector;
            begin
                //convert the vector into a matrix (n x 1)
                    SetLength(rowVectorMat, 1);

                    rowVectorMat[0] := vectorIn;

                    columnVectorMat := matrixTranspose(rowVectorMat);

                //multiply the two matrices
                    multMat := matrixMultiplication(matrixIn, columnVectorMat);

                //convert the result of the matrix multiplication back to a vector
                    rowVectorMat := matrixTranspose(multMat);

                    vectorOut := rowVectorMat[0];

                result := vectorOut;
            end;

    //solve linear equation system
        function solveLinearSystem( const coefficientmatrixIn   : TLAMatrix;
                                    const constantVectorIn      : TLAVector ) : TLAVector;
            var
                detCoeffMat     : double;
                coeffInverse    : TLAMatrix;
                solutionVector  : TLAVector;
            begin
                //solution only exists if the coefficient matrix determinant is not zero
                    detCoeffMat := matrixDeterminant(coefficientmatrixIn);

                    if (detCoeffMat < 1e-3) then
                        exit();

                //Ax = b;
                //x := inv(A) * b
                    coeffInverse := matrixInverse(coefficientmatrixIn);

                    solutionVector := matrixMultiplication(coeffInverse, constantVectorIn);

                result := solutionVector;
            end;

    //transpose
        function matrixTranspose(const matrixIn : TLAMatrix) : TLAMatrix;
            var
                r, c                : integer;
                matrixSize          : TLAMatrixSize;
                transposedMatrixOut : TLAMatrix;
            begin
                matrixSize := getMatrixSize(matrixIn);

                transposedMatrixOut := newMatrix(matrixSize.cols, matrixSize.rows);

                for r := 0 to (matrixSize.rows - 1) do
                    for c := 0 to (matrixSize.cols - 1) do
                        transposedMatrixOut[c][r] := matrixIn[r][c];

                result := transposedMatrixOut;
            end;


end.
