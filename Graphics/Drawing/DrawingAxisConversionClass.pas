unit DrawingAxisConversionClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        DrawingTypes,
        GeometryTypes;

    type
        TDrawingAxisConverter = class
            private
                canvasSpace  : TRect;
                drawingSpace : TGeomBox;
                //helper methods
                    function drawingDomain() : double;
                    function drawingRange() : double;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //modifiers
                    //canvas boundaries
                        procedure setCanvasHeight(heightIn : integer);
                        procedure setCanvasWidth(widthIn : integer);
                        procedure setCanvasRegion(heightIn, widthIn : integer);
                    //drawing space boundaries
                        //x bounds
                            procedure setXMin(xMinIn : double);
                            procedure setXMax(xMaxIn : double);
                            procedure setDomain(xMinIn, xMaxIn : double);
                        //y bounds
                            procedure setYMin(yMinIn : double);
                            procedure setYMax(yMaxIn : double);
                            procedure setRange(yMinIn, yMaxIn : double);
                        procedure setDrawingRegion(xMinIn, xMaxIn, yMinIn, yMaxIn : double); overload;
                        procedure setDrawingRegion( bufferIn : double;
                                                    regionIn : TGeomBox ); overload;
                        procedure setDrawingSpaceRatio( adjustByDomainIn    : boolean;
                                                        ratioIn             : double    );
                        procedure setDrawingSpaceRatioOneToOne();
                //convertion calculations
                    //canvas-to-drawing
                        function L_to_X(L_In : double) : double;
                        function T_to_Y(T_In : double) : double;
                        function LT_to_XY(L_In, T_In : double) : TGeomPoint; overload;
                        function LT_to_XY(pointIn : TPointF) : TGeomPoint; overload;
                        function LT_to_XY(pointIn : TPoint) : TGeomPoint; overload;
                        function arrLT_to_arrXY(arrLT_In : TArray<TPointF>) : TArray<TGeomPoint>; overload;
                        function arrLT_to_arrXY(arrLT_In : TArray<TPoint>) : TArray<TGeomPoint>; overload;
                    //drawing-to-canvas
                        //double versions
                            function X_to_L(X_In : double) : double;
                            function Y_to_T(Y_In : double) : double;
                            function XY_to_LTF(X_In, Y_In : double) : TPointF; overload;
                            function XY_to_LTF(pointIn : TGeomPoint) : TPointF; overload;
                            function arrXY_to_arrLTF(arrXY_In : TArray<TGeomPoint>) : TArray<TPointF>;
                        //integer versions
                            function XY_to_LT(X_In, Y_In : double) : TPoint; overload;
                            function XY_to_LT(pointIn : TGeomPoint) : TPoint; overload;
                            function arrXY_to_arrLT(arrXY_In : TArray<TGeomPoint>) : TArray<TPoint>;
        end;

