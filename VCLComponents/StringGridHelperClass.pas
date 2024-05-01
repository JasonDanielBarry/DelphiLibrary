unit StringGridHelperClass;

interface

    uses
        Winapi.Windows,
        System.SysUtils, Math,
        Vcl.Forms, Vcl.Grids;

    type
        TStringGridHelper = class helper for TStringGrid
            private
                //border adjustment used for sizing the grid
                    function borderAdjustment() : integer;
                //test if a cell's value is a double
                    function checkCellIsDouble(colIn, rowIn : integer) : boolean;
            public
                //delete a grid row
                    procedure deleteRow(rowIndexIn : integer);
                //test if a cell's value is a double and clear it if it is not
                    function isCellDouble(colIn, rowIn : integer) : boolean;
                //get the value of a cell as a double
                    function cellToDouble(colIn, rowIn : integer) : double;
                //resize the grid to its minimum extents
                    procedure minHeight();
                    procedure minWidth();
                    procedure minSize();
        end;

implementation

    //private
        //border adjustment used for sizing the grid
            function TStringGridHelper.borderAdjustment() : integer;
                begin
                    if Self.BorderStyle = bsSingle then
                        result := 2
                    else
                        result := 0;
                end;

        //test if a cell's value is a double
            function TStringGridHelper.checkCellIsDouble(colIn, rowIn : integer) : boolean;
                var
                    cellIsDoubleOut : boolean;
                begin
                    if (NOT(Cells[colIn, rowIn] = '')) then
                        try
                            //try converting the cell contents to a double
                                StrToFloat(trim(self.cells[colIn, rowIn]));
                                cellIsDoubleOut := True;
                        except
                            //if conversion to double fails return error message
                                cellIsDoubleOut := False;
                        end
                    else
                        cellIsDoubleOut := False;

                    result := cellIsDoubleOut;                
                end;

    //public
        //delete a grid row
            procedure TStringGridHelper.deleteRow(rowIndexIn : integer);
                var
                    row, col : integer;
                begin
                    for row := rowIndexIn to (Self.RowCount - 2) do
                        for col := 0 to (Self.ColCount - 1) do
                            begin
                                //row above accepts row below's contents
                                    Self.cells[col, row] := Self.cells[col, row + 1];
                            end;

                    //shorten the row count by 1
                        Self.RowCount := Self.RowCount - 1;
                end;
    
        //test if a cell's value is a double and clear it if it is not
            function TStringGridHelper.isCellDouble(colIn, rowIn : integer) : boolean;
                var
                    cellIsDoubleOut : boolean;
                begin
                    cellIsDoubleOut := checkCellIsDouble(colIn, rowIn);

                    if ( (cellIsDoubleOut = False) AND (NOT(Cells[colIn, rowIn] = '')) ) then
                        begin
                            //if conversion to double fails return error message
                                Application.MessageBox('value entered is not real number or integer', 'Invalid Input', MB_OK);
                                cellIsDoubleOut := False;
                                cells[colIn, rowIn] := '';
                        end;

                    result := cellIsDoubleOut;
                end;

        //get the value of a cell as a double
            function TStringGridHelper.cellToDouble(colIn, rowIn : integer) : double;
                begin
                    if (checkCellIsDouble(colIn, rowIn) = True) then
                        result := StrToFloat(trim(cells[colIn, rowIn]))
                    else
                        result := 0;
                end;

        //resize the grid to its minimum extents
            procedure TStringGridHelper.minHeight();
                var
                    row, gridHeight, sumRowHeights : integer;
                begin
                    //grid height
                        //calculate the sum of the row heights
                            sumRowHeights := 0;
                            for	row := 0 to (Self.RowCount - 1) do
                                begin
                                    sumRowHeights := sumRowHeights + Self.RowHeights[row];
                                end;

                        //add the number of rows + 1 to the row heights sum
                            gridHeight := sumRowHeights + (Self.RowCount + 1 + borderAdjustment());

                    //assign to grid
                        Self.Height := gridHeight;
                end;

            procedure TStringGridHelper.minWidth();
                var
                    col, gridWidth, sumColWidths : integer;
                begin
                    //grid width
                        //calculate the sum of the col widths
                            sumColWidths := 0;
                            for	col := 0 to (Self.ColCount - 1)	do
                                begin
                                    sumColWidths := sumColWidths + Self.ColWidths[col];
                                end;

                        //add the number of cols + 1 to the col widths sum
                            gridWidth := sumColWidths + (Self.ColCount + 1 + borderAdjustment);

                    //assign to grid
                        Self.Width 	:= gridWidth;
                end;

            procedure TStringGridHelper.minSize();
                begin
                    minHeight();
                    minWidth();
                end;

end.
