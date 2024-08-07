unit GeomLineClass;

interface

    uses
        system.sysUtils, system.Math,
        LinearAlgeberaMethods,
        GeometryTypes, GeometryBaseClass, GeomSpaceVectorClass;

    type
        TGeomLine = class(TGeomBase)
            private
                const
                    //line vector index constants
                        x : integer = 0;
                        y : integer = 1;
                        z : integer = 2;
                var
                    startPoint, endPoint    : TGeomPoint;
                    lineVector              : TGeomSpaceVector;
                //helper methods
                    //calculat line projections on 3 axes
                        procedure calculateAxisProjections();
                    //assign points
                        procedure assignPoints(startPointIn, endPointIn : TGeomPoint);
                        procedure updatePoints();
            protected
                //
            public
                //constructor
                    constructor create(); overload;
                    constructor create(startPointIn, endPointIn : TGeomPoint); overload;
                //destructor
                    destructor destroy(); override;
                //accessors
                    function getStartPoint() : TGeomPoint;
                    function getEndPoint() : TGeomPoint;
                //modifiers
                    procedure setStartPoint(startPointIn : TGeomPoint);
                    procedure setEndPoint(endPointIn : TGeomPoint);
                    procedure setPoints(startPointIn, endPointIn : TGeomPoint);
                //calculattions
                    //line length
                        function lineLength() : double;
                    //unit vector
                        function unitVector() : TGeomSpaceVector;
                    //parametric line equation point
                        function parametricEquationPoint(tIn : double) : TGeomPoint;
                    //line intersection
                        function intersection(  const lineIn        : TGeomLine;
                                                const freeLineIn    : boolean = True) : TLineIntersectionData;
                //bounding box
                    function boundingBox() : TGeomBox;
                //drawing points
                    function drawingPoints() : TArray<TGeomPoint>; override;
        end;
//----------------------------------------------------------------------------------------------------
    //calculate intersection point
        function geomLineIntersection(  const line1In, line2In  : TGeomLine;
                                        const freeLinesIn       : boolean = True) : TLineIntersectionData;

implementation

//----------------------------------------------------------------------------------------------------
    //private
        //helper methods
            //calculat line projections on 3 axes
                //x-axis (x-component)
                    procedure TGeomLine.calculateAxisProjections();
                        begin
                            lineVector[x] := endPoint.x - startPoint.x;
                            lineVector[y] := endPoint.y - startPoint.y;
                            lineVector[z] := endPoint.z - startPoint.z;
                        end;

            //assign points
                procedure TGeomLine.assignPoints(startPointIn, endPointIn : TGeomPoint);
                    begin
                        startPoint  := startPointIn;
                        endPoint    := endPointIn;

                        calculateAxisProjections();
                    end;

                procedure TGeomLine.updatePoints();
                    begin
                        assignPoints(startPoint, endPoint);
                    end;

    //public
        //constructor
            constructor TGeomLine.create();
                begin
                    inherited create();

                    lineVector := TGeomSpaceVector.create();

                    lineVector.setDimensions(3);
                end;

            constructor TGeomLine.create(startPointIn, endPointIn : TGeomPoint);
                begin
                    create();

                    assignPoints(startPointIn, endPointIn);
                end;

        //destructor
            destructor TGeomLine.destroy();
                begin
                    inherited destroy();

                    FreeAndNil(lineVector);
                end;

        //calculations
            //line length
                function TGeomLine.lineLength() : double;
                    begin
                        result := lineVector.normalise();
                    end;

            //unit vector
                function TGeomLine.unitVector() : TGeomSpaceVector;
                    begin
                        result := lineVector.calculateUnitVector();
                    end;

            //parametric line equation point
                function TGeomLine.parametricEquationPoint(tIn : double) : TGeomPoint;
                    var
                        lineUnitVector  : TGeomSpaceVector;
                        pointOut        : TGeomPoint;
                    begin
                        lineUnitVector := unitVector();

                        //(x, y, z) = (x0, y0, z0) + t<ux, uy, uz>
                            pointOut.x := startPoint.x + tIn * lineUnitVector[0];
                            pointOut.y := startPoint.y + tIn * lineUnitVector[1];
                            pointOut.z := startPoint.z + tIn * lineUnitVector[2];

                        FreeAndNil(lineUnitVector);

                        result := pointOut;
                    end;

            //line intersection
                function TGeomLine.intersection(const lineIn        : TGeomLine;
                                                const freeLineIn    : boolean = True) : TLineIntersectionData;
                    var
                        lineIntersectionDataOut : TLineIntersectionData;
                    begin
                        //get intersection data
                            lineIntersectionDataOut := geomLineIntersection(self, lineIn, false);

                        //determine intersection point region
                            if (lineIntersectionDataOut.intersection = False) then
                                exit();

                            if (self.boundingBox().pointIsWithin(lineIntersectionDataOut.point)) then
                                lineIntersectionDataOut.relativeToBound := EBoundaryRelation.brInside
                            else
                                lineIntersectionDataOut.relativeToBound := EBoundaryRelation.brOutside;

                        //free line if necessary
                            if (freeLineIn) then
                                FreeAndNil(lineIn);

                        result := lineIntersectionDataOut;
                    end;

        //accessors
            function TGeomLine.getStartPoint() : TGeomPoint;
                begin
                    result := startPoint;
                end;

            function TGeomLine.getEndPoint() : TGeomPoint;
                begin
                    result := endPoint;
                end;

        //modifiers
            procedure TGeomLine.setStartPoint(startPointIn : TGeomPoint);
                begin
                    startPoint := startPointIn;

                    updatePoints();
                end;

            procedure TGeomLine.setEndPoint(endPointIn : TGeomPoint);
                begin
                    endPoint := endPointIn;

                    updatePoints();
                end;

            procedure TGeomLine.setPoints(startPointIn, endPointIn : TGeomPoint);
                begin
                    assignPoints(startPointIn, endPointIn);
                end;

        //bounding box
            function TGeomLine.boundingBox() : TGeomBox;
                var
                    boxOut : TGeomBox;
                begin
                    //min point
                        boxOut.minPoint.x := min(startPoint.x, endPoint.x);
                        boxOut.minPoint.y := min(startPoint.y, endPoint.y);
                        boxOut.minPoint.z := min(startPoint.z, endPoint.z);
                    //max point
                        boxOut.maxPoint.x := max(startPoint.x, endPoint.x);
                        boxOut.maxPoint.y := max(startPoint.y, endPoint.y);
                        boxOut.maxPoint.z := max(startPoint.z, endPoint.z);

                    result := boxOut;
                end;

        //drawing points
            function TGeomLine.drawingPoints() : TArray<TGeomPoint>;
                var
                    arrPoints : TArray<TGeomPoint>;
                begin
                    SetLength(arrPoints, 2);
                    arrPoints[0] := startPoint;
                    arrPoints[1] := endPoint;
                    result := arrPoints;
                end;
