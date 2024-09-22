unit DrawingAxisConversionClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeometryTypes,
        DrawingAxisConversionBaseClass;

    type
        TDrawingAxisConverter = class(TDrawingAxisConverterBase)
            private
                //zooming methods
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //modifiers
                    //canvas boundaries
                        procedure setCanvasRegion(const heightIn, widthIn : integer);
                    //drawing space boundaries
                        procedure setDrawingRegion( const bufferIn : double;
                                                    const regionIn : TGeomBox );
                        procedure setDrawingSpaceRatio( const adjustByDomainIn    : boolean;
                                                        const ratioIn             : double    );
                        procedure setDrawingSpaceRatioOneToOne();
                //convertion calculations
                    //canvas-to-drawing
                        function LT_to_XY(const pointIn : TPointF) : TGeomPoint; overload;
                        function LT_to_XY(const pointIn : TPoint) : TGeomPoint; overload;
                        function arrLT_to_arrXY(const arrLT_In : TArray<TPointF>) : TArray<TGeomPoint>; overload;
                        function arrLT_to_arrXY(const arrLT_In : TArray<TPoint>) : TArray<TGeomPoint>; overload;
                    //drawing-to-canvas
                        //double versions
                            function XY_to_LTF(const pointIn : TGeomPoint) : TPointF;
                            function arrXY_to_arrLTF(const arrXY_In : TArray<TGeomPoint>) : TArray<TPointF>;
                        //integer versions
                            function XY_to_LT(const pointIn : TGeomPoint) : TPoint;
                            function arrXY_to_arrLT(const arrXY_In : TArray<TGeomPoint>) : TArray<TPoint>;
        end;

