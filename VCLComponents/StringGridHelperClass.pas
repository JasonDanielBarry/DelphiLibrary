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
                //test if a row is empty
                    function rowIsEmpty(rowIndexIn : integer) : boolean;
            public
                //row deletion
                    //clear a row's content
                        procedure clearRow(rowIndexIn : integer);
                    //delete a grid row
                        procedure deleteRow(rowIndexIn : integer);
                    //delete an empty row
                        procedure deleteEmptyRow(rowIndexIn : integer);
                    //delete all empty rows
                        procedure deleteAllEmptyRows();
                //row insertion
                    //add row
                        procedure addRow();
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
                                cells[colIn, rowIn].ToDouble;
                                cellIsDoubleOut := True;
                        except
                            //if conversion to double fails return error message
                                cellIsDoubleOut := False;
                        end
                    else
                        cellIsDoubleOut := False;

                    result := cellIsDoubleOut;                
                end;

        //test if a row is empty
            function TStringGridHelper.rowIsEmpty(rowIndexIn : integer) : boolean;
                var
                    colIndex : integer;
                begin
                    for colIndex := 0 to (ColCount - 1) do
                        begin
                            result := cells[colIndex, rowIndexIn].IsEmpty;

                            if (result = false) then
                                break;
                        end;
                end;

    //public
        //row deletion
            //clear a row's content
                procedure TStringGridHelper.clearRow(rowIndexIn : integer);
                    var
                        colIndex : integer;
                    begin
                        for colIndex := 0 to (ColCount - 1) do
                            cells[colIndex, rowIndexIn] := '';
                    end;

            //delete a grid row
                procedure TStringGridHelper.deleteRow(rowIndexIn : integer);
                    var
                        row, col : integer;
                    begin
                        if (rowIndexIn < rowCount) then
                            begin
                                clearRow(rowIndexIn);

                                for row := rowIndexIn to (Self.RowCount - 2) do
                                    for col := 0 to (Self.ColCount - 1) do
                                        begin
                                            //row above accepts row below's contents
                                                Self.cells[col, row] := Self.cells[col, row + 1];
                                        end;

                                //shorten the row count by 1
                                    Self.RowCount := Self.RowCount - 1;
                            end;

                        self.minSize();
                    end;
    
            //delete an empty row
                procedure TStringGridHelper.deleteEmptyRow(rowIndexIn : integer);
                    begin
                        if (rowIsEmpty(rowIndexIn)) then
                            deleteRow(rowIndexIn);
                    end;

            //delete all empty rows
                procedure TStringGridHelper.deleteAllEmptyRows();
                    var
                        rowIndex : integer;
                    begin
                        for rowIndex := (RowCount - 1) downto 0 do
                            if (rowIndex < rowCount) then
                                deleteEmptyRow(rowIndex);
                    end;

        //row insertion
            //add row
                procedure TStringGridHelper.addRow();
                    begin
                        RowCount := RowCount + 1;
                    end;

        //test if a cell's value is a double and clear it if it is not
            function TStringGridHelper.isCellDouble(colIn, rowIn : integer) : boolean;
                var
                    cellIsDoubleOut : boolean;
                begin
                    cellIsDoubleOut := checkCellIsDouble(colIn, rowIn);

                    if ( (cellIsDoubleOut = False) AND (Cells[colIn, rowIn] <> '') ) then
                        begin
                            //if conversion to double fails return error message
                                Application.MessageBox('Value entered is not real number', 'Invalid Input', MB_OK);
                                cellIsDoubleOut := False;
                                cells[colIn, rowIn] := '';
                        end;

                    result := cellIsDoubleOut;
                end;

        //get the value of a cell as a double
            function TStringGridHelper.cellToDouble(colIn, rowIn : integer) : double;
                begin
                    if (checkCellIsDouble(colIn, rowIn) = True) then
                        result := cells[colIn, rowIn].ToDouble()
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
