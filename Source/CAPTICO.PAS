PROGRAM BLOAD_CGA;

USES CRT,GRAPH,dos,Mouse;

Type EcranVGA=ARRAY[0..38399] OF BYTE;
     _iconeHeader=RECORD
                    x1,y1,l,h,der:WORD;
                  END;

CONST blocR=1;
      blocV=2;
      blocB=4;
      blocL=8;

VAR Nom,
    cheminImage,defchIm,defChIc,
    cheminIcone :STRING;
    Carte,Mode  :INTEGER;
    bloc:word;
    adrEcran:ecranVGA ABSOLUTE $a000:0000;
    imagePtr:POINTER;
    rouge,vert,bleu,lum:^ecranVGA;
    largeur,hauteur:WORD;

    ptrIcone:^BYTE;
    tailleIcone:WORD;
    iconeheader:^_iconeheader;

TYPE Filespec = STRING[40];

{=========================  DEBUT DES PROCEDURES =========================}


PROCEDURE SetBloc(b:BYTE);
BEGIN
  PORT[$3C4]:=$02;
  PORT[$3C5]:=b;
END;

PROCEDURE PutScreen;
BEGIN
  SetBloc(blocr);
  Move(rouge^,adrEcran,38400);
  SetBloc(blocv);
  Move(vert^,adrEcran,38400);
  SetBloc(blocb);
  Move(bleu^,adrEcran,38400);
  SetBloc(blocl);
  Move(lum^,adrEcran,38400);
END;

PROCEDURE BLOAD(Nom:STRING;bloc:BYTE;VAR ptr:ecranVga);
VAR a:CHAR;
    Binfile:FILE OF Byte;
    Segment,Offset,Longueur:Integer;
    i:WORD;
    Octet:Byte;
    r:REGISTERS;
BEGIN
  nom:=nom+chr(0);
  R.ds:=seg(nom);
  r.dx:=ofs(nom)+1;
  r.ah:=$3d;
  r.al:=$02;
  intr($21,r);
  r.bx:=r.ax;
  PORT[$3C4]:=$02;
  PORT[$3C5]:=bloc;
  r.ds:=$a000;
  r.dx:=$0000;
  r.ah:=$3f;
  r.cx:=7;
  intr($21,r);
  r.ds:=SEG(ptr);
  r.dx:=OFS(ptr);
  r.ah:=$3f;
  r.cx:=28000;
  intr($21,r);
END;


PROCEDURE LoadImageBasic;
VAR nom:STRING;
    r:CHAR;
BEGIN
  ClrScr;
  nom:='';
  Writeln;Writeln('===========================');
  Writeln(' Type de l''image :');
  Writeln('   1 : CGA');
  Writeln('   2 : EGA');
  Writeln('   3 : VGA');
  r:=#0;
  REPEAT r:=ReadKey UNTIL r IN ['1','2','3'];
  CASE r OF
    '1' : nom:='CGA';
    '2' : nom:='EGA';
    '3' : nom:='VGA';
  END;
  Clrscr;
  TextColor(black+blink);TextBackGround(red);
  GotoXY(19,12);Writeln('  Chargement de l''image ',nom,' en cours ...  ');
  TextColor(lightGray);
  Bload('b:\image\cpicb0.'+nom,blocr,rouge^);
  Bload('b:\image\cpicb1.'+nom,blocv,vert^);
  Bload('b:\image\cpicb2.'+nom,blocb,bleu^);
  Bload('b:\image\cpicb3.'+nom,blocl,lum^);
END;





PROCEDURE SauveIcone;
VAR nom:STRING;
    f  :FILE;
BEGIN
  ClrScr;
  Write('Nom de l''icone (sans .ICO) : ');
  Readln(nom);
  IF nom[0]>#8 THEN nom[0]:=#8;
  ClrScr;
  TextColor(black+blink);TextBackGround(red);
  GotoXY(15,12);Writeln('  Sauvegarde de l''icone ',nom,' en cours ...  ');
  TextColor(lightGray);
  nom:='b:\image\'+nom+'.ICO';
  Assign(f,nom);
  Rewrite(f,1);
  BlockWrite(f,largeur,2);
  BlockWrite(f,hauteur,2);
  BlockWrite(f,ptrIcone^,tailleIcone);
  Close(f);
