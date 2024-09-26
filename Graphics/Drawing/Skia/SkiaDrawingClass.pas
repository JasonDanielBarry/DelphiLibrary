unit SkiaDrawingClass;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes,
            System.Skia, Vcl.Skia,
        //custom
            DrawingAxisConversionClass,
            GeometryTypes, GeometryDrawingTypes,
            GeometryBaseClass,
            GeomLineClass, GeomPolyLineClass,
            SkiaDrawingMethods;

    type
        TSkiaGeomDrawer = class
            private
                var
                    arrDrawingGeom      : TArray<TGeomDrawingObject>;
                    skiaDrawingCanvas   : ISkCanvas;
                    axisConverter       : TDrawingAxisConverter;
                function getArrGeom() : TArray<TGeomBase>;
            public
                constructor create();
                destructor destroy(); override;
                function determineGeomBoundingBox() : TGeomBox;
                procedure setDrawingCanvas(const canvasIn : ISkCanvas);
                procedure setAxisConverter(const axisConverterIn : TDrawingAxisConverter);
        end;

implementation



end.
