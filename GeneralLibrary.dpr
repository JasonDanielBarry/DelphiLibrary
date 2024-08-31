library GeneralLibrary;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  System.SysUtils,
  System.Classes,
  GeomLineClass in 'Geometry\GeomLineClass.pas',
  GeomPolyLineClass in 'Geometry\GeomPolyLineClass.pas',
  StringGridHelperClass in 'VCLComponents\StringGridHelperClass.pas',
  GeneralComponentHelperMethods in 'VCLComponents\GeneralComponentHelperMethods.pas',
  InterpolatorClass in 'GeneralMath\InterpolatorClass.pas',
  GeometryTypes in 'Geometry\GeometryTypes.pas',
  GeomSpaceVectorClass in 'Geometry\GeomSpaceVectorClass.pas',
  GeometryBaseClass in 'Geometry\GeometryBaseClass.pas',
  GeneralMathMethods in 'GeneralMath\GeneralMathMethods.pas',
  GeometryMathMethods in 'Geometry\GeometryMathMethods.pas',
  LineIntersectionMethods in 'GeneralMath\LinearAlgebra\LineIntersectionMethods.pas',
  DrawingAxisConversionClass in 'Graphics\Drawing\DrawingAxisConversionClass.pas',
  DrawingTypes in 'Graphics\Drawing\DrawingTypes.pas',
  SkiaDrawingMethods in 'Graphics\Drawing\Skia\SkiaDrawingMethods.pas',
  LimitStateTypes in 'Engineering\LimitStateTypes.pas',
  LinearAlgebraTypes in 'GeneralMath\LinearAlgebra\LinearAlgebraTypes.pas',
  VectorMethods in 'GeneralMath\LinearAlgebra\VectorMethods.pas',
  MatrixDeterminantMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixDeterminantMethods.pas',
  MatrixHelperMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixHelperMethods.pas',
  MatrixMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixMethods.pas';

{$R *.res}

begin
end.
