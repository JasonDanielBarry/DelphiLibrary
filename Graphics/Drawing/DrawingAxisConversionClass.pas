unit DrawingAxisConversionClass;

interface

    uses
        System.SysUtils, system.Math, system.Types,
        GeometryTypes,
        DrawingAxisConversionZoomingClass;

    type
        TDrawingAxisConverter = class(TDrawingAxisZoomingConverter)
            private
                //zooming methods
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
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
