unit SkiaDrawingMethods;

interface

    uses
        //Delphi
            system.types, system.UITypes,
            System.Skia, Vcl.Skia,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes, GeomPolyLineClass;

implementation

    //draw polyline
        procedure drawSkiaPolygon(  const polylineIn        : TGeomPolyLine;
                                    const colourIn          : TAlphaColor;
                                    const axisConverterIn   : TDrawingAxisConverter;
                                    var canvasInOut         : ISkCanvas             );
            var
                drawingPoints   : TArray<TPointF>;
                pathbuilder     : ISkPathBuilder;
                path            : ISkPath;
                paint           : ISkPaint;
            begin

                //convert geometry into canvas drawing points
                    drawingPoints := axisConverterIn.arrXY_to_arrLTF(
                                                                        polylineIn.drawingPoints()
                                                                    );

                //define the drawing path
                    pathbuilder := TSkPathBuilder.Create();

                    pathbuilder.MoveTo(drawingPoints[0]);

                    pathbuilder.PolylineTo(drawingPoints);

                    pathbuilder.LineTo(drawingPoints[0]);
                    pathbuilder.LineTo(drawingPoints[1]);

                    path := pathbuilder.Detach();

                //draw the shape
                    paint := TSkPaint.create();

                    //line
                        paint.Style         := TSkPaintStyle.Stroke;
                        paint.Color         := TAlphaColors.Black;
                        paint.StrokeWidth   := 2;
                        canvasInOut.DrawPath(path, paint);

                    //fill
                        paint.Style         := TSkPaintStyle.Fill;
                        paint.Color         := colourIn;
                        canvasInOut.DrawPath(path, paint);
            end;

end.
