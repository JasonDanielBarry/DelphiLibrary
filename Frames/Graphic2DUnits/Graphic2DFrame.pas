unit Graphic2DFrame;

interface

    uses
      Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, system.Types, system.UITypes,
      Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia,
      Vcl.Buttons, Vcl.ExtCtrls, Vcl.Skia,
      DrawingAxisConversionClass,
      Graphic2DTypes;

    type
        TCustomGraphic2D = class(TFrame)
            SkPaintBoxGraphic: TSkPaintBox;
            GridPanelGraphicControls: TGridPanel;
            SpeedButtonZoomIn: TSpeedButton;
            SpeedButtonZoomOut: TSpeedButton;
            SpeedButtonZoomExtents: TSpeedButton;
            SpeedButtonShiftLeft: TSpeedButton;
            SpeedButtonShiftRight: TSpeedButton;
            SpeedButtonShiftUp: TSpeedButton;
            SpeedButtonShiftDown: TSpeedButton;
            procedure SkPaintBoxGraphicDraw(ASender         : TObject;
                                            const ACanvas   : ISkCanvas;
                                            const ADest     : TRectF;
                                            const AOpacity  : Single    );
            private
                var
                    axisConverter       : TDrawingAxisConverter;
                    onGraphicDrawEvent  : TGraphicDrawEvent;
                //drawing procedure
                    procedure preDrawGraphic(const canvasIn : ISkCanvas); virtual;
            protected
                //
            public
                constructor Create(AOwner : TComponent); override;
                destructor destroy(); override;
                procedure setOnGraphicDrawEvent(const graphicDrawEventIn : TGraphicDrawEvent);
                function getOnGraphicDrawEvent() : TGraphicDrawEvent;

        end;



implementation

{$R *.dfm}

    //private
        //drawing procedure
            procedure TCustomGraphic2D.preDrawGraphic(const canvasIn : ISkCanvas);
                begin
                    canvasIn.Clear(TAlphaColors.Null);

                    var paint : ISkPaint := TSkPaint.Create(TSkPaintStyle.Stroke);
                    paint.Color := TAlphaColors.Silver;

                    canvasIn.DrawRect(
                                        RectF(0, 0, SkPaintBoxGraphic.Width - 1, SkPaintBoxGraphic.Height - 1),
                                        paint
                                     );

                end;

    procedure TCustomGraphic2D.SkPaintBoxGraphicDraw(   ASender         : TObject;
                                                        const ACanvas   : ISkCanvas;
                                                        const ADest     : TRectF;
                                                        const AOpacity  : Single    );
        begin
            preDrawGraphic(ACanvas);


            if ( Assigned(onGraphicDrawEvent) ) then
                onGraphicDrawEvent(ASender, ACanvas, axisConverter);
        end;

    //public
        constructor TCustomGraphic2D.Create(AOwner : TComponent);
            begin
                inherited create(AOwner);

                axisConverter := TDrawingAxisConverter.create();
            end;

        destructor TCustomGraphic2D.destroy();
            begin
                FreeAndNil(axisConverter);

                inherited Destroy();
            end;

        procedure TCustomGraphic2D.setOnGraphicDrawEvent(const graphicDrawEventIn : TGraphicDrawEvent);
            begin
                onGraphicDrawEvent := graphicDrawEventIn;
            end;

        function TCustomGraphic2D.getOnGraphicDrawEvent() : TGraphicDrawEvent;
            begin
                result := onGraphicDrawEvent;
            end;

end.