END;

PROCEDURE AfficheImage;
VAR sortir:BOOLEAN;
BEGIN
  SetGraphMode(mode);
  PutScreen;
  REPEAT UNTIL ReadKey<>'';
  TextMode(lastMode);
END;

PROCEDURE Capture;
VAR x,y,x1,y1,x2,y2:INTEGER;
    bout:BYTE;
BEGIN
  SetGraphMode(mode);
  PutScreen;
  ShowMouse;
  REPEAT Getmouse(x1,y1,bout) UNTIL bout=1;
  SetWriteMode(XorPut);
  rectangle(x1,y1,x1,y1);x:=x1;y:=y1;
  REPEAT
    GetMouse(x2,y2,bout);
    IF (x2<>x) OR (y2<>y) THEN BEGIN
      HideMouse;
      rectangle(x1,y1,x,y);x:=x2;y:=y2;
      rectangle(x1,y1,x2,y2);
      ShowMouse;
    END;
  UNTIL bout=0;
  rectangle(x1,y1,x2,y2);
  IF ptrIcone<>NIL THEN FreeMem(ptrIcone,tailleIcone);
  tailleIcone:=ImageSize(x1,y1,x2,y2);
  GetMem(ptrIcone,tailleIcone);
  GetImage(x1,y1,x2,y2,ptrIcone^);
  IF x2>x1 THEN largeur:=x2-x1 ELSE largeur:=x1-x2;
  IF y2>y1 THEN hauteur:=y2-y1 ELSE hauteur:=y1-y2;
END;


PROCEDURE ChoixDirectory;
BEGIN
  ClrScr;
  Write('Chemin d''accŠs … l''image [ d‚faut : ',defchim,' ] :');
  Readln(CheminImage);Writeln;
  IF cheminImage='' THEN cheminImage:=defchim;
  Write('Chemin d''accŠs aux icones [ d‚faut : ',defchic,' ] :');
  Readln(CheminIcone);
  IF cheminIcone='' THEN cheminIcone:=defchic;
END;




PROCEDURE Menu;
VAR rep:CHAR;
BEGIN
  REPEAT
    TextMode(lastMode);
    TextBackGround(black);
    TextColor(lightGray);
    Clrscr;TextColor(yellow+blink);TextBackGround(yellow);
    Writeln('===========================================');
    Writeln('==           MENU PRICIPAL               ==');
    Writeln('===========================================');
    Textcolor(lightGray);textBackGround(Black);
    Writeln;
    Writeln('   1)  Capturer Icone');Writeln;
    Writeln('   2)  SauverIcone');Writeln;
    Writeln('   3)  Afficher Image');Writeln;
    Writeln('   4)  Charger Image capturer');Writeln;
    Writeln('   5)  Changer r‚pertoire');Writeln;
    TextColor(Magenta);Writeln('[ESC]  Quiter');Writeln;TextColor(White);
    Write('       Votre Choix : ');
    rep:=ReadKey;
    CASE rep OF
      '1' : Capture;
      '2' : SauveIcone;
      '3' : afficheImage;
      '4' : LoadImageBasic;
      '5' : ChoixDirectory;
    END;
  UNTIL rep=#27;
END;

{*********************** Programme Principal *************************}

BEGIN
  cheminImage:='B:\IMAGE';defchim:=cheminImage;
  cheminIcone:='B:\IMAGE';defchic:=cheminIcone;
  GetMem(rouge,38400);
  GetMem(vert,38400);
  GetMem(bleu,38400);
  GetMem(lum,38400);
  ptrIcone:=NIL;
  Carte := vga;mode:=vGAmed;
  CLRSCR;
  INITGRAPH(Carte,Mode,'C:\');
  InitMouse;;
  MENU;
END.
