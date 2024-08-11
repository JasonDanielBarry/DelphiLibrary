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
            procedure setValues(const averageValueIn, variationCoefficientIn, downgradeFactorIn, partialFactorIn : double);
            procedure copyMaterial(const materialIn : TLimitStateMaterial);
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

    procedure TLimitStateMaterial.setValues(const averageValueIn, variationCoefficientIn, downgradeFactorIn, partialFactorIn : double);
        begin
            averageValue          := max(0, averageValueIn);
            variationCoefficient  := max(0, variationCoefficientIn);
            downgradeFactor       := max(0, downgradeFactorIn);
            partialFactor         := max(1, partialFactorIn);
        end;

    procedure TLimitStateMaterial.copyMaterial(const materialIn: TLimitStateMaterial);
        begin
            setValues(  materialIn.averageValue,
                        materialIn.variationCoefficient,
                        materialIn.downgradeFactor,
                        materialIn.partialFactor        );
        end;

end.
