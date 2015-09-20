UNIT LSFWIN;
{==========================================================================
 ==                                                                      ==
 ==             LIONSOFT 1991 : LsfWin Version BetaTest  1.0             ==
 ==                                                                      ==
 ==       Interface graphique entierement POO (Turbo PASCAL 5.5)         ==
 ==                                                                      ==
 ==                     (p) & (c) LIONSOFT 1991                          ==
 ==========================================================================}

INTERFACE
USES Dos,Crt,Mouse,Graph;

{**************************************************************************}
{------------------- DEFINITION DES TYPES ET CONSTANTES -------------------}
{**************************************************************************}
TYPE  flecheTab=ARRAY [1..3] OF PointType;
      codeclavier=STRING[2];      { [1] = #0 si code ‚tendu sinon code touche
                                    [2] = code touche si [1]=#00
                                  }

CONST  LSFVER = 'v 1.00';

       NO_ERR       = 0;
       NIL_PTR_ERR  = 1;
       NB_OBJ_ERR   = 2;
       SYS_LOAD_ERR = 3;
       STAT_WIN_ERR = 4;

CONST  Black       :BYTE = 0;
       Blue        :BYTE = 1;
       Green       :BYTE = 2;
       Cyan        :BYTE = 3;
       Red         :BYTE = 4;
       Magenta     :BYTE = 5;
       Brown       :BYTE = 6;
       LightGray   :BYTE = 7;
       DarkGray    :BYTE = 8;
       LightBlue   :BYTE = 9;
       LightGreen  :BYTE = 10;
       LightCyan   :BYTE = 11;
       LightRed    :BYTE = 12;
       LightMagenta:BYTE= 13;
       Yellow      :BYTE = 14;
       White       :BYTE = 15;

       LSFinit     :BOOLEAN=FALSE;

       nbObjetVisible:WORD = 0;
       gestionObjetVisible : BOOLEAN = TRUE;

       OUI         =TRUE;
       NON         =FALSE;

       flecheH     :flecheTab=
         ( (x:4 ; y:0  ),
           (x:9 ; y:8  ),
           (x:-1 ; y:8 ));

       flecheB     :flecheTab=
         ( (x:0 ; y:0  ),
           (x:8 ; y:0  ),
           (x:4 ; y:8 ));

       flecheG     :flecheTab=
         ( (x:8  ; y:0  ),
           (x:0  ; y:4  ),
           (x:8  ; y:8 ));

       flecheD     :flecheTab=
         ( (x:0  ; y:0  ),
           (x:8 ; y:4  ),
           (x:0  ; y:8 ));

       TexteNormal   =0;
       TexteGrasD    =1;
       TexteGrasB    =2;
       TexteGras     =3;



       NoEvent       =0;
       MouseEvent    =1;
       KeyEvent      =2;

       MouseMoveEvent=1;
       L_PressedEvent=2;
       L_RelaxedEvent=4;
       C_PressedEvent=8;
       C_RelaxedEvent=16;
       R_PressedEvent=32;
       R_RelaxedEvent=64;

       KeyPressedEvent=1;
       KeyRelaxedEvent=2;

       blocagePremierPlan:BOOLEAN=FALSE;

       InsertActive      = 128;
       CapsLockPressed   = 64;
       NumLockPressed    = 32;
       ScrollLockPressed = 16;
       AltPressed        = 8;
       CtrlPressed       = 4;
       LeftShiftPressed  = 2;
       RightShiftPressed = 1;

       Alt               = #8;

       sysRequest:BOOLEAN=FALSE;


TYPE  STRING60=STRING[60];
      STRING40=STRING[40];
      STRING8 =STRING[8];


{**************************************************************************}
{**********************  DEFINITIONS DES OBJETS  **************************}
{**************************************************************************}
      coordonnee=OBJECT
        x1,y1,
        x2,y2    :INTEGER;
        typeObjet:BYTE;
      END;

      objetDepPtr=^objetDep;
      objetIndepPtr=^objetIndep;

      procObjIndepPtr=^procObjIndep;
      procObjIndep=PROCEDURE(objet:objetIndepPtr);



      procObjDepPtr=^procObjDep;
      procObjDep=PROCEDURE(objet:objetDepPtr);

      objetDep=OBJECT(coordonnee)
        possesseur:objetIndepPtr;
        actionner:procObjDep;  { POINTEUR DE PROCEDURE !! }
        codeTouche:codeclavier;
        DESTRUCTOR Detruire;
        FUNCTION  ZoneChoisie(xm,ym:INTEGER):BOOLEAN;
        PROCEDURE Afficher;              VIRTUAL;
        PROCEDURE Gerer(xm,ym:INTEGER);  VIRTUAL;
      END;


      objetIndep=OBJECT(coordonnee)
        x1sav,x2sav,y1sav,y2sav:INTEGER;       { coorddonnes si sortie d'ecr }
        visible,                               { TRUE si visible,sinon FALSE }
        actif       :BOOLEAN;                   { TRUE si 1er plan,sinon FALSE}
        bufferEcran :POINTER;
        actionner   :procObjIndep;    { POINTEUR DE PROCEDURE !! }
        objetClavierCourant:ObjetDepPtr;
        PROCEDURE SauveEcran;                VIRTUAL;
        PROCEDURE RestaureEcran;             VIRTUAL;
        PROCEDURE Afficher;                  VIRTUAL;
        PROCEDURE Cacher;                    VIRTUAL;
        PROCEDURE Activer;                   VIRTUAL;
        PROCEDURE Desactiver;                VIRTUAL;
        PROCEDURE Deplacer(xx,yy:INTEGER);   VIRTUAL;
        PROCEDURE Gerer(xm,ym:INTEGER);      VIRTUAL;
        FUNCTION  ZoneChoisie(xm,ym:INTEGER):BOOLEAN; VIRTUAL;
        PROCEDURE EvenementSouris(codeEvent:WORD;xm,ym:INTEGER;boutons:BYTE);
        PROCEDURE EvenementClavier(codetouche:codeclavier);VIRTUAL;
      END;

      boutonObjPtr=^boutonObj;
      boutonObj=OBJECT(objetDep)
        titre      :STRING40;
        tailleCar,
        couleurFond:BYTE;
        presser    :BOOLEAN;
        autoRepetition:BOOLEAN;
        CONSTRUCTOR Creer(xx1,yy1,xx2,yy2:INTEGER;autorep:BOOLEAN;
                          title:STRING40;taille,coulFond:BYTE;
                          ptrProc:procObjDep;keycode:codeclavier);
        DESTRUCTOR  Detruire;
        PROCEDURE Afficher;  VIRTUAL;
        PROCEDURE Gerer(xm,ym:INTEGER);  VIRTUAL;
        PROCEDURE Enfoncer;
        PROCEDURE Relacher;
      END;

      boiteObjPtr=^boiteObj;
      boiteObj=OBJECT(objetDep)
        couleurFond :BYTE;
        CONSTRUCTOR Creer(xx1,yy1,xx2,yy2:INTEGER;coulFond:BYTE;
                          ptrProc:procObjDep);
        DESTRUCTOR  Detruire;
        PROCEDURE Afficher;              VIRTUAL;
        PROCEDURE Gerer(xm,ym:INTEGER);  VIRTUAL;
      END;

      cadreObjPtr=^cadreObj;
      cadreObj=OBJECT(objetDep)
        titre:STRING40;
        CONSTRUCTOR Creer(xr1,yr1,xr2,yr2:INTEGER;title:STRING40;
                          ptrProc:procObjDep);
        DESTRUCTOR  Detruire;
        PROCEDURE Afficher;              VIRTUAL;
        PROCEDURE Gerer(xm,ym:INTEGER);  VIRTUAL;
      END;

      texteObjPtr=^texteObj;
      texteObj=OBJECT(objetDep)
        texte  :STRING;
        taille,
        couleur,
        fonteCarac,
        gras   :BYTE;
        CONSTRUCTOR Creer(xr1,yr1:INTEGER;text:STRING;fonte,coul,t,g:BYTE);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;             VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER); VIRTUAL;
      END;

      ascenceurVertiObjPtr=^ascenceurVertiObj;
      ascenceurVertiObj=OBJECT(objetDep)
        xFen,yFen,
        hauteur,
        position,
        valRealMaxi,           { <-- intervalle de reponse }
        tailleCourse:INTEGER;  { <-- du curseur en Pixel   }
        curseur,
        boutonHaut,
        BoutonBas   :boutonObj;
        boiteFond   :boiteObj;
        CONSTRUCTOR Creer(xr1,yr1,hauteurAscen,
                          tailleTrajet,maximumReel:INTEGER);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
        FUNCTION    GetPosition:INTEGER;            VIRTUAL;
        PROCEDURE   ChangeIntervalle(maxi:INTEGER); VIRTUAL;
      END;

      ascenceurHorizObjPtr=^ascenceurHorizObj;
      ascenceurHorizObj=OBJECT(objetDep)
        xFen,yFen,
        largeur,
        position,
        valRealMaxi,           { <-- intervalle de reponse }
        tailleCourse:INTEGER;  { <-- du curseur en Pixel   }
        curseur,
        boutonGauche,
        BoutonDroit   :boutonObj;
        boiteFond   :boiteObj;
        CONSTRUCTOR Creer(xr1,yr1,largeurAscen,
                          tailleTrajet,maximumReel:INTEGER);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
        FUNCTION    GetPosition:INTEGER;            VIRTUAL;
        PROCEDURE   ChangeIntervalle(maxi:INTEGER); VIRTUAL;
      END;

      iconeObjPtr=^iconeObj;
      iconeObj=OBJECT(objetDep)
        ptr:^BYTE;
        taille:WORD;
        path:STRING8;
        CONSTRUCTOR Creer(xr1,yr1:INTEGER;nom:String8;ptrProc:procObjDep;
                          keycode:codeclavier);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
      END;

      ligneObjPtr=^ligneobj;
      ligneObj=OBJECT(objetDep)
        dec1,dec2:INTEGER;
        style:BYTE;
        CONSTRUCTOR Creer(xr1,yr1,xr2,yr2:INTEGER;d1,d2:INTEGER);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
      END;

      saisieObjPtr=^saisieObj;
      saisieObj=OBJECT(objetDep)
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
                            coulF,coulC:BYTE;keycode:codeclavier);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;                       VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);           VIRTUAL;
        PROCEDURE   EnvoieCode(carac:CHAR);         VIRTUAL;
      END;



  {============================= OBJET INDEPENDANT ==========================}
      noeudPtr=^noeud;
      noeud=RECORD
        objet:objetDepPtr;
        suivant:noeudPtr;
      END;


      menuObjPtr=^menuObj;
      menuObj=OBJECT(objetIndep)
        listeOption  :noeudPtr;
        boutonFermeture,
        boutonTitre  :boutonObj;
        nbChoix      :BYTE;
        largeur      :BYTE;
        supprimable  :BOOLEAN;
        CONSTRUCTOR Creer(xx1,yy1:INTEGER;large:BYTE;title:STRING40);
        DESTRUCTOR  Detruire;
        PROCEDURE   Afficher;   VIRTUAL;
        PROCEDURE   Cacher;     VIRTUAL;
        PROCEDURE   Gerer(xm,ym:INTEGER);  VIRTUAL;
                                      {gere le clic sur tel ou tel choix }
        PROCEDURE   Ajouter(titre:STRING40;process:ProcObjDep;
                            rep:BOOLEAN;keycode:codeclavier);VIRTUAL;
        PROCEDURE   MetProcOption(numOption:BYTE;Process:ProcObjDep);
        PROCEDURE   Activer;               VIRTUAL;
        PROCEDURE   Desactiver;            VIRTUAL;
        PROCEDURE   EvenementClavier(keycode:codeclavier);VIRTUAL;
      END;

      fenetreObjPtr=^fenetreObj;
      fenetreObj=OBJECT(objetIndep)
         _y2,_y2sav:INTEGER;
         listeAjout     :noeudPtr;
         enIcone,
         gestionAjout   :BOOLEAN;
         boutonDroit,
         boutonGauche,
         boutonCentre,
         boutonIcone,
         boutonTitre,
         boutonFermeture:boutonObj;
         objetActif     :objetDepPtr;
         couleurFond    :BYTE;
         nbAjout        :BYTE;
         CONSTRUCTOR Creer(xx1,yy1,xx2,yy2:INTEGER;coulFond:BYTE;
                           title:STRING40);
         DESTRUCTOR  Detruire;
         PROCEDURE Afficher;              VIRTUAL;
         PROCEDURE Cacher;                VIRTUAL;
         PROCEDURE Gerer(xm,ym:INTEGER);  VIRTUAL;
         PROCEDURE Ajouter(p:objetDepPtr);VIRTUAL;
         PROCEDURE Activer;               VIRTUAL;
         PROCEDURE Desactiver;            VIRTUAL;
         PROCEDURE EvenementClavier(keycode:codeclavier);VIRTUAL;
      END;


      elementListeObjPtr=^elementListeObj;
      elementListeObj=RECORD
                        prec,
                        suiv :elementListeObjPtr;
                        objet:objetIndepPtr;
                      END;




