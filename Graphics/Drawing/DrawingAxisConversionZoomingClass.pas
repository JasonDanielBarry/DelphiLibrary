unit DrawingAxisConversionZoomingClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeometryTypes,
        DrawingAxisConversionBaseClass
        ;

    type
        TDrawingAxisZoomingConverter = class(TDrawingAxisConverterBase)
            private
                var
                    zoomPercentage  : double;
                    drawingBoundary : TGeomBox;
                //helper methods
                    function calculateZoomScaleFactor() : double;
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
            protected
                //
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //modifiers
                    procedure setDrawingBoundary(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double);
                    procedure resetDrawingRegion();
                //zooming methods
                    procedure zoomIn(   const zoomPercentageIn : double;
                                        const zoomAboutPointIn : TGeomPoint ); overload;
                    procedure zoomIn(const zoomPercentageIn : double); overload;
                    procedure zoomOut(  const zoomPercentageIn : double;
                                        const zoomAboutPointIn : TGeomPoint ); overload;
                    procedure zoomOut(const zoomPercentageIn : double); overload;
        end;

implementation

    //private
        //helper methods
            function TDrawingAxisZoomingConverter.calculateZoomScaleFactor() : double;
                begin
                    result := 100 / zoomPercentage;
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
                    zoomScaleFactor : double;
                begin
                    zoomPercentage := zoomPercentage + zoomPercentageIn;

                    zoomScaleFactor := calculateZoomScaleFactor();

                    resetDrawingRegion();

                    rescaleRegion(zoomAboutXIn, zoomAboutYIn, zoomScaleFactor);
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

    //protected


    //public
        //constructor
            constructor TDrawingAxisZoomingConverter.create();
                begin
                    inherited create();

                    zoomPercentage := 100;

                    drawingBoundary.minPoint.z := 0;
                    drawingBoundary.maxPoint.z := 0;
                end;

        //destructor
            destructor TDrawingAxisZoomingConverter.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            procedure TDrawingAxisZoomingConverter.setDrawingBoundary(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double);
                begin
                    drawingBoundary.minPoint.x := domainMinIn;
                    drawingBoundary.minPoint.y := rangeMinIn;

                    drawingBoundary.maxPoint.x := domainMaxIn;
                    drawingBoundary.maxPoint.y := rangeMaxIn;
                end;

            procedure TDrawingAxisZoomingConverter.resetDrawingRegion();
                begin
                    setDrawingRegion(5, drawingBoundary);
                end;

        //zooming methods
            procedure TDrawingAxisZoomingConverter.zoomIn(  const zoomPercentageIn : double;
                                                            const zoomAboutPointIn : TGeomPoint );
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    zoom( zoomPercentageIn, zoomAboutPointIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomIn(const zoomPercentageIn : double);
                begin
                    if (zoomPercentageIn <= 0) then
                        exit();

                    zoom( zoomPercentageIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomOut( const zoomPercentageIn : double;
                                                            const zoomAboutPointIn : TGeomPoint );
                begin
                    if (0 <= zoomPercentageIn) then
                        exit();

                    zoom( -zoomPercentageIn, zoomAboutPointIn );
                end;

            procedure TDrawingAxisZoomingConverter.zoomOut(const zoomPercentageIn : double);
                begin
                    if (0 <= zoomPercentageIn) then
                        exit();

                    zoom( -zoomPercentageIn );
                end;

end.
