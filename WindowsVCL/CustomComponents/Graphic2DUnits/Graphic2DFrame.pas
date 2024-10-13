unit Graphic2DFrame;

interface

    uses
      Winapi.Windows, Winapi.Messages,
      System.SysUtils, System.Variants, System.Classes, system.Types, system.UITypes, system.Threading,
      Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Skia,
      Vcl.Buttons, Vcl.ExtCtrls, Vcl.Skia,
      GeometryTypes,
      DrawingAxisConversionClass,
      SkiaDrawingClass,
      Graphic2DTypes, Vcl.StdCtrls;

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
    ComboBoxZoomPercent: TComboBox;
            //events
                procedure SkPaintBoxGraphicDraw(ASender         : TObject;
                                                const ACanvas   : ISkCanvas;
                                                const ADest     : TRectF;
                                                const AOpacity  : Single    );
                procedure SpeedButtonZoomExtentsClick(Sender: TObject);
                procedure SpeedButtonUpdateGeometryClick(Sender: TObject);
                procedure SpeedButtonZoomInClick(Sender: TObject);
                procedure SpeedButtonZoomOutClick(Sender: TObject);
                procedure ComboBoxZoomPercentChange(Sender: TObject);
            private
                var
                    skiaGeomDrawer                  : TSkiaGeomDrawer;
                    axisConverter                   : TDrawingAxisConverter;
                    onGraphicUpdateGeometryEvent    : TGraphicUpdateGeometryEvent;
            protected
                //drawing procedure
                    procedure preDrawGraphic(const canvasIn : ISkCanvas); virtual;
                    procedure postDrawGraphic(const canvasIn : ISkCanvas); virtual;
                //zooming methods
                    procedure zoomIn(const zoomPercentageIn : double);
                    procedure zoomOut(const zoomPercentageIn : double);
                    procedure setZoom(const zoomPercentageIn : double);
                    procedure resetZoom();
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

        procedure TCustomGraphic2D.SpeedButtonZoomInClick(Sender: TObject);
            begin
                zoomIn(10);
            end;

        procedure TCustomGraphic2D.SpeedButtonZoomOutClick(Sender: TObject);
            begin
                zoomOut(10);
            end;

    //protected
        //drawing procedure
            procedure TCustomGraphic2D.preDrawGraphic(const canvasIn : ISkCanvas);
                var
                    currentZoomPercentage   : double;
                    paint                   : ISkPaint;
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

                        axisConverter.setDrawingSpaceRatioOneToOne();

                    currentZoomPercentage := axisConverter.getCurrentZoomPercentage();
                    ComboBoxZoomPercent.Text := FloatToStrF( currentZoomPercentage, ffNumber, 5, 0 );
                end;

            procedure TCustomGraphic2D.postDrawGraphic(const canvasIn : ISkCanvas);
                begin
                    //do nothing here
                end;

        //zooming methods
            procedure TCustomGraphic2D.zoomIn(const zoomPercentageIn : double);
                begin
                    axisConverter.zoomIn( zoomPercentageIn );

                    redrawGraphic();
                end;

            procedure TCustomGraphic2D.zoomOut(const zoomPercentageIn : double);
                begin
                    axisConverter.zoomOut( zoomPercentageIn );

                    redrawGraphic();
                end;

            procedure TCustomGraphic2D.setZoom(const zoomPercentageIn : double);
                begin
                    axisConverter.setZoom( zoomPercentageIn );

                    redrawGraphic();
                end;

            procedure TCustomGraphic2D.resetZoom();
                begin
                    //make the drawing boundary the drawing region
                        axisConverter.resetDrawingRegionToDrawingBoundary();

                    redrawGraphic();
                end;

    //public
        //constructor
            procedure TCustomGraphic2D.ComboBoxZoomPercentChange(Sender: TObject);
                var
                    newZoomPercent : double;
                begin
                    try
                        newZoomPercent := StrToFloat( ComboBoxZoomPercent.Text );
                    except
                        newZoomPercent := 1;
                    end;

                    setZoom( newZoomPercent );
                end;

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
                var
                    newDrawingBoundary : TGeomBox;
                begin
                    //reset the stored geometry
                        skiaGeomDrawer.resetDrawingGeometry();

                    //update the skiaGeomDrawer geometry
                        if ( Assigned(onGraphicUpdateGeometryEvent) ) then
                            onGraphicUpdateGeometryEvent( self, skiaGeomDrawer );

                    //determine the geometry group boundary
                        newDrawingBoundary := skiaGeomDrawer.determineGeomBoundingBox();

                    //store the group boundary in the axis converter for quick access
                        axisConverter.setDrawingBoundary( newDrawingBoundary );
                end;

        //zooming methods
            procedure TCustomGraphic2D.zoomAll();
                begin
                    resetZoom();
                end;

end.