{**************************************************************************}
{*********************  DEFINITIONS DES VARIABLES  ************************}
{**************************************************************************}

VAR Noir,
    Blanc,
    GrisFonce,
    GrisClair  :BYTE;

    ListeObjetVisible :elementListeObjPtr;
    LSFmenu:menuObj;
    fenetreFin,
    SauvegardeEnCours,
    ChargementEnCours,
    LSFcopyright:fenetreObj;

    datadirectory:STRING;

    driver,
    mode:INTEGER;

{**************************************************************************}
{*********************  DEFINITIONS DES METHODES  *************************}
{**************************************************************************}

                        {========== PROCEDURE FORWARD ===============}
PROCEDURE FondRelief(x1,y1,x2,y2:INTEGER;coul:BYTE);
PROCEDURE BordReliefHaut(x1,y1,x2,y2:INTEGER);
PROCEDURE BordReliefBas(x1,y1,x2,y2:INTEGER);
PROCEDURE Deplacement(VAR xx1,yy1,xx2,yy2:INTEGER);
PROCEDURE Beep;
PROCEDURE FlecheHaut(xr,yr:INTEGER;couleur:BYTE);
PROCEDURE FlecheBas(xr,yr:INTEGER;couleur:BYTE);
PROCEDURE FlecheGauche(xr,yr:INTEGER;couleur:BYTE);
PROCEDURE FlecheDroite(xr,yr:INTEGER;couleur:BYTE);
PROCEDURE AjouterObjetDansListe(obj:ObjetIndepPtr);
PROCEDURE SupprimerObjetActif;
PROCEDURE Execute;
PROCEDURE ActiverObjetCoordonnee(xm,ym:INTEGER);
PROCEDURE ActiverObjetAdr(adrObjet:objetIndepPtr);
PROCEDURE ChargeIcone(obj:IconeObjPtr;nom:STRING);
PROCEDURE Bar(x,y,xx,yy:INTEGER);
PROCEDURE LoadBML(nom:STRING);
PROCEDURE ChargerFondEcran(nom:STRING);
PROCEDURE SysErr(err:WORD;lib:STRING);
{$F+}
PROCEDURE RienObjIndep(objet:objetIndepPtr);
PROCEDURE RienObjDep(objet:objetDepPtr);
PROCEDURE QuitterLSF(p:objetdepptr);
{$F-}

IMPLEMENTATION


                        {=========== SaisieObj ======================}
CONSTRUCTOR saisieObj.Creer(xr1,yr1:INTEGER;nbCarAff,nbCarTot:BYTE;textInit:STRING;
                            coulF,coulC:BYTE;keycode:codeclavier);
BEGIN
  codetouche:=keycode;
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
  possesseur^.objetClaviercourant:=@SELF;
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

                        {============ LigneObj ======================}

CONSTRUCTOR ligneObj.Creer(xr1,yr1,xr2,yr2:INTEGER;d1,d2:INTEGER);
BEGIN
  x1:=xr1;y1:=yr1;
  x2:=xr2;y2:=yr2;
  dec1:=d1;
  dec2:=d2;
  typeObjet:=135;
END;

DESTRUCTOR ligneObj.Detruire;
BEGIN END;

PROCEDURE ligneObj.Afficher;
VAR xd,yd:INTEGER;
BEGIN
  xd:=possesseur^.x1;
  yd:=possesseur^.y1;
  SetColor(white);
  HideMouse;
  Line(x1+xd,y1+yd,x2+xd,y2+yd);
  SetColor(Black);
  IF dec1=0 THEN Line(x1+xd,y1+1+yd,x2+xd,y2+1+yd)
            ELSE Line(x1+xd,y1-1+yd,x2+xd,y2-1+yd);
  ShowMouse;
END;

PROCEDURE ligneObj.Gerer(xm,ym:INTEGER);
BEGIN END;


                        {============ IconeObj ======================}

CONSTRUCTOR IconeObj.Creer(xr1,yr1:INTEGER;nom:String8;PtrProc:procObjDep;
                           keycode:codeclavier);
BEGIN
  codetouche:=keycode;
  path:=nom;
  x1:=xr1;y1:=yr1;
  ChargeIcone(@SELF,nom);
  actionner:=ptrProc;
  typeObjet:=134;
END;

DESTRUCTOR IconeObj.Detruire;
BEGIN END;

PROCEDURE IconeObj.Afficher;
BEGIN
  HideMouse;
  PutImage(possesseur^.x1+x1,possesseur^.y1+y1,ptr^,copyPut);
  ShowMouse;
END;


PROCEDURE IconeObj.Gerer(xm,ym:INTEGER);
BEGIN
  actionner(@SELF);
END;




                        {========= AscenceurVertiObj  ===============}

CONSTRUCTOR AscenceurVertiObj.Creer(xr1,yr1,hauteurAscen,
              tailleTrajet,maximumReel:INTEGER);