implementation

    //private
        //helper methods
            function TDrawingAxisConverter.drawingDomain() : double;
                begin
                    result := drawingSpace.maxPoint.x - drawingSpace.minPoint.x;
                end;

            function TDrawingAxisConverter.drawingRange() : double;
                begin
                    result := drawingSpace.maxPoint.y - drawingSpace.minPoint.y;
                end;

    //public
        //constructor
            constructor TDrawingAxisConverter.create();
                begin
                    inherited create();

                    canvasSpace.Left := 0;
                    canvasSpace.Top  := 0;

                    drawingSpace.minPoint.z := 0;
                    drawingSpace.maxPoint.z := 0;
                end;

        //destructor
            destructor TDrawingAxisConverter.destroy();
                begin
                    inherited destroy();
                end;

        //modifiers
            //canvasSpace boundaries
                procedure TDrawingAxisConverter.setCanvasHeight(heightIn : integer);
                    begin
                        canvasSpace.height := heightIn;
                    end;

                procedure TDrawingAxisConverter.setCanvasWidth(widthIn : integer);
                    begin
                        canvasSpace.width := widthIn;
                    end;

                procedure TDrawingAxisConverter.setCanvasRegion(heightIn, widthIn : integer);
                    begin
                        setCanvasHeight(heightIn);
                        setCanvasWidth(widthIn);
                    end;

            //drawingSpace space boundaries
                //x bounds
                    procedure TDrawingAxisConverter.setXMin(xMinIn : double);
                        begin
                            drawingSpace.minPoint.x := xMinIn;
                        end;

                    procedure TDrawingAxisConverter.setXMax(xMaxIn : double);
                        begin
                            drawingSpace.maxPoint.x := xMaxIn;
                        end;

                    procedure TDrawingAxisConverter.setDomain(xMinIn, xMaxIn : double);
                        begin
                            setXMin(xMinIn);
                            setXMax(xMaxIn);
                        end;

                //y bounds
                    procedure TDrawingAxisConverter.setYMin(yMinIn : double);
                        begin
                            drawingSpace.minPoint.y := yMinIn;
                        end;

                    procedure TDrawingAxisConverter.setYMax(yMaxIn : double);
                        begin
                            drawingSpace.maxPoint.y := yMaxIn;
                        end;

                    procedure TDrawingAxisConverter.setRange(yMinIn, yMaxIn : double);
                        begin
                            setYMin(yMinIn);
                            setYMax(yMaxIn);
                        end;

                procedure TDrawingAxisConverter.setDrawingRegion(xMinIn, xMaxIn, yMinIn, yMaxIn : double);
                    begin
                        setDomain(xMinIn, xMaxIn);
                        setRange(yMinIn, yMaxIn);
                    end;

                procedure TDrawingAxisConverter.setDrawingRegion(   bufferIn : double;
                                                                    regionIn : TGeomBox );
                    var
                        newDomain,      newRange,
                        domainBuffer,   rangeBuffer : double;
                    begin
                        //set valid buffer
                            bufferIn := min(5, bufferIn);
                            bufferIn := max(bufferIn, 0);

                        if (bufferIn > 0) then
                            begin
                                //calculate new domain and range
                                    newDomain   := regionIn.maxPoint.x - regionIn.minPoint.x;
                                    newRange    := regionIn.maxPoint.y - regionIn.minPoint.y;

                                //calculate the region buffers
                                    domainBuffer := (bufferIn / 100) * newDomain;
                                    rangeBuffer  := (bufferIn / 100) * newRange;

                                setDrawingRegion(   regionIn.minPoint.x - domainBuffer / 2, regionIn.maxPoint.x + domainBuffer / 2,
                                                    regionIn.minPoint.y - rangeBuffer  / 2, regionIn.maxPoint.y + rangeBuffer  / 2   );
                            end;
                    end;

                procedure TDrawingAxisConverter.setDrawingSpaceRatio(   adjustByDomainIn    : boolean;
                                                                        ratioIn             : double    );
                    begin
                        //the ratio is defined as the value that satisfies: h/w = r(R/D)

                        //adjust-by-domain means that the domain remains constant and a new range is calculated to match the domain based on the input ratio

                        if (adjustByDomainIn) then
                            begin
                                var newRange, rangeMiddle : double;

                                //calculate new range: R = D(1/r)(h/w)
                                    newRange := (1 / ratioIn) * drawingDomain() * (canvasSpace.height / canvasSpace.width);

                                //find the range middle
                                    rangeMiddle := (drawingSpace.minPoint.y + drawingSpace.maxPoint.y) / 2;

                                setRange(rangeMiddle - newRange / 2, rangeMiddle + newRange / 2);
                            end
                        else
                            begin
                                var newDomain, domainMiddle : double;

                                //calculate new domain: D = R(r)(w/h)
                                    newDomain := ratioIn * drawingRange() * (canvasSpace.width / canvasSpace.height);

                                //find the domain middle
                                    domainMiddle := (drawingSpace.minPoint.x + drawingSpace.maxPoint.x) / 2;

                                setDomain(domainMiddle - newDomain / 2, domainMiddle + newDomain / 2);
                            end;
                    end;

                procedure TDrawingAxisConverter.setDrawingSpaceRatioOneToOne();
                    var
                        adjustByDomain : boolean;
                    begin
                        //if the domain/width ratio is larger you must size by the domain
                        //if the range/height ratio is larger you must size by the range

                            adjustByDomain := (drawingDomain() / canvasSpace.width) > (drawingRange() / canvasSpace.height);

                        setDrawingSpaceRatio(adjustByDomain, 1)
                    end;

        //convertion calculations
            //canvasSpace-to-drawing
                function TDrawingAxisConverter.L_to_X(L_In : double) : double;
                    begin
                        //x(l) = (D/w)l + xmin

                        result := ((drawingDomain() / canvasSpace.width) * L_In) + drawingSpace.minPoint.x;
                    end;

                function TDrawingAxisConverter.T_to_Y(T_In : double) : double;
                    begin
                        //y(t) = -(R/h)t + ymax

                        result := -((drawingRange() / canvasSpace.height) * T_In) + drawingSpace.maxPoint.y;
                    end;

                function TDrawingAxisConverter.LT_to_XY(L_In, T_In : double) : TGeomPoint;
                    var
                        pointOut : TGeomPoint;
                    begin
                        pointOut.x := L_to_X(L_In);
                        pointOut.y := T_to_Y(T_In);

                        result := pointOut;
                    end;

                function TDrawingAxisConverter.LT_to_XY(pointIn : TPointF) : TGeomPoint;
                    begin
                        result := LT_to_XY(pointIn.X, pointIn.Y);
                    end;

                function TDrawingAxisConverter.LT_to_XY(pointIn : TPoint) : TGeomPoint;
                    var
                        newPoint : TPointF;
                    begin
                        newPoint := TPointF.create(pointIn);

                        result := LT_to_XY(newPoint);
                    end;

                function TDrawingAxisConverter.arrLT_to_arrXY(arrLT_In : TArray<TPointF>) : TArray<TGeomPoint>;
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

                function TDrawingAxisConverter.arrLT_to_arrXY(arrLT_In : TArray<TPoint>) : TArray<TGeomPoint>;
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
                    function TDrawingAxisConverter.X_to_L(X_In : double) : double;
                        var
                            deltaX : double;
                        begin
                            //l(x) = (w/D)(x - xmin)

                            deltaX := X_In - drawingSpace.minPoint.x;

                            result := round( (canvasSpace.width / drawingDomain()) * deltaX );
                        end;

                    function TDrawingAxisConverter.Y_to_T(Y_In : double) : double;
                        var
                            deltaY : double;
                        begin
                            //t(y) = (h/R)(ymax - y)

                            deltaY := drawingSpace.maxPoint.y - Y_In;

                            result := round( (canvasSpace.height / drawingRange()) * deltaY );
                        end;

                    function TDrawingAxisConverter.XY_to_LTF(X_In, Y_In : double) : TPointF;
                        var
                            pointOut : TPointF;
                        begin
                            pointOut.x := X_to_L(X_In);
                            pointOut.y := Y_to_T(Y_In);

                            result := pointOut;
                        end;

                    function TDrawingAxisConverter.XY_to_LTF(pointIn : TGeomPoint) : TPointF;
                        begin
                            result := XY_to_LTF(pointIn.x, pointIn.y);
                        end;

                    function TDrawingAxisConverter.arrXY_to_arrLTF(arrXY_In : TArray<TGeomPoint>) : TArray<TPointF>;
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
                    function TDrawingAxisConverter.XY_to_LT(X_In, Y_In : double) : TPoint;
                        var
                            pointF : TPointF;
                        begin
                            pointF := XY_to_LTF(X_In, Y_In);

                            result := point(round(pointF.X), round(pointF.Y))
                        end;

                    function TDrawingAxisConverter.XY_to_LT(pointIn : TGeomPoint) : TPoint;
                        begin
                            result := XY_to_LT(pointIn.x, pointIn.y);
                        end;

                    function TDrawingAxisConverter.arrXY_to_arrLT(arrXY_In : TArray<TGeomPoint>) : TArray<TPoint>;
                        var
                            i               : integer;
                            arrPointF       : TArray<TPointF>;
                            arrPointsOut    : TArray<TPoint>;
                        begin
                            arrPointF := arrXY_to_arrLTF(arrXY_In);

                            SetLength(arrPointsOut, length(arrPointF));

                            for i := 0 to (length(arrPointsOut) - 1) do
                                arrPointsOut[i] := point(round(arrPointF[i].X), round(arrPointF[i].Y));

                            result := arrPointsOut;
                        end;

end.
