unit SkiaDrawingMethods;

interface

    uses
        //Delphi
            System.Skia, Vcl.Skia,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes, GeomPolyLineClass;

implementation

    //draw polyline
        procedure drawPolyLine( const polylineIn        : TGeomPolyLine;
                                const axisConverterIn   : TDrawingAxisConverter;
                                const paintIn           : ISkPaint;
                                var canvasInOut         : ISkCanvas             );
            var
                pathbuilder : ISkPathBuilder;
            begin

            end;

end.
