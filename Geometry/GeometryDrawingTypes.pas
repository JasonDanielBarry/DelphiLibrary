unit GeometryDrawingTypes;

interface

    uses
        //Delphi
            system.SysUtils, system.types, system.UITypes,
        //custom
            GeometryTypes,
            GeometryBaseClass,
            GeomLineClass, GeomPolyLineClass
            ;

    type
        TGeomDrawingObject = record
            lineThickness   : integer;
            fillColour,
            lineColour      : TAlphaColor;
            geometry        : TGeomBase;
            procedure setValues(const   lineThicknessIn : integer;
                                const   fillColourIn,
                                        lineColourIn    : TAlphaColor;
                                const   geometryIn      : TGeomBase     );
            procedure freeGeometry();
        end;

implementation

    procedure TGeomDrawingObject.setValues( const   lineThicknessIn : integer;
                                            const   fillColourIn,
                                                    lineColourIn    : TAlphaColor;
                                            const   geometryIn      : TGeomBase     );
        begin
            lineThickness   := lineThicknessIn;
            geometry        := geometryIn;
            fillColour      := fillColourIn;
            lineColour      := lineColourIn;
        end;

    procedure TGeomDrawingObject.freeGeometry();
        begin
            try
                FreeAndNil(geometry);
            except

            end;
        end;

end.