implementation

    //public
        //constructor
            constructor TDrawingAxisConverter.create();
                begin
                    inherited create();
                end;

        //destructor
            destructor TDrawingAxisConverter.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            //canvasSpace boundaries
                procedure TDrawingAxisConverter.setCanvasRegion(const heightIn, widthIn : integer);
                    begin
                        setCanvasHeight(heightIn);
                        setCanvasWidth(widthIn);
                    end;

            //drawingSpace space boundaries
                procedure TDrawingAxisConverter.setDrawingRegion(   const bufferIn : double;
                                                                    const regionIn : TGeomBox );
                    var
                        buffer,
                        regionInDomain, domainBuffer,
                        newDomainMin,   newDomainMax,
                        regionInRange,  rangeBuffer,
                        newRangeMin,    newRangeMax     : double;
                    begin
                        //set valid buffer
                            buffer := min(5, bufferIn);
                            buffer := max(buffer, 0);

                        //test buffer is valid
                            if (bufferIn < 0) then
                                exit();

                        //calculate the domain and range of regionIn
                            regionInDomain   := regionIn.maxPoint.x - regionIn.minPoint.x;
                            regionInRange    := regionIn.maxPoint.y - regionIn.minPoint.y;

                        //calculate the region buffers
                            domainBuffer := (bufferIn / 100) * regionInDomain;
                            rangeBuffer  := (bufferIn / 100) * regionInRange;

                        //calculate new mins and maxes
                            newDomainMin := regionIn.minPoint.x - domainBuffer / 2;
                            newDomainMax := regionIn.maxPoint.x + domainBuffer / 2;

                            newRangeMin := regionIn.minPoint.y - rangeBuffer  / 2;
                            newRangeMax := regionIn.maxPoint.y + rangeBuffer  / 2;

                        inherited setDrawingRegion(newDomainMin, newDomainMax, newRangeMin, newRangeMax);
                    end;

                procedure TDrawingAxisConverter.setDrawingSpaceRatio(   const adjustByDomainIn    : boolean;
                                                                        const ratioIn             : double    );
                    begin
                        //the ratio is defined as the value that satisfies: h/w = r(R/D)

                        //adjust-by-domain means that the domain remains constant and
                        //a new range is calculated to match the domain based on the input ratio

                        if (adjustByDomainIn) then
                            begin
                                var drawDomain, newRange, newRangeMin, rangeMiddle, newRangeMax : double;

                                drawDomain := calculateDrawingDomain();

                                //calculate new range: R = D(1/r)(h/w)
                                    newRange := (1 / ratioIn) * drawDomain * ( canvasHeight() / canvasWidth() );

                                //calculate the range middle
                                    rangeMiddle := calculateRangeCentre();

                                //calcualte the range top and bottom
                                    newRangeMin := rangeMiddle - newRange / 2;
                                    newRangeMax := rangeMiddle + newRange / 2;

                                setRange( newRangeMin, newRangeMax );
                            end
                        else
                            begin
                                var drawRange, newDomain, newDomainMin, domainMiddle, newDomainMax : double;

                                drawRange := calculateDrawingRange();

                                //calculate new domain: D = R(r)(w/h)
                                    newDomain := ratioIn * drawRange * ( canvasWidth() / canvasHeight() );

                                //calculate the domain middle
                                    domainMiddle := calculateDomainCentre();

                                //calculate the domain left and right
                                    newDomainMin := domainMiddle - newDomain / 2;
                                    newDomainMax := domainMiddle + newDomain / 2;

                                setDomain( newDomainMin, newDomainMax );
                            end;
                    end;

                procedure TDrawingAxisConverter.setDrawingSpaceRatioOneToOne();
                    var
                        adjustByDomain          : boolean;
                        domainRatio, rangeRatio : double;
                    begin
                        //if the domain/width ratio is larger you must size by the domain
                            domainRatio := ( calculateDrawingDomain() / canvasWidth() );

                        //if the range/height ratio is larger you must size by the range
                            rangeRatio := ( calculateDrawingRange() / canvasHeight() );

                            adjustByDomain := ( domainRatio > rangeRatio );

                        setDrawingSpaceRatio(adjustByDomain, 1)
                    end;

        //convertion calculations
            //canvasSpace-to-drawing
                function TDrawingAxisConverter.LT_to_XY(const pointIn : TPointF) : TGeomPoint;
                    begin
                        result := LT_to_XY(pointIn.X, pointIn.Y);
                    end;

                function TDrawingAxisConverter.LT_to_XY(const pointIn : TPoint) : TGeomPoint;
                    var
                        newPoint : TPointF;
                    begin
                        newPoint := TPointF.create(pointIn);

                        result := LT_to_XY(newPoint);
                    end;

                function TDrawingAxisConverter.arrLT_to_arrXY(const arrLT_In : TArray<TPointF>) : TArray<TGeomPoint>;
                    var
                        i, arrLen       : integer;
                        arrPointsOut    : TArray<TGeomPoint>;
                    begin
                        arrLen := length(arrLT_In);

                        SetLength(arrPointsOut, arrLen);

                        for i := 0 to (arrLen - 1) do
                            arrPointsOut[i] := LT_to_XY(arrLT_In[i]);

                        result := arrPointsOut;
                    end;

                function TDrawingAxisConverter.arrLT_to_arrXY(const arrLT_In : TArray<TPoint>) : TArray<TGeomPoint>;
                    var
                        i               : integer;
                        arrPointF       : TArray<TPointF>;
                    begin
                        SetLength(arrPointF, length(arrLT_In));

                        for i := 0 to (length(arrPointF) - 1) do
                            arrPointF[i] := TPointF.create(arrLT_In[i]);

                        result := arrLT_to_arrXY(arrPointF);
                    end;

            //drawing-to-canvas
                //double verions
                    function TDrawingAxisConverter.XY_to_LTF(const pointIn : TGeomPoint) : TPointF;
                        begin
                            result := inherited XY_to_LTF(pointIn.x, pointIn.y);
                        end;

                    function TDrawingAxisConverter.arrXY_to_arrLTF(const arrXY_In : TArray<TGeomPoint>) : TArray<TPointF>;
                        var
                            i, arrLen       : integer;
                            arrPointsOut    : TArray<TPointF>;
                        begin
                            arrLen := length(arrXY_In);

                            SetLength(arrPointsOut, arrLen);

                            for i := 0 to (arrLen - 1) do
                                arrPointsOut[i] := XY_to_LTF(arrXY_In[i]);

                            result := arrPointsOut;
                        end;

                //integer versions
                    function TDrawingAxisConverter.XY_to_LT(const pointIn : TGeomPoint) : TPoint;
                        begin
                            result := inherited XY_to_LT( pointIn.x, pointIn.y );
                        end;

                    function TDrawingAxisConverter.arrXY_to_arrLT(const arrXY_In : TArray<TGeomPoint>) : TArray<TPoint>;
                        var
                            i, x_Int, y_Int : integer;
                            arrPointF       : TArray<TPointF>;
                            arrPointsOut    : TArray<TPoint>;
                        begin
                            arrPointF := arrXY_to_arrLTF(arrXY_In);

                            SetLength(arrPointsOut, length(arrPointF));

                            for i := 0 to (length(arrPointsOut) - 1) do
                                begin
                                    x_Int := round(arrPointF[i].X);
                                    y_Int := round(arrPointF[i].Y);

                                    arrPointsOut[i] := point(x_Int, y_Int);
                                end;

                            result := arrPointsOut;
                        end;

end.
