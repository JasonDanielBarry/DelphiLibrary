unit Graphic2DComponent;

interface

    uses
        Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
        Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
        CustomComponentPanelClass,
        Graphic2DTypes,
        Graphic2DFrame;

    type
        TGraphic2D = class(TCustomComponentPanel)
            customGraphic : TCustomGraphic2D;
            private
                procedure setOnGraphicDrawEvent(const graphicDrawEventIn : TGraphicDrawEvent);
                function getOnGraphicDrawEvent() : TGraphicDrawEvent;
            public
                constructor Create(AOwner: TComponent); override;
                destructor Destroy; override;
            published
                property OnGraphicDraw : TGraphicDrawEvent read getOnGraphicDrawEvent write setOnGraphicDrawEvent;
        end;

implementation

    //private
        procedure TGraphic2D.setOnGraphicDrawEvent(const graphicDrawEventIn : TGraphicDrawEvent);
            begin
                customGraphic.setOnGraphicDrawEvent(graphicDrawEventIn);
            end;

        function TGraphic2D.getOnGraphicDrawEvent() : TGraphicDrawEvent;
            begin
                result := customGraphic.getOnGraphicDrawEvent();
            end;

    //public
        constructor TGraphic2D.Create(AOwner: TComponent);
            begin
                inherited create(AOwner);

                customGraphic := TCustomGraphic2D.create(Self);
                customGraphic.parent := self;
                customGraphic.Align := TAlign.alClient;
                customGraphic.Visible := True;
            end;

        destructor TGraphic2D.Destroy();
            begin
                FreeAndNil( customGraphic );

                inherited Destroy();
            end;

end.
