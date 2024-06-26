unit SkiaDrawingMethods;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes,
            System.Skia, Vcl.Skia,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes, GeomLineClass, GeomPolyLineClass;

    //draw line
        procedure drawSkiaLine( const lineIn            : TGeomLine;
                                const colourIn          : TAlphaColor;
                                const axisConverterIn   : TDrawingAxisConverter;
                                var canvasInOut         : ISkCanvas;
                                const freeLineIn        : boolean = True;
                                const lineThicknessIn   : integer = 2           );

    //draw polyline
        procedure drawSkiaPolygon(  const polylineIn        : TGeomPolyLine;
                                    const colourIn          : TAlphaColor;
                                    const axisConverterIn   : TDrawingAxisConverter;
                                    var canvasInOut         : ISkCanvas;
                                    const freePolyLineIn    : boolean = True;
                                    const lineThicknessIn   : integer = 2           );

implementation

    //draw line
        procedure drawSkiaLine( const lineIn            : TGeomLine;
                                const colourIn          : TAlphaColor;
                                const axisConverterIn   : TDrawingAxisConverter;
                                var canvasInOut         : ISkCanvas;
                                const freeLineIn        : boolean = True;
                                const lineThicknessIn   : integer = 2           );
            var
                drawingPoints   : TArray<TPointF>;
                pathbuilder     : ISkPathBuilder;
                path            : ISkPath;
                paint           : ISkPaint;
            begin
                //convert geometry into canvas drawing points
                    drawingPoints := axisConverterIn.arrXY_to_arrLTF(
                                                                        lineIn.drawingPoints()
                                                                    );

                //define the drawing path
                    pathbuilder := TSkPathBuilder.Create();

                    pathbuilder.MoveTo(drawingPoints[0]);
                    pathbuilder.LineTo(drawingPoints[1]);

                    path := pathbuilder.Detach();

                //draw the shape
                    paint := TSkPaint.create();
                    paint.AntiAlias := True;

                    paint.Style         := TSkPaintStyle.Stroke;
                    paint.Color         := colourIn;
                    paint.StrokeWidth   := lineThicknessIn;

                    canvasInOut.DrawPath(path, paint);

                if (freeLineIn) then
                    FreeAndNil(lineIn);
            end;

    //draw polyline
        procedure drawSkiaPolygon(  const polylineIn        : TGeomPolyLine;
                                    const colourIn          : TAlphaColor;
                                    const axisConverterIn   : TDrawingAxisConverter;
                                    var canvasInOut         : ISkCanvas;
                                    const freePolyLineIn    : boolean = True;
                                    const lineThicknessIn   : integer = 2           );
            var
                drawingPoints   : TArray<TPointF>;
                pathbuilder     : ISkPathBuilder;
                path            : ISkPath;
                paint           : ISkPaint;
            begin
                if (polylineIn.vertexCount() > 1) then //only draw if there is more than one vertix
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
                            paint.AntiAlias := True;

                            //line
                                paint.Style         := TSkPaintStyle.Stroke;
                                paint.Color         := TAlphaColors.Black;
                                paint.StrokeWidth   := lineThicknessIn;
                                canvasInOut.DrawPath(path, paint);

                            //fill
                                paint.Style         := TSkPaintStyle.Fill;
                                paint.Color         := colourIn;
                                canvasInOut.DrawPath(path, paint);
                    end;

                if (freePolyLineIn) then
                    FreeAndNil(polylineIn);
            end;

end.
