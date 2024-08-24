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
        // Test with TestCase Attribute to supply parameters.
      end;

implementation

    uses
        GeneralMathMethods,
        LinearAlgebraTypes,
        MatrixMethods;

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

initialization
  TDUnitX.RegisterTestFixture(TTestMatrixMethods);

end.
