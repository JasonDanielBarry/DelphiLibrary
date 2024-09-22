unit DrawingAxisConversionBaseClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeometryTypes;

    type
        TDrawingAxisConverterBase = class
            private
                var
                    canvasSpace  : TRect;
                    drawingSpace : TGeomBox;
                //modifiers
                    //drawing space boundaries
                        //x bounds
                            procedure setDomainMin(const domainMinIn : double);
                            procedure setDomainMax(const domainMaxIn : double);
                        //y bounds
                            procedure setRangeMin(const rangeMinIn : double);
                            procedure setRangeMax(const rangeMaxIn : double);
                //convertion calculations
                    //canvas-to-drawing
                        function L_to_X(const L_In : double) : double;
                        function T_to_Y(const T_In : double) : double;
                    //drawing-to-canvas
                        function X_to_L(const X_In : double) : double;
                        function Y_to_T(const Y_In : double) : double;
            protected
                //helper methods
                    //canvas
                        function canvasHeight() : integer;
                        function canvasWidth() : integer;
                    //domain
                        function domainMin() : double;
                        function domainMax() : double;
                        function calculateDrawingDomain() : double;
                        function calculateDomainCentre() : double;
                    //range
                        function rangeMin() : double;
                        function rangeMax() : double;
                        function calculateDrawingRange() : double;
                        function calculateRangeCentre() : double;
                //modifiers
                    //canvas boundaries
                        procedure setCanvasHeight(const heightIn : integer);
                        procedure setCanvasWidth(const widthIn : integer);
                    //drawing space boundaries
                        procedure setDomain(const domainMinIn, domainMaxIn : double);
                        procedure setRange(const rangeMinIn, rangeMaxIn : double);
                        procedure setDrawingRegion(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double);
                //convertion calculations
                    //canvas-to-drawing
                        function LT_to_XY(const L_In, T_In : double) : TGeomPoint;
                    //drawing-to-canvas
                        function XY_to_LTF(const X_In, Y_In : double) : TPointF;
                        function XY_to_LT(const X_In, Y_In : double) : TPoint;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
        end;

