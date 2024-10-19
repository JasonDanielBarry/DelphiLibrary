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
                    currentZoomPercentage : double;
                //helper methods
                    function calculateZoomScaleFactor(const newZoomPercentage : double) : double;
                    function calculateCurrentZoomPercentage() : double;
                //rescaling methods
                    function rescaleRegionDimension(const   currentRegionDimensionIn,
                                                            currentRegionDimensionMinIn,    currentRegionDimensionMaxIn,
                                                            scaleFactorIn,                  scaleAboutValueIn           : double) : TArray<double>;
                    procedure rescaleDomain(const scaleAboutXIn, scaleFactorIn : double);
                    procedure rescaleRange(const scaleAboutYIn, scaleFactorIn : double);
                    procedure rescaleRegion(const scaleAboutXIn, scaleAboutYIn, scaleFactorIn : double);
                //zooming by percent
                    procedure zoom(const zoomAboutXIn, zoomAboutYIn, newZoomPercentageIn : double); overload;
                    procedure zoom( const newZoomPercentageIn   : double;
                                    const zoomAboutPointIn      : TGeomPoint ); overload;
                    procedure zoom(const newZoomPercentageIn : double); overload;

            protected
                var
                    geometryBoundary : TGeomBox; //the drawing boundary stores a geometry group's boundary
                //helper methods
                    function calculateBoundaryDomain() : double;
                    function calculateBoundaryRange() : double;
                //zoom for drawing space ratio
                    procedure zoomForConstantDrawingSpaceRatio(); override;
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

            function TDrawingAxisZoomingConverter.calculateCurrentZoomPercentage() : double;
                var
                    domainZoomPercentage, rangeZoomPercentage : double;
                begin
                    //zoom is the ratio of the geometry boundary to the drawing region
                    //105 is for the 5% buffer on the drawing region when reset using the geometry boundary
                        domainZoomPercentage    := 105 * calculateBoundaryDomain() / calculateRegionDomain();
                        rangeZoomPercentage     := 105 * calculateBoundaryRange() / calculateRegionRange();

                    result := max(domainZoomPercentage, rangeZoomPercentage);
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
                        currentDomain       := calculateRegionDomain();
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
                        currentRange       := calculateRegionRange();
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
            procedure TDrawingAxisZoomingConverter.zoom(const zoomAboutXIn, zoomAboutYIn, newZoomPercentageIn : double);
                var
                    zoomScaleFactor : double;
                begin
                    //calculate the new zoom percentage
                        if ( newZoomPercentageIn < 1e-3) then
                            exit();

//                        resetDrawingRegionToDrawingBoundary();

                    //zoom to the desired factor about the specified point
                        //get the zoom factor
                            zoomScaleFactor := calculateZoomScaleFactor( newZoomPercentageIn );

                        rescaleRegion(zoomAboutXIn, zoomAboutYIn, zoomScaleFactor);

                    //set currentZoomPercentage to the correct value
                        currentZoomPercentage := calculateCurrentZoomPercentage();
                end;

            procedure TDrawingAxisZoomingConverter.zoom(const newZoomPercentageIn   : double;
                                                        const zoomAboutPointIn      : TGeomPoint);
                begin
                    zoom(zoomAboutPointIn.X, zoomAboutPointIn.y, newZoomPercentageIn);
                end;

            procedure TDrawingAxisZoomingConverter.zoom(const newZoomPercentageIn : double);
                var
                    regionDomainCentre, regionRangeCentre : double;
                begin
                    regionDomainCentre  := calculateDomainCentre();
                    regionRangeCentre   := calculateRangeCentre();

                    zoom( regionDomainCentre, regionRangeCentre, newZoomPercentageIn );
                end;

    //protected
        //zoom for drawing space ratio
            procedure TDrawingAxisZoomingConverter.zoomForConstantDrawingSpaceRatio();
                begin
                    setZoom( currentZoomPercentage );
                end;

        //helper methods
            function TDrawingAxisZoomingConverter.calculateBoundaryDomain() : double;
                begin
                    result := geometryBoundary.maxPoint.x - geometryBoundary.minPoint.x
                end;

            function TDrawingAxisZoomingConverter.calculateBoundaryRange() : double;
                begin
                    result := geometryBoundary.maxPoint.y - geometryBoundary.minPoint.y
                end;

    //public
        //constructor
            constructor TDrawingAxisZoomingConverter.create();
                begin
                    inherited create();

                    currentZoomPercentage := 100;

                    geometryBoundary.minPoint.setPoint( 0, 0, 0 );
                    geometryBoundary.maxPoint.setPoint( 0, 0, 0 );
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
                    geometryBoundary.minPoint.x := domainMinIn;
                    geometryBoundary.minPoint.y := rangeMinIn;
                    geometryBoundary.minPoint.z := 0;

                    geometryBoundary.maxPoint.x := domainMaxIn;
                    geometryBoundary.maxPoint.y := rangeMaxIn;
                    geometryBoundary.maxPoint.z := 0;
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
                    setDrawingRegion(5, geometryBoundary);

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
