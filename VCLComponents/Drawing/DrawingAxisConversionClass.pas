unit DrawingAxisConversionClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        DrawingTypes,
        GeometryTypes;

    type
        TDrawingAxisConverter = class
            private
                type
                    TCanvasRegion = record
                        height, width : integer;
                    end;
                var
                    canvasSpace  : TCanvasRegion;
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
                        //y bounds
                            procedure setYMin(yMinIn : double);
                            procedure setYMax(yMaxIn : double);
                        procedure setDrawingRegion(xMinIn, xMaxIn, yMinIn, yMaxIn : double);
                //convertion calculations
                    //canvas-to-drawing
                        function L_to_X(L_In : integer) : double;
                        function T_to_Y(T_In : integer) : double;
                        function LT_to_XY(L_In, T_In : integer) : TGeomPoint; overload;
                        function LT_to_XY(pointIn : TCanvasPoint) : TGeomPoint; overload;
                    //drawing-to-canvas
                        function X_to_L(X_In : double) : integer;
                        function Y_to_T(Y_In : double) : integer;
                        function XY_to_LT(X_In, Y_In : double) : TPoint; overload;
                        function XY_to_LT(pointIn : TGeomPoint) : TPoint; overload;
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

                //y bounds
                    procedure TDrawingAxisConverter.setYMin(yMinIn : double);
                        begin
                            drawingSpace.minPoint.y := yMinIn;
                        end;

                    procedure TDrawingAxisConverter.setYMax(yMaxIn : double);
                        begin
                            drawingSpace.maxPoint.y := yMaxIn;
                        end;

                procedure TDrawingAxisConverter.setDrawingRegion(xMinIn, xMaxIn, yMinIn, yMaxIn : double);
                    begin
                        setXMin(xMinIn);
                        setXMax(xMaxIn);
                        setYMin(yMinIn);
                        setYMax(yMaxIn);
                    end;

        //convertion calculations
            //canvasSpace-to-drawing
                function TDrawingAxisConverter.L_to_X(L_In : integer) : double;
                    begin
                        //x(l) = (D/w)l + xmin

                        result := ((drawingDomain() / canvasSpace.width) * L_In) + drawingSpace.minPoint.x;
                    end;

                function TDrawingAxisConverter.T_to_Y(T_In : integer) : double;
                    begin
                        //y(t) = -(R/h)t + ymax

                        result := -((drawingRange() / canvasSpace.height) * T_In) + drawingSpace.maxPoint.y;
                    end;

                function TDrawingAxisConverter.LT_to_XY(L_In, T_In : integer) : TGeomPoint;
                    var
                        pointOut : TGeomPoint;
                    begin
                        pointOut.x := L_to_X(L_In);
                        pointOut.y := T_to_Y(T_In);

                        result := pointOut;
                    end;

                function TDrawingAxisConverter.LT_to_XY(pointIn : TCanvasPoint) : TGeomPoint;
                    begin
                        result := LT_to_XY(pointIn.l, pointIn.t);
                    end;

            //drawing-to-canvas
                function TDrawingAxisConverter.X_to_L(X_In : double) : integer;
                    var
                        deltaX : double;
                    begin
                        //l(x) = (w/D)(x - xmin)

                        deltaX := X_In - drawingSpace.minPoint.x;

                        result := round( (canvasSpace.width / drawingDomain()) * deltaX );
                    end;

                function TDrawingAxisConverter.Y_to_T(Y_In : double) : integer;
                    var
                        deltaY : double;
                    begin
                        //t(y) = (h/R)(ymax - y)

                        deltaY := drawingSpace.maxPoint.y - Y_In;

                        result := round( (canvasSpace.height / drawingRange()) * deltaY );
                    end;

                function TDrawingAxisConverter.XY_to_LT(X_In, Y_In : double) : TPoint;
                    var
                        pointOut : TPoint;
                    begin
                        pointOut.x := X_to_L(X_In);
                        pointOut.y := Y_to_T(Y_In);

                        result := pointOut;
                    end;

                function TDrawingAxisConverter.XY_to_LT(pointIn : TGeomPoint) : TPoint;
                    begin
                        result := XY_to_LT(pointIn.x, pointIn.y);
                    end;

end.
