unit Graphic2DTypes;

interface

    uses
        system.SysUtils, system.Skia,
        DrawingAxisConversionClass
        ;

    type
        TGraphicDrawEvent = procedure(ASender : TObject; const ACanvas : ISkCanvas; const ADrawingAxisConverter : TDrawingAxisConverter) of object;

implementation

end.
