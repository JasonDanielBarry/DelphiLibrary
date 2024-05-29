unit GeomPolyLineClass;

interface

    uses
        System.SysUtils, Math,
        GeometryTypes,
        GeometryBaseClass,
        GeomLineClass;

    type
        TGeomPolyLine = class(TGeomBase)
            private
                //member variables
                    arrLines : TArray<TGeomLine>;
                //helper methods
                    //get line count
                        function lineCount() : integer;
                    //update the polyline
                        procedure updatePolyLine();
            protected
                //member variables
                    arrVertices : TArray<TGeomPoint>;
                //helper methods
                    function vertexCount() : integer;
            public
                //constructor
                    constructor create();
                //destructor
                    destructor destroy(); override;
                //modifiers
                    //add a new vertex and line
                        procedure addVertex(newVertexIn : TGeomPoint);
                    //edit a currently selected vertex
                        procedure editVertex(   indexIn         : integer;
                                                xIn, yIn, zIn   : double    ); overload;
                        procedure editVertex(   indexIn     : integer;
                                                newPointIn  : TGeomPoint);
                //drawing points
                    function drawingPoints() : TArray<TGeomPoint>; override;
        end;

implementation

    //private
        //helper methods
            //get the line count
                function TGeomPolyLine.lineCount() : integer;
                    begin
                        result := length(arrLines);
                    end;

            //update the polyline
                procedure TGeomPolyLine.updatePolyLine();
                    var
                        i : integer;
                    begin
                        for i := 0 to (lineCount() - 1) do
                            arrLines[i].setPoints(arrVertices[i], arrVertices[i + 1]);
                    end;

    //protected
        //helper methods
            function TGeomPolyLine.vertexCount() : integer;
                begin
                    result := Length(arrVertices);
                end;

    //public
        //constructor
            constructor TGeomPolyLine.create();
                begin
                    inherited create();

                    SetLength(arrLines,     0);
                    SetLength(arrVertices,  0);
                end;

        //destructor
            destructor TGeomPolyLine.destroy();
                var
                    i : integer;
                begin
                    //free all the line classes
                        for i := 0 to (lineCount() - 1) do
                            begin
                                freeAndNil(arrLines[i]);
                            end;

                    SetLength(arrLines, 0);

                    inherited destroy();
                end;

        //add a line to the array of lines
            procedure TGeomPolyLine.addVertex(newVertexIn : TGeomPoint);
                var
                    newLineStartPoint, newLineEndPoint  : TGeomPoint;
                begin
                    //increment vertex array
                        SetLength(arrVertices, vertexCount() + 1);

                    //add new vertex to array
                        arrVertices[vertexCount() - 1] := newVertexIn;

                    //after adding the first point a line cannot be made - test if there are enough points to make a line
                        if (length(arrVertices) > 1) then
                            begin
                                //create new Line
                                    SetLength(arrLines, vertexCount() - 1);

                                //get the points for the new line
                                    newLineStartPoint   := arrVertices[vertexCount() - 2];
                                    newLineEndPoint     := arrVertices[vertexCount() - 1];

                                //create new line
                                    arrLines[lineCount() - 1] := TGeomLine.create(newLineStartPoint, newLineEndPoint);
                            end;

                    //double check the points are assigned correctly
                        updatePolyLine();
                end;

            //edit a currently selected vertex
                procedure TGeomPolyLine.editVertex( indexIn         : integer;
                                                    xIn, yIn, zIn   : double    );
                    begin

                    end;

                procedure TGeomPolyLine.editVertex( indexIn     : integer;
                                                    newPointIn  : TGeomPoint);
                    begin

                    end;

        //drawing points
            function TGeomPolyLine.drawingPoints() : TArray<TGeomPoint>;
                begin
                    result := arrVertices;
                end;

end.
