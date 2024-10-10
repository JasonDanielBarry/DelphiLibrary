unit GeometryTypes;

interface

     uses
        System.SysUtils, system.Math, system.Math.Vectors, system.Types,
        GeneralMathMethods
        ;

     type
        EAxis = (eaX = 0, eaY = 1, eaZ = 2);
        EBoundaryRelation = (brInside = 0, brOn = 1, brOutside = 2);
        EGeomType = (gtLine = 0, gtPolyline = 1, gtPolygon = 2, gtSpaceVector = 3);

        TGeomPoint = record
            x, y, z : double;
            constructor create(xIn, yIn, zIn : double); overload;
            constructor create(xIn, yIn : double); overload;
            constructor create(PointFIn : TPointF); overload;
            constructor create(PointIn : TPoint); overload;
            function greaterThan(const pointIn : TGeomPoint) : boolean;
            function greaterThanOrEqual(const pointIn : TGeomPoint) : boolean;
            function isEqual(const pointIn : TGeomPoint) : boolean;
            function lessThan(const pointIn : TGeomPoint) : boolean;
            function lessThanOrEqual(const pointIn : TGeomPoint) : boolean;
        end;

        TGeomBox = record
            minPoint, maxPoint : TGeomPoint;
            constructor create(point1In, point2In : TGeomPoint); overload;
            constructor create(arrGeomBoxesIn : TArray<TGeomBox>); overload;
            function pointIsWithin(const pointIn : TGeomPoint) : boolean;
        end;

        TGeomLineIntersectionData = record
            intersectionExists  : boolean;
            relativeToBound     : EBoundaryRelation;
            point               : TGeomPoint;
        end;

     function determineBoundingBox(arrGeomBoxesIn : TArray<TGeomBox>) : TGeomBox;

implementation

    //TGeomPoint
        constructor TGeomPoint.create(xIn, yIn, zIn : double);
            begin
                x := xIn;
                y := yIn;
                z := zIn;
            end;

        constructor TGeomPoint.create(xIn, yIn : double);
            begin
                create(xIn, yIn, 0);
            end;

        constructor TGeomPoint.create(PointFIn : TPointF);
            begin
                create(PointFIn.X, PointFIn.Y);
            end;

        constructor TGeomPoint.create(PointIn : TPoint);
            begin
                create(PointIn.X, PointIn.Y)
            end;

        function TGeomPoint.greaterThan(const pointIn : TGeomPoint) : boolean;
            begin
                result :=       (pointIn.x < self.x)
                            AND (pointIn.y < self.y)
                            AND (pointIn.z < self.z)
            end;

        function TGeomPoint.greaterThanOrEqual(const pointIn: TGeomPoint): Boolean;
            begin
                result :=       (pointIn.x <= self.x)
                            AND (pointIn.y <= self.y)
                            AND (pointIn.z <= self.z)
            end;

        function TGeomPoint.isEqual(const pointIn : TGeomPoint) : boolean;
            begin
                result :=       isAlmostEqual(pointIn.x, self.x)
                            AND isAlmostEqual(pointIn.y, self.y)
                            AND isAlmostEqual(pointIn.z, self.z)
            end;

        function TGeomPoint.lessThan(const pointIn: TGeomPoint): boolean;
            begin
                result :=       (self.x < pointIn.x)
                            AND (self.y < pointIn.y)
                            AND (self.z < pointIn.z)
            end;

        function TGeomPoint.lessThanOrEqual(const pointIn: TGeomPoint): Boolean;
            begin
                result :=       (self.x <= pointIn.x)
                            AND (self.y <= pointIn.y)
                            AND (self.z <= pointIn.z)
            end;

    //TGeomBox
        constructor TGeomBox.create(point1In, point2In : TGeomPoint);
            begin
                //min point
                    minPoint.x := min(point1In.x, point2In.x);
                    minPoint.y := min(point1In.y, point2In.y);
                    minPoint.z := min(point1In.z, point2In.z);
                //max point
                    maxPoint.x := max(point1In.x, point2In.x);
                    maxPoint.y := max(point1In.y, point2In.y);
                    maxPoint.z := max(point1In.z, point2In.z);
            end;

        constructor TGeomBox.create(arrGeomBoxesIn : TArray<TGeomBox>);
            begin
                Self := determineBoundingBox(arrGeomBoxesIn);
            end;

        function TGeomBox.pointIsWithin(const pointIn: TGeomPoint): boolean;
            var
                greaterThanMinPoint, lessThanMaxPoint : boolean;
            begin
                greaterThanMinPoint := pointIn.greaterThanOrEqual(minPoint);

                lessThanMaxPoint := pointIn.lessThanOrEqual(maxPoint);

                result := (greaterThanMinPoint AND lessThanMaxPoint);
            end;

        function determineBoundingBox(arrGeomBoxesIn : TArray<TGeomBox>) : TGeomBox;
            var
                i                   : integer;
                minPoint, maxPoint  : TGeomPoint;
                boundingBoxOut      : TGeomBox;
            begin
                minPoint := arrGeomBoxesIn[0].minPoint;
                maxPoint := arrGeomBoxesIn[0].maxPoint;

                for i := 1 to (length(arrGeomBoxesIn) - 1) do
                    begin
                        //look for min x, y, z
                            minPoint.x := min( minPoint.x, arrGeomBoxesIn[i].minPoint.x );
                            minPoint.y := min( minPoint.y, arrGeomBoxesIn[i].minPoint.y );
                            minPoint.z := min( minPoint.z, arrGeomBoxesIn[i].minPoint.z );

                        //look for max x, y, z
                            maxPoint.x := max( maxPoint.x, arrGeomBoxesIn[i].maxPoint.x );
                            maxPoint.y := max( maxPoint.y, arrGeomBoxesIn[i].maxPoint.y );
                            maxPoint.z := max( maxPoint.z, arrGeomBoxesIn[i].maxPoint.z );
                    end;

                boundingBoxOut := TGeomBox.create(minPoint, maxPoint);

                result := boundingBoxOut;
            end;

end.
