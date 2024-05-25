unit GeomPolyLineClass;

interface

    uses
        System.SysUtils, Math,
        GeometryTypes,
        GeomLineClass;

    type
        TGeomPolyLine = class
            private
                //member variables
                    arrLines : TArray<TGeomLine>;
            protected
            public
                //constructor
                    constructor create(startPointIn, nextPointIn : TGeomPoint);
                //destructor
                    destructor destroy(); override;
                //add a line to the array of lines
                    procedure addLine(nextPointIn : TGeomPoint);
        end;

implementation

    //private

    //protected

    //public
        //constructor
            constructor TGeomPolyLine.create(startPointIn, nextPointIn : TGeomPoint);
                begin
                    inherited create();

                    setLength(arrLines, 1);

                    arrLines[0] := TGeomLine.create(startPointIn, nextPointIn);
                end;

        //destructor
            destructor TGeomPolyLine.destroy();
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
            procedure TGeomPolyLine.addLine(nextPointIn : TGeomPoint);
                var
                    arrLen                  : integer;
                    startPoint, endPoint    : TGeomPoint;
                begin
                    //get array length and increment
                        arrLen := length(arrLines);

                        setLength(arrLines, arrLen + 1);

                    //assign first point as second point of previous line
                        startPoint  := arrLines[0].getEndPoint();
                        endPoint    := nextPointIn;

                    //create new line
                        arrLines[arrlen] := TGeomLine.create(startPoint, endPoint);
                end;

end.
