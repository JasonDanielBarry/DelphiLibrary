unit DrawingAxisConversionPanningClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeneralMathMethods,
        GeometryTypes,
        DrawingAxisConversionZoomingClass
        ;

    type
        TDrawingAxisPanningConverter = class(TDrawingAxisZoomingConverter)
            private

            protected
                //pan to correct position for 1:1 ratio
                    procedure panForConstantDrawingSpaceRatio(const tempDrawingRegionIn : TGeomBox); override;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //shift drawing region
                    procedure shiftDrawingDomain(const deltaXIn : double);
                    procedure shiftDrawingRange(const deltaYIn : double);
                    procedure shiftDrawingRegion(const deltaXIn, deltaYIn : double);
        end;

implementation

    //protected
        //pan to correct position for 1:1 ratio
            procedure TDrawingAxisPanningConverter.panForConstantDrawingSpaceRatio(const tempDrawingRegionIn : TGeomBox);
                var
                    deltaX, deltaY : double;
                begin
                    deltaX := tempDrawingRegionIn.minPoint.x - domainMin();
                    deltaY := tempDrawingRegionIn.minPoint.y - rangeMin();

                    shiftDrawingRegion(deltaX, deltaY);
                end;

    //public
        //constructor
            constructor TDrawingAxisPanningConverter.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TDrawingAxisPanningConverter.destroy();
                begin
                    inherited destroy();
                end;

        //shift drawing region
            procedure TDrawingAxisPanningConverter.shiftDrawingDomain(const deltaXIn : double);
                begin
                    drawingRegion.shiftX( deltaXIn );
                end;

            procedure TDrawingAxisPanningConverter.shiftDrawingRange(const deltaYIn : double);
                begin
                    drawingRegion.shiftY( deltaYIn );
                end;

            procedure TDrawingAxisPanningConverter.shiftDrawingRegion(const deltaXIn, deltaYIn : double);
                begin
                    drawingRegion.shiftBox(deltaXIn, deltaYIn);
                end;

end.
