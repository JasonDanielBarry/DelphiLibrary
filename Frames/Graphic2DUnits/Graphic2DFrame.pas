unit Graphic2DFrame;

interface

    uses
      Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, system.Types,
      Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia,
      Vcl.Buttons, Vcl.ExtCtrls, Vcl.Skia,
      DrawingAxisConversionClass,
      Graphic2DTypes;

    type
        [ComponentPlatformsAttribute(pidWin32 AND pidWin64)]
        TGraphic2D = class(TFrame)
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
                    procedure preDrawGraphic(); virtual;
            protected
                //
            public
                constructor Create(AOwner : TComponent); override;
                destructor destroy(); override;
        end;



implementation

{$R *.dfm}

    //private
        //drawing procedure
            procedure TGraphic2D.preDrawGraphic();
                begin


                end;

    procedure TGraphic2D.SkPaintBoxGraphicDraw( ASender         : TObject;
                                                const ACanvas   : ISkCanvas;
                                                const ADest     : TRectF;
                                                const AOpacity  : Single    );
        begin
            preDrawGraphic();

            if ( Assigned(onGraphicDrawEvent) ) then
                onGraphicDrawEvent(ASender, ACanvas, axisConverter);
        end;

    //public
        constructor TGraphic2D.Create(AOwner : TComponent);
            begin
                inherited create(AOwner);

                axisConverter := TDrawingAxisConverter.create();
            end;

        destructor TGraphic2D.destroy();
            begin
                FreeAndNil(axisConverter);

                inherited Destroy();
            end;

end.
