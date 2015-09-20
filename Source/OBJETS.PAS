{========================================================================
 =                                                                      =
 =              DEFINITION DE NOUVEAUX OBJETS POUR LSFWIN               =
 =                                                                      =
 =                Programmation en Turbo PASCAL 5.5                     =
 =                                                                      =
 =                                                 (c) LIONSOFT 1992    =
 ========================================================================}

USES LsfWin;

TYPE  objetDepClavierPtr=^objetDepClavier;
      objetDepClavier=OBJECT(objetDep)
        PROCEDURE EnvoieCode(carac:CHAR);VIRTUAL;
      END;


      saisieObjPtr=^saisieObj;
      saisieObj=OBJECT(objetDepClavier)
        texte      :STRING;
        nbCarMaxi,
        nbCarReel,
        largeurAff,
        position,
        PositionCurseur,
        coulFond,
        coulCar    :BYTE;
        boite      :boiteObj;
        codeEtendu :BOOLEAN;
        CONSTRUCTOR Creer(xr1,yr1:INTEGER;nbCarAff,nbCarTot:BYTE;textInit:STRING;
                            coulF,coulC:BYTE);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
        PROCEDURE   EnvoieCode(carac:CHAR);         VIRTUAL;
      END;




                        {=========== ObjetDepClavier ================}
PROCEDURE ObjetDepClavier.EnvoieCode(carac:CHAR);
BEGIN END;

                        {=========== SaisieObj ======================}
CONSTRUCTOR saisieObj.Creer(xr1,yr1:INTEGER;nbCarAff,nbCarTot:BYTE;textInit:STRING;
                            coulF,coulC:BYTE);
BEGIN
  x1:=xr1;y1:=yr1;x2:=xr1+8*(nbCarAff+2);y2:=yr1+15;
  boite.Creer(x1,y1,x2,y2,coulF,rienobjdep);
  boite.possesseur:=possesseur;
  texte:=textInit;
  position:=20;
  largeurAff:=nbCarAff;
  nbCarMaxi:=nbCarTot;
  nbCarReel:=Length(textInit);
  coulFond:=coulF;
  coulCar:=coulC;
  positionCurseur:=1;
  codeEtendu:=FALSE;
END;

DESTRUCTOR  saisieObj.Detruire;
BEGIN END;

PROCEDURE   saisieObj.Afficher;
VAR r:STRING;
BEGIN
  boite.possesseur:=possesseur;
  hideMouse;
  boite.afficher;
  SetTextStyle(defaultFont,horizDir,1);
  SetTextJustify(LeftText,topText);
  r:=Copy(texte,position,largeurAff);
  SetColor(coulCar);
  OutTextXY(possesseur^.x1+x1+8,possesseur^.y1+y1+4,r);
  showMouse;
END;

PROCEDURE   saisieObj.Gerer(xm,ym:INTEGER);
VAR deca,milieu,
    bout:BYTE;
    r:STRING;
    change:BOOLEAN;
BEGIN
  change:=FALSE;
  GetMouse(xm,ym,bout);
  deca:=xm-(x1+possesseur^.x1);
  milieu:=(x2-x1) DIV 2;
  IF deca<8  THEN IF position>1 THEN BEGIN Dec(position);change:=TRUE END;
  IF deca>=milieu*2-8 THEN IF position<nbCarReel-largeurAff+1
                              THEN BEGIN Inc(position);change:=TRUE END;
  IF NOT change THEN Exit;
  HideMouse;
  SetFillStyle(solidFill,coulFond);
  Bar(possesseur^.x1+x1+2,possesseur^.y1+y1+2,possesseur^.x1+x2-2,
      possesseur^.y1+y2-2);
  SetTextStyle(defaultFont,horizDir,1);
  SetTextJustify(LeftText,topText);
  r:=Copy(texte,position,largeurAff);
  SetColor(coulCar);
  OutTextXY(possesseur^.x1+x1+8,possesseur^.y1+y1+4,r);
  showMouse;
  possesseur^.objetClavier:=@SELF;
END;

PROCEDURE saisieObj.EnvoieCode(carac:CHAR);
VAR fin:BOOLEAN;
BEGIN
  fin:=FALSE;
  IF carac=#0 THEN BEGIN CodeEtendu:=TRUE;fin:=TRUE; END;
  IF fin THEN EXIT;
  IF codeEtendu OR (carac=#8) THEN
  BEGIN
    CASE carac OF
         #77 : BEGIN
                 IF positionCurseur<nbCarReel THEN Inc(positionCurseur);
                 position:=positionCurseur;
                 Afficher;
               END;
         #75 : BEGIN
                 IF positionCurseur>1 THEN Dec(positionCurseur);
                 position:=positionCurseur;
                 Afficher;
               END;
         #8  : BEGIN
                 IF positionCurseur=1 THEN EXIT;
                 Delete(texte,positionCurseur-1,1);
                 Dec(nbCarReel);
                 Dec(positionCurseur);
                 Afficher;
               END;
         #83 : BEGIN
                 Delete(texte,positionCurseur,1);
                 Dec(nbCarReel);
                 Afficher;
               END;
    END;
    CodeEtendu:=FALSE;
    fin:=TRUE;
  END;
  IF fin THEN EXIT;
  IF carac<Chr(32) THEN Exit;
  texte[positionCurseur]:=carac;
  IF positionCurseur<nbCarReel THEN Inc(positionCurseur);
  IF positionCurseur-position>largeurAff THEN Inc(position);
  Afficher;
END;
