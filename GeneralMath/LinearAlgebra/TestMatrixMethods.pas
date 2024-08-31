unit TestMatrixMethods;

interface

    uses
        system.SysUtils,
        DUnitX.TestFramework;

    type
      [TestFixture]
      TTestMatrixMethods = class
      public
//        [Setup]
//        procedure Setup;
//        [TearDown]
//        procedure TearDown;
        // Sample Methods
        // Simple single Test
        [Test]
        procedure TestDeterminantAndInverse();
        [Test]
        procedure TestMatrixMultiplication();
        // Test with TestCase Attribute to supply parameters.
      end;

implementation

    uses
        GeneralMathMethods,
        LinearAlgebraTypes,
        MatrixHelperMethods,
        MatrixMethods,
        VectorMethods;

//procedure TTestMatrixMethods.Setup();
//begin
//end;
//
//procedure TTestMatrixMethods.TearDown();
//begin
//end;

procedure TTestMatrixMethods.TestDeterminantAndInverse();
var
    matDet, invDet          : double;
    testMatrix, inverseMat  : TLAMatrix;
begin
    //2 x 2
        testMatrix := [ [1, 2],
                        [3, 4]  ];

        matDet := matrixDeterminant(testMatrix);
        inverseMat := matrixInverse(testMatrix);
        invDet := matrixDeterminant(inverseMat);

        Assert.AreEqual(invDet, 1 / matDet, 1e-3);

    //3 x 3
        testMatrix := [ [1, 8, 5],
                        [6, 4, 2],
                        [9, 7, 3]   ];

        matDet := matrixDeterminant(testMatrix);
        inverseMat := matrixInverse(testMatrix);
        invDet := matrixDeterminant(inverseMat);

        Assert.AreEqual(invDet, 1 / matDet, 1e-3);

    //4 x 4
        testMatrix := [ [ 1,  5, 16, 11],
                        [ 3, 14, 12, 10],
                        [ 9, 10, 11, 12],
                        [13, 14, 15, 16]    ];

        matDet := matrixDeterminant(testMatrix);
        inverseMat := matrixInverse(testMatrix);
        invDet := matrixDeterminant(inverseMat);

        Assert.AreEqual(invDet, 1 / matDet, 1e-3);
end;

procedure TTestMatrixMethods.TestMatrixMultiplication();
    var
        matrix1, matrix2, multMat, expectedMat  : TLAMatrix;
        vector, resultVector, expectedVector    : TLAVector;
    begin
        matrix1 :=  [
                        [1, 2, 3, 4],
                        [2, 3, 4, 5],
                        [3, 4, 5, 6]
                    ];

        matrix2 :=  [
                        [1, 2, 3],
                        [2, 3, 4],
                        [3, 4, 5],
                        [4, 5, 6]
                    ];

        multMat := matrixMultiplication(matrix1, matrix2);

        expectedMat :=  [
                            [30, 40, 50],
                            [40, 54, 68],
                            [50, 68, 86]
                        ];

        Assert.IsTrue( matricesEqual(multMat, expectedMat) );

        //------------------------------------------------------------

        matrix1 :=  [
                        [1, 2, 3, 4, 5],
                        [2, 3, 4, 5, 6],
                        [3, 4, 5, 6, 7]
                    ];

        matrix2 :=  [
                        [1, 2, 3],
                        [2, 3, 4],
                        [3, 4, 5],
                        [4, 5, 6],
                        [5, 6, 7]
                    ];

        multMat := matrixMultiplication(matrix1, matrix2);

        expectedMat :=  [
                            [55,  70,  85],
                            [70,  90, 110],
                            [85, 110, 135]
                        ];

        Assert.IsTrue( matricesEqual(multMat, expectedMat) );

        //------------------------------------------------------------

        matrix1 :=  [
                        [1, 2, 3, 4, 5],
                        [2, 3, 4, 5, 6],
                        [3, 4, 5, 6, 7]
                    ];

        vector := [1, 2, 3, 4, 5];

        resultVector := matrixMultiplication(matrix1, vector);

        expectedVector := [55, 70, 85];

        Assert.IsTrue( vectorsEqual(resultVector, expectedVector) );
    end;

initialization

    TDUnitX.RegisterTestFixture(TTestMatrixMethods);

end.
