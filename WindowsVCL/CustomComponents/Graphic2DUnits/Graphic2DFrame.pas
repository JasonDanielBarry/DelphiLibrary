unit Graphic2DFrame;

interface

    uses
      Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, system.Types, system.UITypes,
      Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia,
      Vcl.Buttons, Vcl.ExtCtrls, Vcl.Skia,
      GeometryTypes,
      DrawingAxisConversionClass,
      SkiaDrawingClass,
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
    SpeedButtonUpdateGeometry: TSpeedButton;
            //events
                procedure SkPaintBoxGraphicDraw(ASender         : TObject;
                                                const ACanvas   : ISkCanvas;
                                                const ADest     : TRectF;
                                                const AOpacity  : Single    );
                procedure SpeedButtonZoomExtentsClick(Sender: TObject);
    procedure SpeedButtonUpdateGeometryClick(Sender: TObject);
            private
                var
                    skiaGeomDrawer                  : TSkiaGeomDrawer;
                    axisConverter                   : TDrawingAxisConverter;
                    onGraphicUpdateGeometryEvent    : TGraphicUpdateGeometryEvent;
            protected
                //drawing procedure
                    procedure preDrawGraphic(const canvasIn : ISkCanvas); virtual;
            public
                //constructor
                    constructor Create(AOwner : TComponent); override;
                //destructor
                    destructor destroy(); override;
                //accessors
                    function getOnGraphicUpdateGeometryEvent() : TGraphicUpdateGeometryEvent;
                //modifiers
                    procedure setOnGraphicUpdateGeometryEvent(const graphicDrawEventIn : TGraphicUpdateGeometryEvent);
                //redraw the graphic
                    procedure redrawGraphic();
                    procedure updateGeometry();
                //zooming methods
                    procedure zoomAll();
        end;



implementation

{$R *.dfm}

    //events
        procedure TCustomGraphic2D.SkPaintBoxGraphicDraw(   ASender         : TObject;
                                                            const ACanvas   : ISkCanvas;
                                                            const ADest     : TRectF;
                                                            const AOpacity  : Single    );
            begin
                preDrawGraphic( ACanvas );

                skiaGeomDrawer.drawAllGeometry( ACanvas, axisConverter );
            end;

        procedure TCustomGraphic2D.SpeedButtonUpdateGeometryClick(Sender: TObject);
            begin
                updateGeometry();
            end;

        procedure TCustomGraphic2D.SpeedButtonZoomExtentsClick(Sender: TObject);
            begin
                zoomAll();
            end;

    //protected
        //drawing procedure
            procedure TCustomGraphic2D.preDrawGraphic(const canvasIn : ISkCanvas);
                var
                    paint : ISkPaint;
                begin
                    //make sure canvas is clear
                        canvasIn.Clear( TAlphaColors.Null );

                    //draw a border around the paintbox edge
                        paint       := TSkPaint.Create( TSkPaintStyle.Stroke );
                        paint.Color := TAlphaColors.Silver;

                        canvasIn.DrawRect(
                                            RectF(0, 0, SkPaintBoxGraphic.Width - 1, SkPaintBoxGraphic.Height - 1),
                                            paint
                                         );

                    //give axis converter canvas dimensions
                        axisConverter.setCanvasRegion(SkPaintBoxGraphic.Height, SkPaintBoxGraphic.Width);
                end;

    //public
        //constructor
            constructor TCustomGraphic2D.Create(AOwner : TComponent);
                begin
                    inherited create(AOwner);

                    axisConverter := TDrawingAxisConverter.create();
                    skiaGeomDrawer := TSkiaGeomDrawer.create();

                    updateGeometry();
                    redrawGraphic();
                end;

        //destructor
            destructor TCustomGraphic2D.destroy();
                begin
                    FreeAndNil(axisConverter);

                    inherited Destroy();
                end;

        //accessors
            function TCustomGraphic2D.getOnGraphicUpdateGeometryEvent() : TGraphicUpdateGeometryEvent;
                begin
                    result := onGraphicUpdateGeometryEvent;
                end;

        //modifiers
            procedure TCustomGraphic2D.setOnGraphicUpdateGeometryEvent(const graphicDrawEventIn : TGraphicUpdateGeometryEvent);
                begin
                    onGraphicUpdateGeometryEvent := graphicDrawEventIn;
                end;

        //redraw the graphic
            procedure TCustomGraphic2D.redrawGraphic();
                begin
                    SkPaintBoxGraphic.Redraw();
                end;

            procedure TCustomGraphic2D.updateGeometry();
                begin
                    skiaGeomDrawer.resetDrawingGeometry();

                    if ( Assigned(onGraphicUpdateGeometryEvent) ) then
                        onGraphicUpdateGeometryEvent( self, skiaGeomDrawer );
                end;

        //zooming methods
            procedure TCustomGraphic2D.zoomAll();
                var
                    newDrawingRegion : TGeomBox;
                begin
                    newDrawingRegion := skiaGeomDrawer.determineGeomBoundingBox();

                    axisConverter.setDrawingRegion( 5, newDrawingRegion );

                    redrawGraphic();
                end;

end.
