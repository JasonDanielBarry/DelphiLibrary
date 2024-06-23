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

end.
