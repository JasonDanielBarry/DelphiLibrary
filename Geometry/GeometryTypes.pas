unit GeometryTypes;

interface

     uses
        System.SysUtils, system.Math, system.Math.Vectors, system.Types
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
            function lessThan(const pointIn : TGeomPoint) : boolean;
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

        function TGeomPoint.greaterThan(const pointIn: TGeomPoint): Boolean;
            begin
                result :=       (pointIn.x < self.x)
                            AND (pointIn.y < self.y)
                            AND (pointIn.z < self.z)
            end;

        function TGeomPoint.lessThan(const pointIn: TGeomPoint): Boolean;
            begin
                result :=       (self.x < pointIn.x)
                            AND (self.y < pointIn.y)
                            AND (self.z < pointIn.z)
            end;

    //TGeomBox
        function TGeomBox.pointIsWithin(const pointIn: TGeomPoint): boolean;
            var
                greaterThanMinPoint, lessThanMaxPoint : boolean;
            begin
                greaterThanMinPoint := pointIn.greaterThan(minPoint);

                lessThanMaxPoint := pointIn.lessThan(maxPoint);

                result := (greaterThanMinPoint AND lessThanMaxPoint);
            end;

end.
