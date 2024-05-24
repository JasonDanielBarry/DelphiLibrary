unit GeometryTypes;

interface

     type
        EAxis = (x = 0, y = 1, z = 2);

        TGeomPoint = record
            x, y, z : double;
            constructor create(xIn, yIn, zIn : double);
            constructor create(xIn, yIn : double);
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

end.