implementation

    //private
        //modifiers
            //drawingSpace space boundaries
                //x bounds
                    procedure TDrawingAxisConverterBase.setDomainMin(const domainMinIn : double);
                        begin
                            drawingSpace.minPoint.x := domainMinIn;
                        end;

                    procedure TDrawingAxisConverterBase.setDomainMax(const domainMaxIn : double);
                        begin
                            drawingSpace.maxPoint.x := domainMaxIn;
                        end;

                //y bounds
                    procedure TDrawingAxisConverterBase.setRangeMin(const rangeMinIn : double);
                        begin
                            drawingSpace.minPoint.y := rangeMinIn;
                        end;

                    procedure TDrawingAxisConverterBase.setRangeMax(const rangeMaxIn : double);
                        begin
                            drawingSpace.maxPoint.y := rangeMaxIn;
                        end;

        //convertion calculations
            //canvasSpace-to-drawing
                function TDrawingAxisConverterBase.L_to_X(const L_In : double) : double;
                    begin
                        //x(l) = (D/w)l + xmin

                        result := ((calculateDrawingDomain() / canvasSpace.width) * L_In) + drawingSpace.minPoint.x;
                    end;

                function TDrawingAxisConverterBase.T_to_Y(const T_In : double) : double;
                    begin
                        //y(t) = -(R/h)t + ymax

                        result := -((calculateDrawingRange() / canvasSpace.height) * T_In) + drawingSpace.maxPoint.y;
                    end;

            //drawing-to-canvas
                //double verions
                    function TDrawingAxisConverterBase.X_to_L(const X_In : double) : double;
                        var
                            deltaX : double;
                        begin
                            //l(x) = (w/D)(x - xmin)

                            deltaX := X_In - drawingSpace.minPoint.x;

                            result := round( (canvasSpace.width / calculateDrawingDomain()) * deltaX );
                        end;

                    function TDrawingAxisConverterBase.Y_to_T(const Y_In : double) : double;
                        var
                            deltaY : double;
                        begin
                            //t(y) = (h/R)(ymax - y)

                            deltaY := drawingSpace.maxPoint.y - Y_In;

                            result := round( (canvasSpace.height / calculateDrawingRange()) * deltaY );
                        end;

    //protected
        //helper methods
            //canvas
                function TDrawingAxisConverterBase.canvasHeight() : integer;
                    begin
                        result := canvasSpace.Height;
                    end;

                function TDrawingAxisConverterBase.canvasWidth() : integer;
                    begin
                        result := canvasSpace.Width;
                    end;

            //domain
                function TDrawingAxisConverterBase.domainMin() : double;
                    begin
                        result := drawingSpace.minPoint.x;
                    end;

                function TDrawingAxisConverterBase.domainMax() : double;
                    begin
                        result := drawingSpace.maxPoint.x;
                    end;

                function TDrawingAxisConverterBase.calculateDrawingDomain() : double;
                    begin
                        result := domainMax() - domainMin();
                    end;

                function TDrawingAxisConverterBase.calculateDomainCentre() : double;
                    begin
                        result := Mean(
                                        [domainMin(), domainMax()]
                                      );
                    end;

            //range
                function TDrawingAxisConverterBase.rangeMin() : double;
                    begin
                        result := drawingSpace.minPoint.y;
                    end;

                function TDrawingAxisConverterBase.rangeMax() : double;
                    begin
                        result := drawingSpace.maxPoint.y;
                    end;

                function TDrawingAxisConverterBase.calculateDrawingRange() : double;
                    begin
                        result := rangeMax() - rangeMin();
                    end;

                function TDrawingAxisConverterBase.calculateRangeCentre() : double;
                    begin
                        result := Mean(
                                        [rangeMin(), rangeMax()]
                                      );
                    end;

        //modifiers
            //canvasSpace boundaries
                procedure TDrawingAxisConverterBase.setCanvasHeight(const heightIn : integer);
                    begin
                        canvasSpace.height := heightIn;
                    end;

                procedure TDrawingAxisConverterBase.setCanvasWidth(const widthIn : integer);
                    begin
                        canvasSpace.width := widthIn;
                    end;

            //drawingSpace space boundaries
                procedure TDrawingAxisConverterBase.setDomain(const domainMinIn, domainMaxIn : double);
                    begin
                        setDomainMin(domainMinIn);
                        setDomainMax(domainMaxIn);
                    end;

                procedure TDrawingAxisConverterBase.setRange(const rangeMinIn, rangeMaxIn : double);
                    begin
                        setRangeMin(rangeMinIn);
                        setRangeMax(rangeMaxIn);
                    end;

                procedure TDrawingAxisConverterBase.setDrawingRegion(const domainMinIn, domainMaxIn, rangeMinIn, rangeMaxIn : double);
                    begin
                        setDomain(domainMinIn, domainMaxIn);
                        setRange(rangeMinIn, rangeMaxIn);
                    end;

        //convertion calculations
            //canvasSpace-to-drawing
                function TDrawingAxisConverterBase.LT_to_XY(const L_In, T_In : double) : TGeomPoint;
                    var
                        pointOut : TGeomPoint;
                    begin
                        pointOut.x := L_to_X(L_In);
                        pointOut.y := T_to_Y(T_In);

                        result := pointOut;
                    end;

            //drawing-to-canvas
                function TDrawingAxisConverterBase.XY_to_LTF(const X_In, Y_In : double) : TPointF;
                    var
                        pointOut : TPointF;
                    begin
                        pointOut.x := X_to_L(X_In);
                        pointOut.y := Y_to_T(Y_In);

                        result := pointOut;
                    end;

                function TDrawingAxisConverterBase.XY_to_LT(const X_In, Y_In : double) : TPoint;
                    var
                        pointF : TPointF;
                    begin
                        pointF := XY_to_LTF(X_In, Y_In);

                        result := point( round(pointF.X), round(pointF.Y) )
                    end;

    //public
        //constructor
            constructor TDrawingAxisConverterBase.create();
                begin
                    inherited create();

                    canvasSpace.Left := 0;
                    canvasSpace.Top  := 0;

                    drawingSpace.minPoint.z := 0;
                    drawingSpace.maxPoint.z := 0;
                end;

        //destructor
            destructor TDrawingAxisConverterBase.destroy();
                begin
                    inherited destroy();
                end;

end.
