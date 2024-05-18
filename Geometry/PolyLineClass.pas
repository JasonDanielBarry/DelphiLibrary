unit PolyLineClass;

interface

    uses
        System.SysUtils, Math,
        LineClass;

    type
        TPolyLineGeom = class
            private
                //member variables
                    arrLines : TArray<TLineGeom>;
            protected
            public
                //constructor
                    constructor create(point1In, point2In : TPointGeom);
                //destructor
                    destructor destroy(); override;
                //add a line to the array of lines
                    procedure addLine(pointIn : TPointGeom);
        end;

implementation

    //private

    //protected

    //public
        //constructor
            constructor TPolyLineGeom.create(point1In, point2In : TPointGeom);
                begin
                    inherited create();

                    setLength(arrLines, 1);

                    arrLines[0] := TLineGeom.create(point1In, point2In);
                end;

        //destructor
            destructor TPolyLineGeom.destroy();
                var
                    i, arrLen : integer;
                begin
                    inherited destroy();

                    //free all the line classes
                        for i := 0 to (arrlen - 1) do
                            begin
                                freeAndNil(arrLines[0]);
                            end;
                end;

        //add a line to the array of lines
            procedure TPolyLineGeom.addLine(pointIn : TPointGeom);
                var
                    arrLen          : integer;
                    point1, point2  : TPointGeom;
                begin
                    //get array length and increment
                        arrLen := length(arrLines);

                        setLength(arrLines, arrLen + 1);

                    //assign first point as second point of previous line
                        point1 := arrLines[0].getPoint2;
                        point2 := pointIn;

                    //create new line
                        arrLines[arrlen] := TLineGeom.create(point1, point2);
                end;



end.