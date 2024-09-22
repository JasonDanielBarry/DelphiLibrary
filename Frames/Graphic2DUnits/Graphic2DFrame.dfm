object Graphic2D: TGraphic2D
  Left = 0
  Top = 0
  Width = 940
  Height = 589
  TabOrder = 0
  object SkPaintBoxGraphic: TSkPaintBox
    Left = 0
    Top = 25
    Width = 940
    Height = 564
    Align = alClient
    OnDraw = SkPaintBoxGraphicDraw
    ExplicitLeft = 624
    ExplicitTop = 288
    ExplicitWidth = 50
    ExplicitHeight = 50
  end
  object GridPanelGraphicControls: TGridPanel
    Left = 0
    Top = 0
    Width = 940
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
        Column = 3
        Control = SpeedButtonShiftLeft
        Row = 0
      end
      item
        Column = 4
        Control = SpeedButtonShiftRight
        Row = 0
      end
      item
        Column = 5
        Control = SpeedButtonShiftUp
        Row = 0
      end
      item
        Column = 6
        Control = SpeedButtonShiftDown
        Row = 0
      end>
    ParentColor = True
    RowCollection = <
      item
        Value = 100.000000000000000000
      end>
    TabOrder = 0
    object SpeedButtonZoomIn: TSpeedButton
      Left = 765
      Top = 0
      Width = 25
      Height = 25
      Align = alRight
      Caption = '+'
      ExplicitLeft = 911
    end
    object SpeedButtonZoomOut: TSpeedButton
      Left = 790
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '-'
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonZoomExtents: TSpeedButton
      Left = 815
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = 'E'
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftLeft: TSpeedButton
      Left = 840
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '<'
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftRight: TSpeedButton
      Left = 865
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '>'
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
    object SpeedButtonShiftUp: TSpeedButton
      Left = 890
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '/\'
      ExplicitLeft = 1028
      ExplicitTop = -6
    end
    object SpeedButtonShiftDown: TSpeedButton
      Left = 915
      Top = 0
      Width = 25
      Height = 25
      Align = alClient
      Caption = '\/'
      ExplicitLeft = 608
      ExplicitTop = 8
      ExplicitWidth = 23
      ExplicitHeight = 22
    end
  end
end
