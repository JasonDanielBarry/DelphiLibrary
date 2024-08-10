unit GeometryTypes;

interface

     uses
        System.SysUtils, system.Math, system.Math.Vectors, system.Types,
        GeneralMathMethods
        ;

     type
        EAxis = (eaX = 0, eaY = 1, eaZ = 2);
        EBoundaryRelation = (brInside = 0, brOn = 1, brOutside = 2);

        TGeomPoint = record
            x, y, z : double;
            constructor create(xIn, yIn, zIn : double); overload;
            constructor create(xIn, yIn : double); overload;
            constructor create(PointFIn : TPointF); overload;
            function greaterThan(const pointIn : TGeomPoint) : boolean;
            function greaterThanOrEqual(const pointIn : TGeomPoint) : boolean;
            function isEqual(const pointIn : TGeomPoint) : boolean;
            function lessThan(const pointIn : TGeomPoint) : boolean;
            function lessThanOrEqual(const pointIn : TGeomPoint) : boolean;
        end;

        TGeomBox = record
            minPoint, maxPoint : TGeomPoint;
            function pointIsWithin(const pointIn : TGeomPoint) : boolean;
        end;

        TLineIntersectionData = record
            intersection        : boolean;
            relativeToBound     : EBoundaryRelation;
            point               : TGeomPoint;
        end;

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
        function TGeomBox.pointIsWithin(const pointIn: TGeomPoint): boolean;
            var
                greaterThanMinPoint, lessThanMaxPoint : boolean;
            begin
                greaterThanMinPoint := pointIn.greaterThanOrEqual(minPoint);

                lessThanMaxPoint := pointIn.lessThanOrEqual(maxPoint);

                result := (greaterThanMinPoint AND lessThanMaxPoint);
            end;

end.
