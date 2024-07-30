unit TestLinearAlgeberaMethods;

interface

uses
    system.SysUtils,
    DUnitX.TestFramework;

type
  [TestFixture]
  TTestLinearAlgebraMethods = class
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure TestDeterminant();
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

    uses
        GeneralMathMethods,
        LinearAlgeberaMethods;

procedure TTestLinearAlgebraMethods.Setup;
begin
end;

procedure TTestLinearAlgebraMethods.TearDown;
begin
end;

procedure TTestLinearAlgebraMethods.TestDeterminant();
var
    actual, expected    : double;
    testMatrix          : TArray< TArray<double> >;
begin
    //2 x 2
        SetLength(testMatrix, 2);
        SetLength(testMatrix[0], 2);
        SetLength(testMatrix[1], 2);

        testMatrix[0] := [1, 2];
        testMatrix[1] := [3, 4];

        actual := determinant(testMatrix);
        expected := -2;

        Assert.AreEqual(expected, actual, 10e-6, '2x2');

    //3 x 3
        SetLength(testMatrix, 3);
        SetLength(testMatrix[0], 3);
        SetLength(testMatrix[1], 3);
        SetLength(testMatrix[2], 3);

        testMatrix[0] := [1, 8, 5];
        testMatrix[1] := [6, 4, 2];
        testMatrix[2] := [9, 7, 3];

        actual := determinant(testMatrix);
        expected := 28;

        Assert.AreEqual(expected, actual, 10e-6, '3x3');

    //4 x 4
        SetLength(testMatrix, 4);
        SetLength(testMatrix[0], 4);
        SetLength(testMatrix[1], 4);
        SetLength(testMatrix[2], 4);
        SetLength(testMatrix[3], 4);

        testMatrix[0] := [ 1,  5, 16, 11];
        testMatrix[1] := [ 3, 14, 12, 10];
        testMatrix[2] := [ 9, 10, 11, 12];
        testMatrix[3] := [13, 14, 15, 16];

        actual := determinant(testMatrix);
        expected := 832;

        Assert.AreEqual(expected, actual, 10e-6, '4x4');
end;

procedure TTestLinearAlgebraMethods.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestLinearAlgebraMethods);

end.
