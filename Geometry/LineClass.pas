unit LineClass;

interface

    uses system.sysUtils, Math;

    type
        TPointGeom = record
            x, y : double;
        end;

        TVector2D = record
            horizontalComponent,
            verticalComponent   : double;
        end;

        TLineGeom = class
            private
                //member variables
                    point1, point2: TPointGeom;
                //helper methods
                    //assign points
                        procedure assignPoints(point1In, point2In : TPointGeom);
                    //calculate projection onto x-axis (x-component)
                        function horizontalProjection() : double;
                    //calculate projection onto y-axis (y-component)
                        function verticalProjection() : double;
                    //acquire unit vector
                        function unitVector() : TVector2D;
            protected
            public
                //constructor
                    constructor create(); overload;
                    constructor create(point1In, point2In : TPointGeom); overload;
                    constructor create( lengthIn, lineAngelIn   : double;
                                        originPointIn           : TPointGeom); overload;
                //destructor
                    destructor destroy(); override;
                //accessors
                    function getPoint1() : TPointGeom;
                    function getPoint2() : TPointGeom;
                //calculate line length
                    function length() : double;
        end;

implementation

    //private
        //helper methods
            //assign points
                procedure TLineGeom.assignPoints(point1In, point2In : TPointGeom);
                    begin
                        point1 := point1In;
                        point2 := point2In;
                    end;

            //calculate projection onto x-axis (x-component)
                function TLineGeom.horizontalProjection() : double;
                    begin
                        result := point2.x - point1.x;
                    end;

            //calculate projection onto y-axis (y-component)
                function TLineGeom.verticalProjection() : double;
                    begin
                        result := point2.y - point1.y;
                    end;

            //calculate unit vector
                function TLineGeom.unitVector() : TVector2D;
                    var
                        vector2DOut : TVector2D;
                    begin
                        vector2DOut.horizontalComponent := horizontalProjection() / length();
                        vector2DOut.verticalComponent   := verticalProjection() / length();

                        result := vector2DOut;
                    end;

    //public
        //constructor
            constructor TLineGeom.create();
                begin
                    inherited create();
                end;

            constructor TLineGeom.create(point1In, point2In : TPointGeom);
                begin
                    create();

                    assignPoints(point1In, point2In);
                end;

            constructor TLineGeom.create(   lengthIn, lineAngelIn   : double;
                                        originPointIn           : TPointGeom);
                var
                    point1, point2 : TPointGeom;
                begin
                    //assign second point for line creation
                        point1 := originPointIn;

                        point2.x := point1.x + lengthIn * cos(DegToRad(lineAngelIn));
                        point2.y := point1.y + lengthIn * sin(DegToRad(lineAngelIn));

                    //assign points
                        create(point1, point2);
                end;

        //desturctor
            destructor TLineGeom.destroy();
                begin
                    inherited destroy();
                end;

        //calculate line length
            function TLineGeom.length() : double;
                begin
                    result := hypot(horizontalProjection, verticalProjection);
                end;

        //accessors
            function TLineGeom.getPoint1() : TPointGeom;
                begin
                    result := point1;
                end;

            function TLineGeom.getPoint2() : TPointGeom;
                begin
                    result := point2;
                end;
end.