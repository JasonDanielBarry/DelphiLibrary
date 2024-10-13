unit DrawingAxisConversionZoomingClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeneralMathMethods,
        GeometryTypes,
        DrawingAxisConversionBaseClass
        ;

    type
        TDrawingAxisZoomingConverter = class(TDrawingAxisConverterBase)
            private
                var
                    currentZoomPercentage   : double;
                    drawingBoundary         : TGeomBox; //the drawing boundary stores a geometry group's boundary
                //helper methods
                    function calculateZoomScaleFactor(const newZoomPercentage : double) : double;
                //rescaling methods
                    function rescaleRegionDimension(const   currentRegionDimensionIn,
                                                            currentRegionDimensionMinIn,    currentRegionDimensionMaxIn,
                                                            scaleFactorIn,                  scaleAboutValueIn           : double) : TArray<double>;
                    procedure rescaleDomain(const scaleAboutXIn, scaleFactorIn : double);
                    procedure rescaleRange(const scaleAboutYIn, scaleFactorIn : double);
                    procedure rescaleRegion(const scaleAboutXIn, scaleAboutYIn, scaleFactorIn : double);
                //zooming by percent
                    procedure zoom(const zoomAboutXIn, zoomAboutYIn, zoomPercentageIn : double); overload;
                    procedure zoom( const zoomPercentageIn : double;
                                    const zoomAboutPointIn : TGeomPoint ); overload;
                    procedure zoom(const zoomPercentageIn : double); overload;
                    procedure zoomForConstantDrawingSpaceRatio(); override;
            protected
                //
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //accessors
                    function getCurrentZoomPercentage() : double;
                //modifiers
                    procedure setDrawingBoundary(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double); overload;
                    procedure setDrawingBoundary(const boundaryBoxIn : TGeomBox); overload;
                    procedure resetDrawingRegionToDrawingBoundary();
                //zooming methods
                    procedure zoomIn(   const zoomPercentageIn : double;
                                        const zoomAboutPointIn : TGeomPoint ); overload;
                    procedure zoomIn(const zoomPercentageIn : double); overload;
                    procedure zoomOut(  const zoomPercentageIn : double;
                                        const zoomAboutPointIn : TGeomPoint ); overload;
                    procedure zoomOut(const zoomPercentageIn : double); overload;
                    procedure setZoom(const zoomPercentageIn : double);
        end;

