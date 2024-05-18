unit GeneralComponentHelperMethods;

interface

    uses
        system.SysUtils, winapi.Windows, Vcl.Forms;

    function strToFloatZero(const stringValueIn : string) : double;

implementation

    function strToFloatZero(const stringValueIn : string) : double;
        begin
            if (stringValueIn = '') then
                result := 0
            else
                try
                    result := strToFloatZero(stringValueIn);
                except
                    Application.MessageBox('value entered is not real number or integer', 'Invalid Input', MB_OK);
                    result := 0;
                end;
        end;

end.