//----------------------------------------------------------------------------------------------------
    //calculate intersection point
        function geomLineIntersection(  const line1In, line2In  : TGeomLine;
                                        const freeLinesIn       : boolean = True) : TLineIntersectionData;
            var
                x1, y1, u1, v1,
                x2, y2, u2, v2              : double;
                lineIntersectionDataOut     : TLineIntersectionData;
            procedure
                _extractLineInfo();
                    var
                        unitVector1, unitVector2 : TGeomSpaceVector;
                    begin
                        //get line 1 info
                            x1 := line1In.getStartPoint().x;
                            y1 := line1In.getStartPoint().y;

                            unitVector1 := line1In.unitVector();

                            u1 := unitVector1[0];
                            v1 := unitVector1[1];

                            FreeAndNil(unitVector1);

                        //get line 2 info
                            x2 := line2In.getStartPoint().x;
                            y2 := line2In.getStartPoint().y;

                            unitVector2 := line2In.unitVector();

                            u2 := unitVector2[0];
                            v2 := unitVector2[1];

                            FreeAndNil(unitVector2);
                    end;
            procedure
                _getIntersectionPoint();
                    begin
                        //get the intersection point
                            lineIntersectionDataOut.point := TGeomPoint.create(
                                                                                    lineIntersectionPoint(  lineIntersectionDataOut.intersection,
                                                                                                            x1, y1, u1, v1,
                                                                                                            x2, y2, u2, v2                      )
                                                                              );
                    end;
            procedure
                _determineIntersectionRegion();
                    var
                        line1Bound, line2Bound : TGeomBox;
                    begin
                        line1Bound := line1In.boundingBox();
                        line2Bound := line2In.boundingBox();

                        if  (
                                line1Bound.pointIsWithin(lineIntersectionDataOut.point)
                                OR
                                line2Bound.pointIsWithin(lineIntersectionDataOut.point)
                            ) then
                            begin
                                lineIntersectionDataOut.relativeToBound := EBoundaryRelation.brInside;
                            end
                        else
                            begin
                                lineIntersectionDataOut.relativeToBound := EBoundaryRelation.brOutside;
                            end;
                    end;
            procedure
                _freeLines();
                    begin
                        //free lines if necessary
                            if (freeLinesIn) then
                                begin
                                    FreeAndNil(line1In);
                                    FreeAndNil(line2In);
                                end;
                    end;

            begin
                _extractLineInfo();

                _getIntersectionPoint();

                if (lineIntersectionDataOut.intersection = True) then
                    _determineIntersectionRegion();

                _freeLines();

                result := lineIntersectionDataOut;
            end;

end.