BEGIN
  x1:=xr1;y1:=yr1;
  xFen:=0;yFen:=0;
  x2:=xr1+16;y2:=yr1+39+hauteurAscen;
  position:=0;
  valRealMaxi:=maximumReel;
  tailleCourse:=tailleTrajet;
  hauteur:=hauteurAscen;
  actionner:=RienObjDep;
  boiteFond.Creer(x1,y1,x1+16,y1+hauteurAscen+4,GrisClair,rienObjDep);
  boutonHaut.creer(x1,y2-33,x2,y2-17,TRUE,'~H',0,grisClair,RienObjDep,#0#0);
  boutonBas.Creer(x1,y2-16,x2,y2,TRUE,'~B',0,grisClair,RienObjDep,#0#0);
  curseur.Creer(x1+2,y1+2,x2-2,y1+2+hauteurAscen-tailleTrajet,TRUE,'ø',5,
                grisClair,RienObjDep,#0#0);
  typeObjet:=132;
END;

DESTRUCTOR  AscenceurVertiObj.Detruire;
BEGIN
  boutonHaut.Detruire;
  boutonBas.Detruire;
  curseur.Detruire;
  boiteFond.Detruire;
END;

PROCEDURE   AscenceurVertiObj.Afficher;
BEGIN
  boiteFond.possesseur:=possesseur;
  boutonHaut.possesseur:=possesseur;
  boutonBas.possesseur:=possesseur;
  curseur.possesseur:=possesseur;
  HideMouse;
  boiteFond.Afficher;
  boutonHaut.Afficher;
  boutonBas.Afficher;
  curseur.Afficher;
  ShowMouse;
END;

PROCEDURE   AscenceurVertiObj.Gerer(xm,ym:INTEGER);
VAR _x,_y,decal,ancy:INTEGER;
    _bout:BYTE;
    decx,decy:INTEGER;
BEGIN
  GetMouse(_x,_y,_bout);
  IF (boutonHaut.zoneChoisie(_x,_y)) AND (position>0)
  THEN BEGIN
         Dec(curseur.y1);
         Dec(curseur.y2);
         Dec(position);
         HideMouse;
         curseur.afficher;
         SetColor(grisClair);
         Line(possesseur^.x1+curseur.x1,possesseur^.y1+curseur.y2+1,
              possesseur^.x1+curseur.x2,possesseur^.y1+curseur.y2+1);
         ShowMouse;
       END;
  IF boutonBas.zoneChoisie(_x,_y) AND (position<tailleCourse)
  THEN BEGIN
         Inc(position);
         Inc(curseur.y1);
         Inc(curseur.y2);
         HideMouse;
         curseur.Afficher;
         SetColor(grisClair);
         Line(possesseur^.x1+curseur.x1,possesseur^.y1+curseur.y1-1,
              possesseur^.x1+curseur.x2,possesseur^.y1+curseur.y1-1);
         ShowMouse;
       END;
  actionner(@Self)
END;

FUNCTION    AscenceurVertiObj.GetPosition:INTEGER;
BEGIN
  GetPosition:=position;
END;

PROCEDURE   AscenceurVertiObj.ChangeIntervalle(maxi:INTEGER);
BEGIN END;

                        {========= AscenceurHorizObj  ===============}

CONSTRUCTOR AscenceurHorizObj.Creer(xr1,yr1,largeurAscen,
              tailleTrajet,maximumReel:INTEGER);
BEGIN
  x1:=xr1;y1:=yr1;
  x2:=xr1+39+largeurAscen;y2:=yr1+16;
  position:=0;
  valRealMaxi:=maximumReel;
  tailleCourse:=tailleTrajet;
  largeur:=largeurAscen;
  actionner:=RienObjDep;
  boiteFond.Creer(x1+34,y1,x1+largeurAscen+37,y1+16,GrisClair,rienObjDep);
  boutonGauche.creer(x1,y1,x1+16,y1+16,TRUE,'~G',0,grisClair,RienObjDep,#0#0);
  boutonDroit.Creer(x1+17,y1,x1+33,y1+16,TRUE,'~D',0,grisClair,RienObjDep,#0#0);
  curseur.Creer(x1+35,y1+2,x1+35+largeurAscen-tailleTrajet,y2-2,TRUE,
                'ø',5,grisClair,RienObjDep,#0#0);
  typeObjet:=133;
END;

DESTRUCTOR  AscenceurHorizObj.Detruire;
BEGIN
  boutonGauche.Detruire;
  boutonDroit.Detruire;
  curseur.Detruire;
  boiteFond.Detruire;
END;

PROCEDURE   AscenceurHorizObj.Afficher;
BEGIN
  boiteFond.possesseur:=possesseur;
  boutonGauche.possesseur:=possesseur;
  boutonDroit.possesseur:=possesseur;
  curseur.possesseur:=possesseur;
  HideMouse;
  boiteFond.Afficher;
  boutonGauche.Afficher;
  boutonDroit.Afficher;
  curseur.Afficher;
  ShowMouse;
END;

PROCEDURE   AscenceurHorizObj.Gerer(xm,ym:INTEGER);
VAR _x,_y:INTEGER;
    _bout:BYTE;
BEGIN
  GetMouse(_x,_y,_bout);
  IF (boutongauche.zoneChoisie(_x,_y)) AND (position>0)
  THEN BEGIN
         Dec(position);
         Dec(curseur.x1);
         Dec(curseur.x2);
         HideMouse;
         curseur.afficher;
         SetColor(grisClair);
         Line(possesseur^.x1+curseur.x2+1,possesseur^.y1+curseur.y1,
              possesseur^.x1+curseur.x2+1,possesseur^.y1+curseur.y2);
         ShowMouse;
       END;
  IF boutondroit.zoneChoisie(_x,_y) AND (position<tailleCourse)
  THEN BEGIN
         Inc(position);
         Inc(curseur.x1);
         Inc(Curseur.x2);
         HideMouse;
         curseur.afficher;
         SetColor(grisClair);
         Line(possesseur^.x1+curseur.x1-1,possesseur^.y1+curseur.y1,
              possesseur^.x1+curseur.x1-1,possesseur^.y1+curseur.y2);
         ShowMouse;
       END;
  actionner(@self);
END;

FUNCTION    AscenceurHorizObj.GetPosition:INTEGER;
BEGIN
  GetPosition:=position;
END;

PROCEDURE   AscenceurHorizObj.ChangeIntervalle(maxi:INTEGER);
BEGIN END;


                        {=============  TexteObj  ===================}
CONSTRUCTOR texteObj.Creer(xr1,yr1:INTEGER;text:STRING;fonte,coul,t,g:BYTE);
BEGIN
  x1:=xr1;y1:=yr1;
  texte:=text;
  couleur:=coul;
  taille:=t;
  fonteCarac:=fonte;
  gras:=g;
  actionner:=RienObjDep;
  typeObjet:=131;
END;

DESTRUCTOR  texteObj.Detruire;
BEGIN END;

PROCEDURE   texteObj.Afficher;
BEGIN
  setTextStyle(FonteCarac,horizDir,taille);
  SetTextJustify(LeftText,TopText);
  SetColor(couleur);
  OutTextXY(possesseur^.x1+x1,possesseur^.y1+y1,texte);
  IF BOOLEAN(gras AND 1)
     THEN OutTextXY(possesseur^.x1+x1+1,possesseur^.y1+y1,texte);
  IF BOOLEAN(gras AND 2)
     THEN OutTextXY(possesseur^.x1+x1,possesseur^.y1+y1+1,texte);
END;

PROCEDURE   texteObj.Gerer(xm,ym:INTEGER);
BEGIN
  actionner(@Self);
END;


                        {=============  CadreObj  ===================}
CONSTRUCTOR cadreObj.Creer;
BEGIN
  x1:=xr1;y1:=yr1;
  x2:=xr2;y2:=yr2;
  IF title='' THEN titre:='' ELSE titre:=' '+title+' ';
  actionner:=ptrProc;
  typeObjet:=130;
END;

DESTRUCTOR cadreObj.Detruire;
BEGIN END;

PROCEDURE cadreObj.Gerer;
BEGIN
  actionner(@self);
END;


PROCEDURE cadreObj.Afficher;
VAR lT,dec:INTEGER;
BEGIN
  setTextStyle(smallFont,horizDir,4);
  SetTextJustify(centerText,TopText);
  lT:=TextWidth(titre);
  SetColor(noir);
  OutTextXY(possesseur^.x1+x1+(x2-x1) DIV 2,possesseur^.y1+y1,titre);
  dec:=(x2-x1-lT) DIV 2;
  MoveTo(possesseur^.x1+x1+dec,possesseur^.y1+y1+4);LineTo(possesseur^.x1+x1,possesseur^.y1+y1+4);
  LineTo(possesseur^.x1+x1,possesseur^.y1+y2);
  Line(possesseur^.x1+x2-dec,possesseur^.y1+y1+4,possesseur^.x1+x2,possesseur^.y1+y1+4);
  MoveTo(possesseur^.x1+x2-1,possesseur^.y1+y1+5);LineTo(possesseur^.x1+x2-1,possesseur^.y1+y2-1);
  LineTo(possesseur^.x1+x1+1,possesseur^.y1+y2-1);
  SetColor(blanc);
  MoveTo(possesseur^.x1+x1+dec,possesseur^.y1+y1+5);LineTo(possesseur^.x1+x1+1,possesseur^.y1+y1+5);
  LineTo(possesseur^.x1+x1+1,possesseur^.y1+y2-1);
  Line(possesseur^.x1+x2-dec,possesseur^.y1+y1+5,possesseur^.x1+x2-1,possesseur^.y1+y1+5);
  MoveTo(possesseur^.x1+x2,possesseur^.y1+y1+5);LineTo(possesseur^.x1+x2,possesseur^.y1+y2);
  LineTo(possesseur^.x1+x1+1,possesseur^.y1+y2);
END;






                        {==============  BoiteObj  ==================}
CONSTRUCTOR boiteObj.creer;
BEGIN
  x1:=xx1;y1:=yy1;
  x2:=xx2;y2:=yy2;
  couleurFond:=coulFond;
  actionner:=RienObjDep;
  typeObjet:=129;
END;

DESTRUCTOR boiteObj.Detruire;
BEGIN END;

PROCEDURE boiteObj.Afficher;
BEGIN
  HideMouse;
  SetFillStyle(solidFill,couleurFond);
  Bar(possesseur^.x1+x1,possesseur^.y1+y1,possesseur^.x1+x2,possesseur^.y1+y2);
  SetColor(noir);Rectangle(possesseur^.x1+x1,possesseur^.y1+y1,possesseur^.x1+x2,possesseur^.y1+y2);
  Rectangle(possesseur^.x1+x1+1,possesseur^.y1+y1+1,possesseur^.x1+x2,possesseur^.y1+y2);
  SetColor(blanc);MoveTo(possesseur^.x1+x1,possesseur^.y1+y2);LineTo(possesseur^.x1+x2,possesseur^.y1+y2);
  LineTo(possesseur^.x1+x2,possesseur^.y1+y1);
  MoveTo(possesseur^.x1+x1+1,possesseur^.y1+y2-1);LineTo(possesseur^.x1+x2-1,possesseur^.y1+y2-1);
  LineTo(possesseur^.x1+x2-1,possesseur^.y1+y1+1);
  ShowMouse;
END;

PROCEDURE BoiteObj.Gerer;
BEGIN
  actionner(@self);
END;




                                 {==============  FenetreObj  ================}

CONSTRUCTOR fenetreObj.Creer;
BEGIN
  x1:=xx1;y1:=yy1;
  x2:=xx2;y2:=yy2;
  couleurFond:=coulfond;
  boutonTitre.Creer(1,1,x2-x1-1,14,TRUE,title,4,grisClair,rienObjDep,#0#0);
  boutonTitre.possesseur:=@Self;
  boutonFermeture.Creer(3,3,11,12,TRUE,'X',3,grisClair,rienObjDep,#27#0);
  boutonFermeture.possesseur:=@Self;
  boutonIcone.Creer(x2-x1-11,3,x2-x1-3,12,TRUE,'=',3,grisClair,rienObjDep,#253#0);
  boutonIcone.possesseur:=@Self;
  boutonGauche.Creer(1,y2-y1-7,14,y2-y1-1,TRUE,'',1,grisclair,rienObjDep,#0#0);
  boutonGauche.possesseur:=@Self;
  boutonDroit.Creer(x2-x1-16,y2-y1-7,x2-x1-1,y2-y1-1,TRUE,'',1,grisclair,rienObjDep,#0#0);
  boutonDroit.possesseur:=@Self;
  boutonCentre.Creer(15,y2-y1-7,x2-x1-17,y2-y1-1,TRUE,'',1,grisClair,rienObjDep,#0#0);
  boutonCentre.possesseur:=@Self;
  visible:=FALSE;
  actif:=FALSE;
  listeAjout:=NIL;
  objetClavierCourant:=NIL;
  nbAjout:=0;
  actionner:=rienObjindep;
  gestionAjout:=TRUE;
  enIcone:=FALSE;
  typeObjet:=1;
END;

DESTRUCTOR fenetreObj.Detruire;
VAR n:noeudPtr;
BEGIN
  IF visible THEN RestaureEcran;
  WHILE listeAjout<>NIL DO BEGIN
    n:=listeAjout;
    listeAjout:=n^.suivant;
    DISPOSE(n^.objet,Detruire);
    DISPOSE(n);
  END;
END;



PROCEDURE fenetreObj.Afficher;
VAR ptrCourant:noeudPtr;
    n        :BYTE;
BEGIN
  IF (actif and not visible) AND GestionObjetVisible THEN SysErr(STAT_WIN_ERR,boutontitre.titre);
  IF visible THEN BEGIN
    ActiverObjetAdr(@Self);
    EXIT;
  END;
  HideMouse;MouseOff;
  AjouterObjetDansListe(@SELF);
  sauveEcran;
  IF NOT enIcone THEN BEGIN
    SetFillStyle(SolidFill,couleurFond);Bar(x1,y1,x2,y2);
    SetColor(noir);Rectangle(x1,y1,x2,y2);
    boutonTitre.Afficher;
    boutonFermeture.afficher;
    boutonIcone.afficher;
    boutonGauche.afficher;
    boutonDroit.afficher;
    boutonCentre.afficher;
    ptrCourant:=listeAjout;
    WHILE ptrCourant<>NIL DO BEGIN
      ptrCourant^.objet^.afficher;
      ptrCourant:=ptrCourant^.suivant;
    END;
    END
  ELSE boutonTitre.Afficher;
  MouseOn;ShowMouse;
  visible:=TRUE;
  actif:=TRUE;
END;

PROCEDURE fenetreObj.Cacher;
BEGIN
  IF NOT visible THEN EXIT;
  ActiverObjetAdr(@SELF);
  RestaureEcran;
  visible:=FALSE;
  actif:=False;
  SupprimerObjetActif;
END;

PROCEDURE fenetreObj.activer;
BEGIN
  IF actif THEN EXIT;
  boutonTitre.couleurFond:=grisClair;
  boutontitre.afficher;
  actif:=TRUE;
  IF enIcone THEN EXIT;
  boutonFermeture.afficher;
  boutonIcone.afficher;
END;

PROCEDURE fenetreObj.Desactiver;
BEGIN
  IF NOT actif THEN EXIT;
  boutonTitre.couleurFond:=grisFonce;
  boutontitre.afficher;
  actif:=FALSE;
  IF enIcone THEN EXIT;
  boutonFermeture.afficher;
  boutonIcone.afficher;
END;


PROCEDURE fenetreObj.Ajouter(p:objetDepPtr);
VAR nouv:NoeudPtr;
BEGIN
  {IF (x1+p^.x2>x2) or (y1+p^.y2>y2) THEN EXIT;}
  NEW(nouv);
  p^.possesseur:=@Self;
  nouv^.objet:=p;
  nouv^.suivant:=listeAjout;
  listeAjout:=nouv;
  Inc(nbAjout);
  IF visible THEN BEGIN
    Cacher;
    Afficher;
  END;
END;

PROCEDURE fenetreObj.Gerer(xm,ym:INTEGER);
VAR ptrCourant:noeudPtr;
    xx1,yy1,xx2,yy2,xx,yy,l:INTEGER;
    bb:BYTE;
    sortir:BOOLEAN;
BEGIN
  IF NOT visible THEN EXIT;
  xx1:=x1;yy1:=y1;
  xx2:=x2;yy2:=y2;
  IF enIcone AND boutonTitre.ZoneChoisie(xm,ym) THEN BEGIN
    GetMouse(xx,yy,bb);
    IF bb=2 THEN BEGIN
      cacher;
      y2:=y1+_y2;
      y2sav:=y2;IF y2sav>getMaxY THEN y2sav:=GetMaxY;
      enIcone:=FALSE;
      afficher;
      showmouse;
      yy2:=y2;
      gestionObjetVisible:=TRUE;
    END;
  END;

  IF boutonTitre.zoneChoisie(xm,ym) THEN
    BEGIN
      IF NOT enIcone AND boutonFermeture.ZoneChoisie(xm,ym) THEN BEGIN
        Cacher;
        actif:=FALSE;
        showMouse;
        blocagePremierPlan:=FALSE;
      END
      ELSE IF NOT enIcone AND boutonIcone.ZoneChoisie(xm,ym) THEN
        BEGIN
          cacher;
          y2sav:=y1+14;
          IF y2sav>getMaxY THEN y2sav:=getMaxY;
          _y2:=y2-y1;
          y2:=y1+14;
          enIcone:=TRUE;
          Afficher;
        END
        ELSE BEGIN
          Deplacement(xx1,yy1,xx2,yy2);
          Deplacer(xx1,yy1);
        END;
    END
  ELSE IF gestionAjout AND actif THEN
    BEGIN
      sortir:=FALSE;
      ptrCourant:=listeAjout;
      WHILE (ptrCourant<>NIL) OR sortir DO BEGIN
        IF ptrCourant^.objet^.zoneChoisie(Xm,Ym)
          THEN BEGIN ptrCourant^.objet^.gerer(x1,y1);sortir:=FALSE; END;
        ptrCourant:=ptrCourant^.suivant;
      END;
    END;

  IF actif THEN actionner(@Self);
END;

PROCEDURE fenetreObj.EvenementClavier(keycode:codeclavier);
VAR ptrCourant:noeudPtr;
    xx1,yy1,xx2,yy2,xx,yy,l:INTEGER;
    bb:BYTE;
BEGIN
  IF NOT visible THEN EXIT;
  showmouse;
  xx1:=x1;yy1:=y1;
  xx2:=x2;yy2:=y2;
  IF NOT enIcone AND (keycode=#127)
  THEN BEGIN
        Cacher;
        actif:=FALSE;
        showMouse;
  END;

  IF gestionAjout AND actif THEN
    BEGIN
      ptrCourant:=listeAjout;
      WHILE ptrCourant<>NIL DO BEGIN
        IF ptrCourant^.objet^.codetouche=keycode
          THEN ptrCourant^.objet^.gerer(-1,-1);
        ptrCourant:=ptrCourant^.suivant;
      END;
    END;

  IF actif THEN actionner(@Self);
END;



                        {===============  ObjetDep  =================}
PROCEDURE objetDep.Afficher;
BEGIN END;

PROCEDURE objetdep.Gerer;
BEGIN
  actionner(@self);
END;

DESTRUCTOR objetDep.Detruire;
BEGIN END;

FUNCTION objetDep.ZoneChoisie(xm,ym:INTEGER):BOOLEAN;
BEGIN
  ZoneChoisie:=( (xm>=x1+possesseur^.x1) AND (xm<=x2+possesseur^.x1)
                 AND (ym>=y1+possesseur^.y1) AND (ym<=y2+possesseur^.y1) )
END;


                        {===============  BoutonObj  ================}

CONSTRUCTOR boutonObj.Creer;               { *** BoutonObj *** }
BEGIN
  x1:=xx1;y1:=yy1;
  x2:=xx2;y2:=yy2;
  titre:=title;
  tailleCar:=taille;
  presser:=FALSE;
  actionner:=ptrProc;
  couleurFond:=coulFond;
  typeObjet:=128;
  autoRepetition:=autorep;
  codeTouche:=keycode;
END;

DESTRUCTOR BoutonObj.Detruire;
BEGIN END;

PROCEDURE BoutonObj.Afficher;
VAR xAff,yAff:INTEGER;
BEGIN
  HideMouse;
  FondRelief(x1+possesseur^.x1,y1+possesseur^.y1,x2+possesseur^.x1,
             y2+possesseur^.y1,couleurFond);
  IF presser THEN bordReliefBas(x1+possesseur^.x1,y1+possesseur^.y1,
                                x2+possesseur^.x1,y2+possesseur^.y1)
             ELSE bordReliefHaut(x1+possesseur^.x1,y1+possesseur^.y1,
                                 x2+possesseur^.x1,y2+possesseur^.y1);
  SetTextJustify(centerText,centerText);
  SetTextStyle(SmallFont,Horizdir,tailleCar);
  SetColor(noir);
  xAff:=possesseur^.x1+x1+(x2-x1) DIV 2;
  yAff:=possesseur^.y1+y1+(y2-y1) DIV 2;
  IF titre[1]<>'~' THEN OutTextXY(xAff,yAff,titre)
                   ELSE CASE titre[2] OF
                          'H' : flecheHaut(xAff,yAff,noir);
                          'B' : flecheBas (xAff,yAff,noir);
                          'G' : flecheGauche(xAff,yAff,noir);
                          'D' : flecheDroite(xAff,yAff,noir);
                          ELSE  OutTextXY(xAff,yAff,titre)
                        END;
  ShowMouse;
END;

PROCEDURE BoutonObj.Enfoncer;
BEGIN
  IF presser THEN EXIT;
  presser:=TRUE;
  BordReliefbas(x1+possesseur^.x1,y1+possesseur^.y1,
                x2+possesseur^.x1,y2+possesseur^.y1);
END;

PROCEDURE BoutonObj.Relacher;
BEGIN
  IF NOT presser THEN EXIT;
  presser:=FALSE;
  BordReliefHaut(x1+possesseur^.x1,y1+possesseur^.y1,
                 x2+possesseur^.x1,y2+possesseur^.y1);
END;

PROCEDURE  boutonObj.Gerer;
VAR xx,yy:INTEGER;
    bout:BYTE;
begin
  IF NOT autoRepetition THEN BEGIN
    enfoncer;
    IF MouseDriverLoaded THEN
      REPEAT GetMouse(xx,yy,bout) UNTIL (bout=0) OR NOT ZoneChoisie(xx,yy)
    ELSE bout:=0;
    relacher;
  END;
  IF (bout<>0) AND NOT autoRepetition THEN EXIT;
  actionner(@SELF);
end;




                        {================ ObjetIndep ================}

PROCEDURE objetIndep.Afficher;
BEGIN END;

PROCEDURE objetIndep.Cacher;
BEGIN END;

PROCEDURE objetIndep.Activer;
BEGIN END;

PROCEDURE objetIndep.Desactiver;
BEGIN END;

PROCEDURE objetIndep.EvenementSouris(codeEvent:WORD;xm,ym:INTEGER;boutons:BYTE);
BEGIN END;

PROCEDURE objetIndep.EvenementClavier(codetouche:codeclavier);
BEGIN END;

PROCEDURE objetIndep.SauveEcran;
BEGIN
  x1sav:=x1;x2sav:=x2;y1sav:=y1;y2sav:=y2;
  IF x1sav>getmaxx then x1sav:=getmaxx;
  if x1sav<0 then x1sav:=0;
  IF x2sav>getmaxx then x2sav:=getmaxx;
  if x2sav<0 then x2sav:=0;
  IF y2sav>getmaxy then y2sav:=getmaxy;
  if y2sav<0 then y2sav:=0;
  IF y1sav>getmaxy then y1sav:=getmaxy;
  if y1sav<0 then y1sav:=0;
  GetMem(bufferEcran,ImageSize(x1sav,y1sav,x2sav,y2sav));
  HideMouse;
  GetImage(x1sav,y1sav,x2sav,y2sav,bufferEcran^);
  ShowMouse;
END;

PROCEDURE objetIndep.RestaureEcran;
BEGIN
  HideMouse;
  PutImage(x1sav,y1sav,bufferEcran^,CopyPut);
  ShowMouse;
  FreeMem(bufferEcran,ImageSize(x1sav,y1sav,x2sav,y2sav));
END;

PROCEDURE objetIndep.Deplacer(xx,yy:INTEGER);
VAR xr,yr,xx2,yy2:INTEGER;
    b:BYTE;
    q:BOOLEAN;
BEGIN
  xr:=x2-x1;yr:=y2-y1;
  gestionObjetVisible:=FALSE;
  q:=FALSE;
  IF (xx=x1) AND (yy=y1) THEN BEGIN
                                q:=TRUE;
                                gestionObjetVisible:=TRUE;
                              END;
  IF q THEN EXIT;
  IF visible THEN RestaureEcran;
  x1:=xx;y1:=yy;
  x2:=xx+xr;y2:=yy+yr;
  IF visible
    THEN BEGIN
      visible:=FALSE;
      Afficher;
    END;
  gestionObjetVisible:=TRUE;
END;

FUNCTION objetIndep.ZoneChoisie(xm,ym:INTEGER):BOOLEAN;
BEGIN
  ZoneChoisie:=( (xm>x1) AND (xm<x2) AND (ym>y1) AND (ym<y2) AND visible=TRUE)
END;

PROCEDURE objetIndep.Gerer;
VAR p:POINTER;
BEGIN
  actionner(@self);
END;




                                     {============  objet MENU =========}
CONSTRUCTOR menuObj.Creer;
VAR n     :noeudPtr;
    bouton:boutonObjPtr;
    t     :STRING40;
    c,num :BYTE;
BEGIN
  x1:=xx1;y1:=yy1;
  x2:=x1+large;y2:=y1+13;
  listeOption:=NIL;
  nbChoix:=0;
  largeur:=large;
  boutonTitre.Creer(0,0,large,13,TRUE,title,4,grisClair,RienObjDep,#0#0);
  boutonTitre.possesseur:=@SELF;
  boutonFermeture.Creer(2,2,10,11,TRUE,'#',3,grisClair,rienObjDep,#0#147);
  boutonFermeture.possesseur:=@SELF;
  bufferEcran:=NIL;
  visible:=FALSE;
  actionner:=rienObjIndep;
  actif:=FALSE;
  supprimable:=TRUE;
  typeObjet:=2;
END;

DESTRUCTOR menuObj.Detruire;
VAR n:noeudPtr;
BEGIN
  IF visible THEN RestaureEcran;
  WHILE listeOption<>NIL DO BEGIN
    n:=listeOption;
    listeOption:=n^.suivant;
    DISPOSE(n^.objet,Detruire);
    DISPOSE(n);
  END;
END;

PROCEDURE menuObj.Afficher;
VAR n:noeudPtr;
    i:BYTE;
BEGIN
  IF visible THEN BEGIN
    ActiverObjetAdr(@self);
    EXIT;
  END;
  AjouterObjetDansListe(@SELF);
  HideMouse;MouseOff;
  SauveEcran;
  boutonTitre.Afficher;
  IF supprimable THEN boutonFermeture.afficher;
  n:=listeOption;
  FOR i:=1 TO nbChoix DO BEGIN
    n^.objet^.afficher;
    n:=n^.suivant;
  END;
  MouseON;ShowMouse;
  visible:=TRUE;
  actif:=TRUE;
END;

PROCEDURE MenuObj.Cacher;
BEGIN
  IF NOT visible THEN EXIT;
  ActiverObjetAdr(@SELF);
  RestaureEcran;
  visible:=FALSE;
  actif:=FALSE;
  supprimerObjetActif
END;

PROCEDURE menuObj.Gerer;
VAR ptrCourant:noeudPtr;
    obj:boutonObjPtr;
    xx1,yy1,xx2,yy2:INTEGER;
    i:BYTE;
BEGIN
  IF NOT visible THEN EXIT;
  xx1:=x1;yy1:=y1;
  xx2:=x2;yy2:=y2;
  IF boutonTitre.zoneChoisie(xm,ym) THEN BEGIN
    IF boutonFermeture.zoneChoisie(xm,ym) AND supprimable THEN BEGIN
      Cacher;
      actif:=FALSE;
      showMouse;
      END
    ELSE BEGIN
      Deplacement(xx1,yy1,xx2,yy2);
      Deplacer(xx1,yy1);
      END;
  END;
  IF NOT actif THEN Exit;
  ptrCourant:=listeOption;
  FOR i:=1 TO nbChoix DO BEGIN
    IF ptrCourant^.objet^.zoneChoisie(Xm,Ym)
      THEN ptrCourant^.objet^.gerer(xm,ym);
    ptrCourant:=ptrCourant^.suivant;
  END;
  actionner(@Self);
END;

PROCEDURE menuObj.activer;
BEGIN
  IF actif THEN EXIT;
  boutonTitre.couleurFond:=grisClair;
  boutontitre.afficher;
  IF supprimable THEN boutonFermeture.afficher;
  actif:=TRUE;
END;

PROCEDURE menuObj.Desactiver;
BEGIN
  IF NOT actif THEN EXIT;
  boutonTitre.couleurFond:=grisFonce;
  boutontitre.afficher;
  IF supprimable THEN boutonFermeture.afficher;
  actif:=FALSE;
END;

PROCEDURE menuObj.Ajouter;
VAR n,n1:noeudPtr;
    p:boutonObjPtr;
    x:BYTE;
BEGIN
  NEW(n1);
  NEW(p);
  n1^.suivant:=listeOption;
  n1^.objet:=p;
  listeOption:=n1;
  INC(nbChoix);
  p^.creer(0,2+nbchoix*12,SELF.largeur,nbchoix*12+13,rep,titre,4,
           grisClair,process,keycode);
  p^.possesseur:=@SELF;
  IF visible THEN RestaureEcran;
  y2:=y2+12;
  IF y2>getMaxY THEN BEGIN
     y2:=y2-12;y1:=y1-12;
  END;
  IF visible THEN
  BEGIN
    visible:=FALSE;
    Afficher;
  END;
END;

PROCEDURE menuObj.MetProcOption(numOption:BYTE;Process:ProcObjDep);
VAR node:noeudPtr;
    i:BYTE;
BEGIN
  IF numOption>nbChoix THEN EXIT;
  node:=listeOption;
  FOR i:=1 TO nbChoix-numOption DO node:=node^.suivant;
  node^.objet^.actionner:=Process;
END;

PROCEDURE menuObj.EvenementClavier;
VAR ptrCourant:noeudPtr;
    obj:boutonObjPtr;
    i:BYTE;
BEGIN
  IF NOT visible THEN EXIT;
  showmouse;
  IF (keycode=#127) AND supprimable
  THEN BEGIN
    Cacher;
    actif:=FALSE;
    showMouse;
  END;
  IF NOT actif THEN Exit;
  ptrCourant:=listeOption;
  FOR i:=1 TO nbChoix DO BEGIN
    IF ptrCourant^.objet^.codetouche=keycode
      THEN ptrCourant^.objet^.gerer(-1,-1);
    ptrCourant:=ptrCourant^.suivant;
  END;
  actionner(@Self);
END;


{**************************************************************************
 *****************  PROCEDURES & FONCTIONS STANDARTS  *********************
 **************************************************************************}

PROCEDURE SysErr(err:WORD;lib:STRING);
BEGIN
  IF err=NO_ERR THEN TextMode(LASTMODE);
  CASE err OF
    NO_ERR       : Writeln(' ** Fin sur demande de l''utilisateur.');
    NIL_PTR_ERR  : Writeln(' ** ERREUR FATALE : apparition NIL dans ListeObjetVisible');
    NB_OBJ_ERR   : Writeln(' ** ERREUR FATALE : nbObjetVisible incoherent');
    SYS_LOAD_ERR : Writeln(' ** ERREUR FATALE : Pb chargement du systeme ');
  ELSE
    Writeln(' ** ERREUR FATALE : type erreur INCONNUE --> voir LIONSOFT');
  END;
  IF err<>NO_ERR THEN Writeln(lib);
  writeln;
  Writeln(' Merci d''avoir utilis‚ LSFWin '+LSFVER);
  Writeln(' Copyright Nicolas CLERC 1991 - 1993 ');
  nosound;
  halt(INTEGER(err<>0));
END;



PROCEDURE LoadBML(nom:STRING);
var fichier:FILE;
    ptrVga:BYTE ABSOLUTE $a000:0000;
BEGIN
{$I-}
  Assign(fichier,nom);
  Reset(fichier,38400);
  PORT[$3C4]:=$02;
  PORT[$3C5]:=1;
  BlockRead(fichier,ptrVGA,1);
  PORT[$3C4]:=$02;
  PORT[$3C5]:=2;
  BlockRead(fichier,ptrVGA,1);
  PORT[$3C4]:=$02;
  PORT[$3C5]:=4;
  BlockRead(fichier,ptrVGA,1);
  PORT[$3C4]:=$02;
  PORT[$3C5]:=8;
  BlockRead(fichier,ptrVGA,1);
  close(Fichier)
{$I+}

END;

PROCEDURE ChargerFondEcran(nom:STRING);
VAR p:elementListeObjPtr;
    n:WORD;
BEGIN
  p:=listeObjetVisible;
  gestionObjetVisible:=FALSE;
  FOR n:=1 TO nbObjetVisible-1 DO BEGIN
    p^.objet^.restaureEcran;
    p^.objet^.visible:=FALSE;
    p:=p^.suiv;
  END;
  p^.objet^.restaureecran;
  p^.objet^.visible:=FALSE;
  hidemouse;
  loadBML(nom);
  ShowMouse;
  FOR n:=1 TO nbObjetVisible DO BEGIN
    p^.objet^.afficher;
    p:=p^.prec;
  END;
  gestionObjetVisible:=TRUE;
END;



PROCEDURE Bar(x,y,xx,yy:INTEGER);
BEGIN
  IF x<0 THEN x:=0;
  IF y<0 THEN y:=0;
  IF xx>GetmaxX THEN xx:=Getmaxx;
  IF yy>Getmaxy THEN yy:=Getmaxy;
  Graph.Bar(x,y,xx,yy);
END;





PROCEDURE couleurCGA;
BEGIN
  Blanc:=1;
  Noir:=1;
  Grisclair:=0;
  GrisFonce:=0;
END;



PROCEDURE FondRelief(x1,y1,x2,y2:INTEGER;coul:BYTE);
BEGIN
  SetFillStyle(solidfill,coul);
  BAR(x1+1,y1+1,x2-1,y2-1);
  SetColor(blanc);
  MoveTo(x1,y2-1);LineTo(x1,y1);LineTo(x2,y1);
  SetColor(noir);
  MoveTo(x1,y2);LineTo(x2,y2);LineTo(x2,y1+1);
END;

PROCEDURE BordReliefBas(x1,y1,x2,y2:INTEGER);
BEGIN
  SetColor(noir);
  hidemouse;
  MoveTo(x1,y2-1);LineTo(x1,y1);LineTo(x2,y1);
  SetColor(blanc);
  MoveTo(x1,y2);LineTo(x2,y2);LineTo(x2,y1+1);
  showmouse;
END;

PROCEDURE BordReliefHaut(x1,y1,x2,y2:INTEGER);
BEGIN
  SetColor(blanc);
  hidemouse;
  MoveTo(x1,y2-1);LineTo(x1,y1);LineTo(x2,y1);
  SetColor(noir);
  MoveTo(x1,y2);LineTo(x2,y2);LineTo(x2,y1+1);
  showmouse;
END;

PROCEDURE Deplacement(VAR xx1,yy1,xx2,yy2:INTEGER);
VAR x,y,xx,yy,
    large,haut,
    xm,ym,
    decX,decY     :INTEGER;
    boutM         :BYTE;
BEGIN
  GetMouse(xm,ym,boutM);
  decx:=xm-xx1;decy:=ym-yy1;
  large:=xx2-xx1;haut:=yy2-yy1;
  x:=xm;y:=ym;
  xx:=x;yy:=y;
  SetLineStyle(DottedLn,0,2);
  SetWriteMode(XORput);
  SetColor(blanc);
  HideMouse;
  Rectangle(x-decx,y-decy,x+large-decx,y+haut-decy);
  ShowMouse;
  REPEAT
    REPEAT GetMouse(x,y,boutM) UNTIL (x<>xx) OR (y<>yy) OR (boutM=0);
    HideMouse;
    Rectangle(xx-decx,yy-decy,xx+large-decx,yy+haut-decy);
    Rectangle(x-decx,y-decy,x+large-decx,y+haut-decy);
    ShowMouse;
    xx:=x;yy:=y
  UNTIL boutM=0;
  HideMouse;Rectangle(xx-decx,yy-decy,xx+large-decx,yy+haut-decy);ShowMouse;
  xx1:=xx-decx;yy1:=yy-decy;
  setWriteMode(NormalPut);
  SetLineStyle(solidLn,0,NormWidth);
END;

PROCEDURE Beep;
BEGIN
  Sound(440);Delay(50);
  Sound(480);Delay(50);
  Nosound;
END;

PROCEDURE AfficheFleche(xr,yr:INTEGER;f:flecheTab;coul:BYTE);
VAR n:BYTE;
BEGIN
  HideMouse;
  SetFillStyle(solidFill,coul);
  SetColor(coul);
  SetLineStyle(solidLn,0,1);
  FOR n:=1 TO 3 DO BEGIN
    WITH f[n] DO BEGIN
      x:=x+xr-4;
      y:=y+yr-4;
    END;
  END;
  FillPoly(3,f);
  ShowMouse;
END;

PROCEDURE FlecheHaut(xr,yr:INTEGER;couleur:BYTE);
VAR f:flecheTab;
    n:BYTE;
BEGIN
  f:=flecheH;
  AfficheFleche(xr,yr,f,couleur);
END;

PROCEDURE FlecheBas(xr,yr:INTEGER;couleur:BYTE);
VAR f:flecheTab;
    n:BYTE;
BEGIN
  f:=flecheB;
  AfficheFleche(xr,yr,f,couleur);
END;

PROCEDURE FlecheGauche(xr,yr:INTEGER;couleur:BYTE);
VAR f:flecheTab;
    n:BYTE;
BEGIN
  f:=flecheG;
  AfficheFleche(xr,yr,f,couleur);
END;

PROCEDURE FlecheDroite(xr,yr:INTEGER;couleur:BYTE);
VAR f:flecheTab;
    n:BYTE;
BEGIN
  f:=flecheD;
  AfficheFleche(xr,yr,f,couleur);
END;

PROCEDURE ChargeIcone(obj:iconeObjPtr;nom:STRING);
VAR f:FILE;
    p:^BYTE;
    t,tx,ty:WORD;

BEGIN
{$I-}
  nom:=dataDirectory+nom+'.ICO';
  assign(f,nom);
  Reset(f,1);
  t:=FileSize(f);
  getmem(p,t);
  BlockRead(f,tx,2);
  BlockRead(f,ty,2);
  BlockRead(f,p^,t-4);
  close(f);
  obj^.taille:=t;
  obj^.ptr:=@p^;
  obj^.x2:=obj^.x1+tx;
  obj^.y2:=obj^.y1+ty;
{$I+}
END;





{==============  PROCEDURE DE GESTION DES OBJETS VISIBLES  =================}


PROCEDURE AjouterObjetDansListe(obj:objetIndepPtr);
VAR p:elementListeObjPtr;
BEGIN
  IF (obj=NIL) THEN SysErr(NIL_PTR_ERR,'-> AjouterObjetDansListe : ajout NIL');
  IF NOT gestionObjetVisible THEN EXIT;
  IF listeObjetVisible<>NIL THEN listeObjetVisible^.objet^.Desactiver;
  NEW(p);
  p^.suiv:=listeObjetVisible;
  p^.objet:=obj;
  p^.prec:=NIL;
  p^.suiv^.prec:=p;
  listeObjetVisible:=p;
  INC(nbObjetVisible);
END;

PROCEDURE VerifierListeObjet;
BEGIN
  IF (listeObjetVisible=NIL) OR (listeobjetvisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,' ListeObjetVisible=NIL pdt fonctionnement');
END;


PROCEDURE SupprimerObjetActif;
VAR p:elementListeObjPtr;
BEGIN
  IF NOT gestionObjetVisible THEN EXIT;
  IF nbObjetVisible-1<=0 THEN EXIT;
  IF listeObjetVisible=NIL THEN EXIT;
  p:=listeObjetVisible;
  listeObjetVisible:=p^.suiv;
  Dispose(p);
  listeObjetVisible^.prec:=NIL;
  listeObjetVisible^.objet^.actif:=FALSE;
  listeObjetVisible^.objet^.activer;
  Dec(nbObjetVisible);
END;

PROCEDURE ActiverObjetCoordonnee(xm,ym:INTEGER);
VAR p,p1,p2:elementListeObjPtr;
    n,nbObjDessus,numObj:WORD;
    trouve,r:BOOLEAN;
BEGIN
  p:=listeObjetVisible;numObj:=0;trouve:=FALSE;
  gestionObjetVisible:=FALSE;
  FOR n:=1 TO nbObjetVisible DO BEGIN
    IF (p=NIL) OR (p^.objet=NIL) THEN SysErr(NIL_PTR_ERR,'ptr NIL pr objet ds ActiverObjetCoordonnee[zoneChoisie]');
    r:=p^.objet^.zoneChoisie(xm,ym);
    IF (r=TRUE) AND (trouve=FALSE) THEN BEGIN
      numObj:=n;
      p1:=p;
      trouve:=TRUE;
    END;
    p:=p^.suiv;
  END;
  IF NOT trouve THEN gestionObjetVisible:=TRUE;
  IF NOT trouve THEN EXIT;
  IF (listeObjetVisible=NIL) OR (listeobjetvisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,' ListeObjetVisible=NIL ds ActObjCoor[desctObjAct]');
  listeObjetVisible^.objet^.desactiver;
  nbObjDessus:=numObj-1;
  p:=listeObjetVisible;
  FOR n:=1 TO numObj DO BEGIN
    IF (p=NIL) OR (p^.objet=NIL) THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjCoor[restEcr]');    p^.objet^.restaureEcran;
    p^.objet^.visible:=FALSE;
    p:=p^.suiv;
  END;
  p2:=p1^.prec;
  p2^.suiv:=p1^.suiv;
  p1^.suiv^.prec:=p1^.prec;
  p1^.suiv:=listeObjetVisible;
  p1^.prec:=NIL;
  listeObjetVisible^.prec:=p1;
  listeObjetVisible:=p1;
  p:=p2;
  FOR n:=1 TO numObj DO BEGIN
    IF (p=NIL) OR (p^.objet=NIL) THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjCoor[affciher]');
    p^.objet^.afficher;
    p:=p^.prec;
  END;
  IF (listeobjetvisible=NIL) OR (listeObjetVisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjCoor[activer]');
  listeObjetVisible^.objet^.actif:=FALSE;
  listeObjetVisible^.objet^.activer;
  gestionObjetVisible:=TRUE;
  listeObjetVisible^.objet^.gerer(xm,ym);
END;

PROCEDURE ActiverObjetAdr(adrObjet:objetIndepPtr);
VAR p,p1,p2:elementListeObjPtr;
    n,nbObjDessus,numObj:WORD;
    trouve,r:BOOLEAN;
BEGIN
  IF (adrObjet=listeObjetVisible^.objet) OR NOT adrObjet^.visible THEN EXIT;

  p:=listeObjetVisible;numObj:=0;trouve:=FALSE;
  gestionObjetVisible:=FALSE;
  FOR n:=1 TO nbObjetVisible DO BEGIN
    IF p^.objet=adrObjet THEN r:=TRUE;
  IF (p=NIL) OR (p^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjAdr[recherche]');
    IF (r=TRUE) AND (trouve=FALSE) THEN BEGIN
      numObj:=n;
      p1:=p;
      trouve:=TRUE;
    END;
    p:=p^.suiv;
  END;
  IF NOT trouve THEN gestionObjetVisible:=TRUE;
  IF NOT trouve THEN EXIT;
  IF (listeobjetvisible=NIL) OR (listeObjetVisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjAdr[desactiver]');
  listeObjetVisible^.objet^.desactiver;
  nbObjDessus:=numObj-1;
  p:=listeObjetVisible;
  FOR n:=1 TO numObj DO BEGIN
  IF (p=NIL) OR (p^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjAdr[restaureEcran]');
    p^.objet^.restaureEcran;
    p^.objet^.visible:=FALSE;
    p:=p^.suiv;
  END;
  p2:=p1^.prec;
  p2^.suiv:=p1^.suiv;
  p1^.suiv^.prec:=p1^.prec;
  p1^.suiv:=listeObjetVisible;
  p1^.prec:=NIL;
  listeObjetVisible^.prec:=p1;
  listeObjetVisible:=p1;
  p:=p2;
  FOR n:=1 TO numObj DO BEGIN
  IF (listeobjetvisible=NIL) OR (listeObjetVisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjAdr[afficher]');
    p^.objet^.afficher;
    p:=p^.prec;
  END;
  IF (listeobjetvisible=NIL) OR (listeObjetVisible^.objet=NIL)
    THEN SysErr(NIL_PTR_ERR,'ptr NIL ds ActObjAdr[activer]');
  listeObjetVisible^.objet^.actif:=FALSE;
  listeObjetVisible^.objet^.activer;
  gestionObjetVisible:=TRUE;
END;


PROCEDURE VerifListe;
VAR p:elementListeObjPtr;
    n:BYTE;
    s:STRING;
BEGIN
  p:=listeObjetVisible;
  FOR n:=48+1 TO 48+nbObjetVisible DO BEGIN
    IF (p=NIL)  THEN BEGIN write(n);SysErr(NIL_PTR_ERR,' verification : ptr sur noeud NIL ds liste en pos : ');END;
    IF (p^.objet=NIL) THEN BEGIN write(n);SysErr(NIL_PTR_ERR,'verification : ptr sur obj NIL ds liste en pos : ');END;
    p:=p^.suiv;
  END;
    IF (p<>NIL) THEN BEGIN write(n);SysErr(NIL_PTR_ERR,'verification : fin list<> NIL ds liste en pos : ');END;
END;


PROCEDURE Execute;
VAR x,y:INTEGER;
    bout:BYTE;
    codeLu:codeclavier;
BEGIN
  IF NOT LSFinit THEN Halt(1);
  ChargementEnCours.cacher;nbobjetVisible:=0;
  listeObjetVisible:=NIL;
  lsfMenu.afficher;
  REPEAT
    Getmouse(x,y,bout);
    IF (bout<>0) AND MouseDriverLoaded THEN
    BEGIN
      VerifListe;
      IF listeObjetVisible^.objet^.zoneChoisie(x,y)
        THEN BEGIN listeObjetVisible^.objet^.gerer(x,y); END
        ELSE IF blocagePremierPlan THEN Beep
             ELSE ActiverObjetCoordonnee(x,y);
      VerifListe;
    END;
    IF Keypressed THEN
    BEGIN
      VerifListe;
      codelu[0]:=#2;
      codeLu[1]:=ReadKey;
      IF codeLu[1]=#0 THEN codelu[2]:=ReadKey
        ELSE codelu[0]:=#1;
      IF (codelu=#0#103) AND NOT blocagePremierPlan Then BEGIN
        lsfmenu.Afficher;
      END
      ELSE listeobjetVisible^.objet^.evenementClavier(codelu);
      showmouse;
      VerifListe;
    END;
  UNTIL (listeObjetVisible=NIL);
END;




{**************************************************************************
 *****************  PROCEDURES POINTEES "FAR"  ****************************
 **************************************************************************}
VAR
    x,y:INTEGER;
    bout,nombre:BYTE;
    sauveVecteur15:POINTER;





{$F+}

procedure SautAncIsr(oldisr:pointer);
INLINE($5b/$58/$87/$5e/$0e/$87/$46/$10/$89/$ec/$5d/$07/$1f/$5f/$5e/$5a/$59/$cb);


PROCEDURE NewTSR15(flags,cs,ip,ax,bx,cx,dx,si,di,ds,es,bp:WORD); INTERRUPT;
BEGIN
  IF ax=$8500 THEN
    sysRequest:=TRUE
  ELSE
    SautAncIsr(SauveVecteur15);
END;


PROCEDURE  FinSystemConfirmer(p:objetDepPtr);
BEGIN
  SYSERR(NO_ERR,'');
END;

PROCEDURE FinSystemAnnuler(p:objetDepPtr);
BEGIN
  blocagePremierPlan:=FALSE;
  FenetreFin.cacher;
END;



PROCEDURE quitterLSF(p:objetDepPtr);
VAR xm,ym:INTEGER;
BEGIN
  FenetreFin.afficher;
  blocagePremierPlan:=TRUE;
END;



FUNCTION  KeyboardStatus:CHAR;
VAR r:REGISTERS;
BEGIN
  r.ah:=$02;
  intr(16,r);
  KeyboardStatus:=CHAR(r.al);
END;


PROCEDURE Action(objet:objetIndepPtr);
BEGIN
 sound(500);delay(100); nosound;
END;


PROCEDURE RienObjIndep(objet:objetIndepPtr);
BEGIN END;

PROCEDURE RienObjDep(objet:objetDepPtr);
BEGIN END;



PROCEDURE AfficherLsfCopyright(p:objetDepPtr);
BEGIN
  lsfCopyright.afficher;
END;

{$F-}
{***************************************************************************}
{***************************************************************************}
{***************************************************************************}
VAR ni:BYTE;
    errParam:BOOLEAN;
    ch:STRING;
BEGIN
  errparam:=FALSE;
  dataDirectory:='c:\travail\tp\window\bml\';

  SwapVectors;

  driver:=detect;mode:=vgaHi;
  InitGraph(driver,mode,'c:\langage\tp\bgi\');
  directvideo:=FALSE;
  if driver=CGA then couleurCGA;
  Blanc:=White;
  Noir:=Black;
  GrisClair:=LightGray;
  GrisFonce:=DarkGray;
  SetFillStyle(SolidFill,darkGray);
  BAR(0,0,getmaxx,getmaxy);
  InitMouse;
  listeObjetVisible:=NIL;
  nbObjetVisible:=0;
  SetWriteMode(0);
  LSFinit:=TRUE;
  hideMouse;
  ShowMouse;
  WITH ChargementEnCours DO BEGIN
    Creer(GetMaxX DIV 2-143,GetMaxY DIV 2-40,GETMaxX DIV 2+143,GetMaxY DIV 2+40,
          grisclair,'MESSAGE SYSTEME');
    Ajouter(NEW(texteObjPtr,creer(131,17,'Chargement',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(texteObjPtr,creer(131,31,'    en',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(texteObjPtr,creer(135,44,' cours...',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(iconeObjPtr,creer(10,24,'LSFSIGLE',rienObjDep,#0#0)));
    Ajouter(NEW(iconeObjPtr,creer(240,24,'LOAD',rienObjDep,#0#0)));
  END;


  ChargementEnCours.afficher;



  WITH LSFmenu DO BEGIN
    creer(0,0,110,'* Lsf WIN *');
    supprimable:=FALSE;
    Ajouter('Copyright',AfficherLsfCopyright,NON,'c');
    Ajouter('Fin Session',QuitterLSF,NON,#0#33);
    Ajouter('---------------',rienObjDep,OUI,#0#0);
  END;

  WITH fenetreFin DO BEGIN
    Creer(250,150,450,310,GrisClair,'LsfWin : Fin system ?');
    Ajouter(NEW(CadreObjPtr,Creer(10,20,188,100,'Voulez vous quitter ?',rienObjDep)));
    Ajouter(NEW(BoutonObjPtr,Creer(18,35,95,90,NON,'Oui',8,REd,FinSystemConfirmer,#0#24)));
    Ajouter(NEW(BoutonObjPtr,Creer(105,35,178,90,NON,'Non',8,GREEN,FinSystemAnnuler,'n')));
    Ajouter(NEW(iconeObjPtr,creer(45,108,'LSFSIGLE',FinSystemAnnuler,#13)));
  END;


  WITH LSFcopyright DO BEGIN
    Creer(300,100,600,250,GrisClair,'Info');
    Ajouter(NEW(TexteObjPtr,creer(85,12,'Lsf  WIN',SansSerifFont,noir,5,1)));
    Ajouter(NEW(TexteObjPtr,creer(255,22,'TM',SmallFont,grisfonce,5,1)));
    Ajouter(NEW(texteObjPtr,creer(85,60,'Nicolas CLERC ø LIONSOFT 1991',
                                  smallFont,noir,4,0)));
    Ajouter(NEW(cadreObjPtr,creer(10,70,290,120,'',rienObjDep)));
    Ajouter(NEW(texteObjPtr,creer(17,77,'DOS System '+Chr(48+Lo(DosVersion))+
                            '.'+Chr(48+Hi(DosVersion)),SmallFont,noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(17,90,'Workspace '+LSFVER,SmallFont,
                                  noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(17,103,'Turbo Pascal 5.5',SmallFont,
                                  noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(178,77,'Processor : i80x86',SmallFont,
                                  noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(176,90,'Memory : 512Ko mini',SmallFont,
                                  noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(176,90,'Memory : 512Ko mini',SmallFont,
                                  noir,4,0)));
    Ajouter(NEW(texteObjPtr,creer(20,130,
                'Copyright LIONSOFT 1993, All Rights Reserved',
                SmallFont,RED,4,0)));
  END;

  WITH sauvegardeEnCours DO BEGIN
    Creer(GetMaxX DIV 2-143,GetMaxY DIV 2-40,GETMaxX DIV 2+143,GetMaxY DIV 2+40,
          grisclair,'MESSAGE SYSTEME');
    Ajouter(NEW(texteObjPtr,creer(131,17,'Sauvegarde',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(texteObjPtr,creer(131,31,'    en',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(texteObjPtr,creer(135,44,' cours...',smallFont,noir,6,
                TexteGras)));
    Ajouter(NEW(iconeObjPtr,creer(10,24,'LSFSIGLE',rienObjDep,#0#0)));
    Ajouter(NEW(iconeObjPtr,creer(240,24,'SAVE',rienObjDep,#0#0)));
  END;


END.












