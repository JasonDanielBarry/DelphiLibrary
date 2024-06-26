unit LinearAlgeberaMethods;

interface

    uses
        System.SysUtils, system.Math, system.Math.Vectors;

    //matrix determinant
        //2x2
            function determinant(   a, b,
                                    c, d    : double) : double; overload;

        //3x3
            function determinant(   a, b, c,
                                    d, e, f,
                                    g, h, i     : double) : double; overload;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;

implementation

    //matrix determinant
        //2x2
            function determinant(   a, b,
                                    c, d    : double) : double;
                begin
                    //det = |a b|
                    //      |c d|
                    //    = ad - bc

                    result := (a * d) - (b * c);
                end;

        //3x3
            function determinant(   a, b, c,
                                    d, e, f,
                                    g, h, i     : double) : double;
                begin
                    //      |a b c|
                    //det = |d e f|
                    //      |g h i|

                    //    = a|e f| - b|d f| + c|d e|
                    //       |h i|    |g i|    |g h|

                    result :=       a * determinant(e, f,
                                                    h, i)

                                -   b * determinant(d, f,
                                                    g, i)

                                +   c * determinant(d, e,
                                                    g, h);
                end;

    //triangle area given three vertices
        function triangleArea(  x1, y1,
                                x2, y2,
                                x3, y3  : double) : double;
            var
                areaOut : double;
            begin
                //              |x1 y1 1|
                //A = (1/2) det(|x2 y2 1|)
                //              |x3 y3 1|

                result := 0.5 * determinant(x1, y1, 1,
                                            x2, y2, 1,
                                            x3, y3, 1);
            end;

end.
