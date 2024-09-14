unit GeneralComponentHelperMethods;

interface

    uses
        system.SysUtils, winapi.Windows, Vcl.Forms, vcl.Buttons;

    function strToFloatZero(const stringValueIn : string) : double;

    procedure setSpeedButtonDown(   const  groupIndexIn  : integer;
                                    var speedButtonInOut : TSpeedButton);

implementation

    function strToFloatZero(const stringValueIn : string) : double;
        var
            stringIsFloat   : boolean;
            valueOut        : double;
        begin
            stringIsFloat := TryStrToFloat(stringValueIn, valueOut);

            case (stringIsFloat) of
                True:
                    result := valueOut;
                False:
                    result := 0;
            end;
        end;

    procedure setSpeedButtonDown(   const  groupIndexIn  : integer;
                                    var speedButtonInOut : TSpeedButton);
        begin
            speedButtonInOut.AllowAllUp := True;
            speedButtonInOut.GroupIndex := groupIndexIn;
            speedButtonInOut.Down       := True;
        end;

end.
