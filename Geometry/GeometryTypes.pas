unit GeometryTypes;

interface

     uses
        System.SysUtils, system.Math, system.Math.Vectors, system.Types
        ;

     type
        EAxis = (x = 0, y = 1, z = 2);

        TGeomPoint = record
            x, y, z : double;
            constructor create(xIn, yIn, zIn : double); overload;
            constructor create(xIn, yIn : double); overload;
            constructor create(PointFIn : TPointF); overload;
        end;

        TGeomBox = record
            minPoint, maxPoint : TGeomPoint;
        end;

implementation

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

end.
