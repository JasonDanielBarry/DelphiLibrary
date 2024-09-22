object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 615
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  inline Graphic2D1: TGraphic2D
    Left = 0
    Top = 0
    Width = 1002
    Height = 615
    Align = alClient
    TabOrder = 0
    object SkPaintBoxGraphic: TSkPaintBox
      Left = 0
      Top = 50
      Width = 1002
      Height = 565
      Align = alClient
      ExplicitLeft = 624
      ExplicitTop = 288
      ExplicitWidth = 50
      ExplicitHeight = 50
    end
    object GridPanelGraphicControls: TGridPanel
      Left = 0
      Top = 0
      Width = 1002
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
          Control = Graphic2D1.SpeedButtonZoomIn
          Row = 0
        end
        item
          Column = 1
          Control = Graphic2D1.SpeedButtonZoomOut
          Row = 0
        end
        item
          Column = 2
          Control = Graphic2D1.SpeedButtonZoomExtents
          Row = 0
        end
        item
          Column = 3
          Control = Graphic2D1.SpeedButtonShiftLeft
          Row = 0
        end
        item
          Column = 4
          Control = Graphic2D1.SpeedButtonShiftRight
          Row = 0
        end
        item
          Column = 5
          Control = Graphic2D1.SpeedButtonShiftUp
          Row = 0
        end
        item
          Column = 6
          Control = Graphic2D1.SpeedButtonShiftDown
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 1
      object SpeedButtonZoomIn: TSpeedButton
        Left = 827
        Top = 0
        Width = 25
        Height = 25
        Align = alRight
        Caption = '+'
        ExplicitLeft = 911
      end
      object SpeedButtonZoomOut: TSpeedButton
        Left = 852
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
        Left = 877
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
        Left = 902
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
        Left = 927
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
        Left = 952
        Top = 0
        Width = 25
        Height = 25
        Align = alClient
        Caption = '/\'
        ExplicitLeft = 1028
        ExplicitTop = -6
      end
      object SpeedButtonShiftDown: TSpeedButton
        Left = 977
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
end
