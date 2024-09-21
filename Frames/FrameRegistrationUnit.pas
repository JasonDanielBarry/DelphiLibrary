unit FrameRegistrationUnit;

interface

    uses
        system.SysUtils, System.Classes,
        Graphic2DFrame
        ;

    procedure register();

implementation

    procedure register();
        begin
            RegisterComponents('JDBDelphiLibrary', [TGraphic2D]);
        end;

end.
