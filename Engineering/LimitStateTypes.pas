unit LimitStateTypes;

interface

    uses
        system.SysUtils, system.Math;

    type
        TLimitStateMaterial = record
            var
                averageValue,
                variationCoefficient,
                downgradeFactor,
                partialFactor       : double;
            function cautiousEstimate() : double;
            function designValue() : double;
        end;

implementation

    function TLimitStateMaterial.cautiousEstimate() : double;
        var
            av, vc, df : double;
        begin
            av := averageValue;
            vc := variationCoefficient;
            df := downgradeFactor;

            result := av * (1 - vc * df);
        end;

    function TLimitStateMaterial.designValue() : double;
        begin
            result := cautiousEstimate() / partialFactor;
        end;

end.
