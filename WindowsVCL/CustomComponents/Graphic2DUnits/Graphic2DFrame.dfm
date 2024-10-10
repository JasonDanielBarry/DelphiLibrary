object CustomGraphic2D: TCustomGraphic2D
  Left = 0
  Top = 0
  Width = 1231
  Height = 736
  TabOrder = 0
  object SkPaintBoxGraphic: TSkPaintBox
    Left = 0
    Top = 25
    Width = 1231
    Height = 711
    Align = alClient
    OnDraw = SkPaintBoxGraphicDraw
    ExplicitTop = 31
  end
  object GridPanelGraphicControls: TGridPanel
    Left = 0
    Top = 0
    Width = 1231
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 25.000000000000000000
      end
      item
        SizeStyle = ssAbsolute
        Value = 45.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = SpeedButtonZoomIn
        Row = 0
      end
      item
        Column = 1
        Control = SpeedButtonZoomOut
        Row = 0
      end
      item
        Column = 2
        Control = SpeedButtonZoomExtents
        Row = 0
      end
      item
        Column = 4
        Control = SpeedButtonShiftLeft
        Row = 0
      end
      item
        Column = 5
        Control = SpeedButtonShiftRight
        Row = 0
      end
      item
        Column = 6
        Control = SpeedButtonShiftUp
        Row = 0
      end
      item
        Column = 7
        Control = SpeedButtonShiftDown
        Row = 0
      end
      item
        Column = 3
        Control = SpeedButtonUpdateGeometry
        Row = 0
      end
      item
        Column = 8
        Control = ComboBoxZoomPercent
        Row = 0
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object SpeedButtonZoomIn: TSpeedButton
      Left = 986
      Top = 0
      Width = 25
      Height = 25
      Align = alRight
      Caption = '+'
      Flat = True
      OnClick = SpeedButtonZoomInClick
      ExplicitLeft = 911
    end
    object SpeedButtonZoomOut: TSpeedButton
      Left = 1011
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '-'
      Flat = True
      OnClick = SpeedButtonZoomOutClick
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonZoomExtents: TSpeedButton
      Left = 1036
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = 'E'
      Flat = True
      OnClick = SpeedButtonZoomExtentsClick
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftLeft: TSpeedButton
      Left = 1086
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '<'
      Flat = True
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftRight: TSpeedButton
      Left = 1111
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '>'
      Flat = True
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftUp: TSpeedButton
      Left = 1136
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '/\'
      Flat = True
      ExplicitLeft = 1028
      ExplicitTop = -6
    end
    object SpeedButtonShiftDown: TSpeedButton
      Left = 1161
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '\/'
      Flat = True
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonUpdateGeometry: TSpeedButton
      Left = 1061
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = 'U'
      Flat = True
      OnClick = SpeedButtonUpdateGeometryClick
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object ComboBoxZoomPercent: TComboBox
      Left = 1186
      Top = 0
      Width = 45
      Height = 23
      Align = alClient
      TabOrder = 0
      Text = '100'
      OnChange = ComboBoxZoomPercentChange
      Items.Strings = (
        '10'
        '20'
        '25'
        '50'
        '75'
        '100'
        '125'
        '150'
        '200'
        '250'
        '300')
    end
  end
end