implementation

    //private
        //helper methods
            function TDrawingAxisZoomingConverter.calculateZoomScaleFactor(const newZoomPercentage : double) : double;
                begin
                    //the scale factor is used to size the domain and range
                    // < 1 the region shrinks which zooms in the drawing
                    // > 1 the region grows which zooms out the drawing

                    result := currentZoomPercentage / newZoomPercentage;
                end;

        //rescaling methods
            function TDrawingAxisZoomingConverter.rescaleRegionDimension(const  currentRegionDimensionIn,
                                                                                currentRegionDimensionMinIn,    currentRegionDimensionMaxIn,
                                                                                scaleFactorIn,                  scaleAboutValueIn           : double) : TArray<double>;
                var
                    newRegionDimension,
                    newRegionDimensionMin,
                    newRegionDimensionMax,
                    RegionDimensionDifference,
                    minToAbout, minToAboutRatio, regionDimensionMinShift,
                    aboutToMax, aboutToMaxRatio, RegionDimensionMaxShift : double;
                begin
                    //calculate the new domain
                        newRegionDimension := currentRegionDimensionIn * scaleFactorIn;

                    //calculate the difference between the new and current domains (sign is important)
                        RegionDimensionDifference := newRegionDimension - currentRegionDimensionIn;

                    //calculate lengths to the left and right of the scaleAboutX value
                        minToAbout := scaleAboutValueIn - currentRegionDimensionMinIn;
                        aboutToMax := currentRegionDimensionMaxIn - scaleAboutValueIn;

                    //calculate the ratio between the about length and the current domain
                        minToAboutRatio := minToAbout / currentRegionDimensionIn;
                        aboutToMaxRatio := aboutToMax / currentRegionDimensionIn;

                    //calculate the max and min shift
                        regionDimensionMinShift := (RegionDimensionDifference * minToAboutRatio);
                        RegionDimensionMaxShift := (RegionDimensionDifference * aboutToMaxRatio);

                    //calculate the new domain min and max
                        newRegionDimensionMin := currentRegionDimensionMinIn - regionDimensionMinShift;
                        newRegionDimensionMax := currentRegionDimensionMaxIn + RegionDimensionMaxShift;

                    result := [newRegionDimensionMin, newRegionDimensionMax];
                end;

            procedure TDrawingAxisZoomingConverter.rescaleDomain(const scaleAboutXIn, scaleFactorIn : double);
                var
                    currentDomain,
                    currentDomainMin,   currentDomainMax,
                    newDomainMin,       newDomainMax    : double;
                    domainMinAndMax                     : TArray<double>;
                begin
                    //get current info
                        currentDomain       := calculateDrawingDomain();
                        currentDomainMin    := domainMin();
                        currentDomainMax    := domainMax();

                    //calculate new domain min and max
                        domainMinAndMax := rescaleRegionDimension(
                                                                    currentDomain,
                                                                    currentDomainMin,
                                                                    currentDomainMax,
                                                                    scaleFactorIn,
                                                                    scaleAboutXIn
                                                                 );

                        newDomainMin := domainMinAndMax[0];
                        newDomainMax := domainMinAndMax[1];

                    setDomain( newDomainMin, newDomainMax );
                end;

            procedure TDrawingAxisZoomingConverter.rescaleRange(const scaleAboutYIn, scaleFactorIn : double);
                var
                    currentRange,
                    currentRangeMin,    currentRangeMax,
                    newRangeMin,        newRangeMax     : double;
                    rangeMinAndMax                      : TArray<double>;
                begin
                    //get current info
                        currentRange       := calculateDrawingRange();
                        currentRangeMin    := rangeMin();
                        currentRangeMax    := rangeMax();

                    //calculate new range min and max
                        rangeMinAndMax := rescaleRegionDimension(
                                                                    currentRange,
                                                                    currentRangeMin,
                                                                    currentRangeMax,
                                                                    scaleFactorIn,
                                                                    scaleAboutYIn
                                                                );

                        newRangeMin := rangeMinAndMax[0];
                        newRangeMax := rangeMinAndMax[1];

                    setRange( newRangeMin, newRangeMax );
                end;

            procedure TDrawingAxisZoomingConverter.rescaleRegion(const scaleAboutXIn, scaleAboutYIn, scaleFactorIn : double);
                begin
                    rescaleDomain( scaleAboutXIn, scaleFactorIn );
                    rescaleRange( scaleAboutYIn, scaleFactorIn );
                end;

        //zooming by percent
            procedure TDrawingAxisZoomingConverter.zoom(const zoomAboutXIn, zoomAboutYIn, zoomPercentageIn : double);
                var
                    newZoomPercentage,
                    zoomScaleFactor     : double;
                begin
                    //calculate the new zoom percentage
                        newZoomPercentage := zoomPercentageIn;

                        if ( newZoomPercentage < 1e-3) then
                            exit();

                        resetDrawingRegionToDrawingBoundary();

                    //zoom to the desired factor about the specified point
                        //get the zoom factor
                            zoomScaleFactor := calculateZoomScaleFactor( newZoomPercentage );

                        rescaleRegion(zoomAboutXIn, zoomAboutYIn, zoomScaleFactor);

                    //set currentZoomPercentage to the correct value
                        currentZoomPercentage := newZoomPercentage;
                end;

            procedure TDrawingAxisZoomingConverter.zoom(const zoomPercentageIn : double;
                                                        const zoomAboutPointIn : TGeomPoint);
                begin
                    zoom(zoomAboutPointIn.X, zoomAboutPointIn.y, zoomPercentageIn);
                end;

            procedure TDrawingAxisZoomingConverter.zoom(const zoomPercentageIn : double);
                var
                    domainCentre, rangeCentre : double;
                begin
                    domainCentre    := calculateDomainCentre();
                    rangeCentre     := calculateRangeCentre();

                    zoom( domainCentre, rangeCentre, zoomPercentageIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomForConstantDrawingSpaceRatio();
                begin
                    setZoom( currentZoomPercentage );
                end;

    //protected

    //public
        //constructor
            constructor TDrawingAxisZoomingConverter.create();
                begin
                    inherited create();

                    currentZoomPercentage := 100;

                    drawingBoundary.minPoint.z := 0;
                    drawingBoundary.maxPoint.z := 0;
                end;

        //destructor
            destructor TDrawingAxisZoomingConverter.destroy();
                begin
                    inherited destroy();
                end;

        //accessors
            function TDrawingAxisZoomingConverter.getCurrentZoomPercentage() : double;
                begin
                    result := currentZoomPercentage;
                end;

        //modifiers
            procedure TDrawingAxisZoomingConverter.setDrawingBoundary(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double);
                begin
                    drawingBoundary.minPoint.x := domainMinIn;
                    drawingBoundary.minPoint.y := rangeMinIn;
                    drawingBoundary.minPoint.z := 0;

                    drawingBoundary.maxPoint.x := domainMaxIn;
                    drawingBoundary.maxPoint.y := rangeMaxIn;
                    drawingBoundary.maxPoint.z := 0;
                end;

            procedure TDrawingAxisZoomingConverter.setDrawingBoundary(const boundaryBoxIn : TGeomBox);
                begin
                    setDrawingBoundary(
                                            boundaryBoxIn.minPoint.x,
                                            boundaryBoxIn.maxPoint.x,
                                            boundaryBoxIn.minPoint.y,
                                            boundaryBoxIn.maxPoint.y
                                      );
                end;

            procedure TDrawingAxisZoomingConverter.resetDrawingRegionToDrawingBoundary();
                begin
                    setDrawingRegion(5, drawingBoundary);

                    currentZoomPercentage := 100;
                end;

        //zooming methods
            procedure TDrawingAxisZoomingConverter.zoomIn(  const zoomPercentageIn : double;
                                                            const zoomAboutPointIn : TGeomPoint );
                var
                    newZoomPercentage : double;
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    newZoomPercentage := currentZoomPercentage * (1 + zoomPercentageIn / 100);

                    zoom( newZoomPercentage, zoomAboutPointIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomIn(const zoomPercentageIn : double);
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    zoomIn(
                                zoomPercentageIn,
                                TGeomPoint.create( calculateDomainCentre(), calculateRangeCentre() )
                          );
                end;

            procedure TDrawingAxisZoomingConverter.zoomOut( const zoomPercentageIn : double;
                                                            const zoomAboutPointIn : TGeomPoint );
                var
                    newZoomPercentage : double;
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    newZoomPercentage := currentZoomPercentage / (1 + zoomPercentageIn / 100);

                    zoom( newZoomPercentage, zoomAboutPointIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomOut(const zoomPercentageIn : double);
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    zoomOut(
                                zoomPercentageIn,
                                TGeomPoint.create( calculateDomainCentre(), calculateRangeCentre() )
                           );
                end;

            procedure TDrawingAxisZoomingConverter.setZoom(const zoomPercentageIn : double);
                var
                    requiredZoomAmount : double;
                begin
                    if (zoomPercentageIn < 1e-3) then
                        exit();

                    requiredZoomAmount := zoomPercentageIn;

                    zoom( requiredZoomAmount );
                end;

end.
