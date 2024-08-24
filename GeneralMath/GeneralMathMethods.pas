unit GeneralMathMethods;

interface

    uses
        System.SysUtils, system.Math, system.Math.Vectors;

    //equality test
        function isAlmostEqual( value1In, value2In,
                                toleranceIn         : double) : boolean; overload;

        function isAlmostEqual( value1In, value2In : double) : boolean; overload;

    //max betweem three values
        function max(value1In, value2In, value3In : double) : double; overload;

    //line length
        function lineLength(const   x0, y0, z0,
                                    x1, y1, z1 : double) : double;

implementation

    //equality test
        function isAlmostEqual( value1In, value2In,
                                toleranceIn         : double) : boolean;
            begin
                if ( abs(value1In - value1In) < toleranceIn ) then
                    result := true
                else
                    result := false;
            end;

        function isAlmostEqual( value1In, value2In : double) : boolean;
            begin
                result := isAlmostEqual(value1In, value2In, 1e-6);
            end;

    //max betweem three values
        function max(value1In, value2In, value3In : double) : double;
            begin
                result := system.math.max(value1In, value2In);

                result := system.math.max(result, value3In);
            end;

    //line length
        function lineLength(const   x0, y0, z0,
                                    x1, y1, z1 : double) : double;
                var
                    dx, dy, dz,
                    lengthOut   : double;
                begin
                    dx := x1 - x0;
                    dy := y1 - y0;
                    dz := z1 - z0;

                    lengthOut := sqrt( Power(dx, 2) + power(dy, 2) + power(dz, 2) );

                    result := lengthOut;
                end;




end.
