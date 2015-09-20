{***************************************************}
{*                                                 *}
{*        UNITE pour la gestion de la souris       *}
{*                  et de l'ecran                  *}
{*      necessite la presence du driver souris     *}
{*            (c)  LIONSOFT 1990/1991              *}
{***************************************************}

UNIT mouse;
INTERFACE
USES Dos,Crt;

CONST gereMouse:BOOLEAN=TRUE;
      electronicCursor = 1;
      softwarCursor    = 0;
      LeftButton       = 0;
      CenterButton     = 1;
      RightButton      = 2;
      MouseDriverLoaded = TRUE;


VAR modeVideo:BYTE;
    regs:REGISTERS;

PROCEDURE InitMouse;                                                {*}
{ PROCEDURE Desactive;                                                { }
{PROCEDURE Reactive;                                                 { }
{PROCEDURE DefineTextCursor(cursor:BYTE;ET,OUexc:POINTER);           { }
{PROCEDURE DefineGraphCursor(decX,decY:INTEGER;definition:POINTER);  { }
{FUNCTION  nbPression(bouton:BYTE):WORD;}
PROCEDURE GetMouse(VAR xcoor,ycoor:INTEGER;VAR boutpres:BYTE);      {*}
             { boutpres : boutonG=1,boutonD=2 }
PROCEDURE PutMouse(x,y:INTEGER);                                    {*}
PROCEDURE WinMouse(xmin,ymin,xmax,ymax:INTEGER);                    {*}
PROCEDURE HideMouse;                                                {*}
PROCEDURE ShowMouse;                                                {*}
PROCEDURE MouseOff;                                                 {*}
PROCEDURE MouseOn;                                                  {*}


{------------------------------------------------------------------------}
IMPLEMENTATION

PROCEDURE InitMouse;
BEGIN
  WITH regs DO
  BEGIN
    ax:=0;
    intr($33,regs);
    ax:=1;
    intr($33,regs);
  END;
  gereMouse:=TRUE;
END;

PROCEDURE HideMouse;
BEGIN
  IF NOT gereMouse THEN EXIT;
  regs.ax:=2;
  intr($33,regs);
END;

PROCEDURE ShowMouse;
BEGIN
  IF NOT gereMouse THEN EXIT;
  regs.ax:=1;
  intr($33,regs);
END;

PROCEDURE PutMouse;
BEGIN
  IF NOT gereMouse THEN EXIT;
  regs.cx:=x;
  regs.dx:=y;
  regs.ax:=4;
  intr($33,regs);
END;

PROCEDURE WinMouse;
BEGIN
  IF NOT gereMouse THEN EXIT;
  regs.cx:=xmin;
  regs.dx:=xmax;
  regs.ax:=7;
  intr($33,regs);
  regs.cx:=ymin;
  regs.dx:=ymax;
  regs.ax:=8;
  intr($33,regs);
END;

PROCEDURE GetMouse;
BEGIN
  regs.ax:=3;
  intr($33,regs);
  xcoor:=regs.cx;
  ycoor:=regs.dx;
  boutpres:=regs.bx;
END;

PROCEDURE MouseOn;
BEGIN
  gereMouse:=TRUE;
END;

PROCEDURE MouseOff;
BEGIN
  gereMouse:=FALSE;
END;

END.
