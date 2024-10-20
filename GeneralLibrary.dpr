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
  InterpolatorClass in 'GeneralMath\InterpolatorClass.pas',
  GeometryTypes in 'Geometry\GeometryTypes.pas',
  GeomSpaceVectorClass in 'Geometry\GeomSpaceVectorClass.pas',
  GeometryBaseClass in 'Geometry\GeometryBaseClass.pas',
  GeneralMathMethods in 'GeneralMath\GeneralMathMethods.pas',
  GeometryMathMethods in 'Geometry\GeometryMathMethods.pas',
  LineIntersectionMethods in 'GeneralMath\LinearAlgebra\LineIntersectionMethods.pas',
  SkiaDrawingMethods in 'Graphics\Drawing\Skia\SkiaDrawingMethods.pas',
  LimitStateMaterialClass in 'Engineering\LimitStateMaterialClass.pas',
  LinearAlgebraTypes in 'GeneralMath\LinearAlgebra\LinearAlgebraTypes.pas',
  VectorMethods in 'GeneralMath\LinearAlgebra\VectorMethods.pas',
  MatrixDeterminantMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixDeterminantMethods.pas',
  MatrixHelperMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixHelperMethods.pas',
  MatrixMethods in 'GeneralMath\LinearAlgebra\Matrices\MatrixMethods.pas',
  LimitStateAngleClass in 'Engineering\LimitStateAngleClass.pas',
  GeneralComponentHelperMethods in 'WindowsVCL\GeneralComponentHelperMethods.pas',
  PageControlHelperClass in 'WindowsVCL\HelperClasses\PageControlHelperClass.pas',
  StringGridHelperClass in 'WindowsVCL\HelperClasses\StringGridHelperClass.pas',
  SkiaDrawingClass in 'Graphics\Drawing\Skia\SkiaDrawingClass.pas',
  GeometryDrawingTypes in 'Geometry\GeometryDrawingTypes.pas',
  GeomPolygonClass in 'Geometry\GeomPolygonClass.pas',
  DrawingAxisConversionBaseClass in 'Graphics\Drawing\AxisConversion\DrawingAxisConversionBaseClass.pas',
  DrawingAxisConversionClass in 'Graphics\Drawing\AxisConversion\DrawingAxisConversionClass.pas',
  DrawingAxisConversionPanningClass in 'Graphics\Drawing\AxisConversion\DrawingAxisConversionPanningClass.pas',
  DrawingAxisConversionZoomingClass in 'Graphics\Drawing\AxisConversion\DrawingAxisConversionZoomingClass.pas',
  DrawingAxisConversionCalculationsClass in 'Graphics\Drawing\AxisConversion\DrawingAxisConversionCalculationsClass.pas';

{$R *.res}

begin
end.
