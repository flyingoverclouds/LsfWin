{$M 16384,0,655360}

{==========================================================================
 ==                                                                      ==
 ==                     LIONSOFT 1991 : TEST LsfWin 0.5                  ==
 ==                                                                      ==
 ==                         (p) & (c) LIONSOFT 1992                      ==
 ==========================================================================}




USES Dos,Crt,Mouse,Graph,lsfwin;

TYPE partGateauPtr=^partGateau;
     partGateau=OBJECT(boutonObj)
       px,py:INTEGER;
     END;

CONST nbjmax=9;

VAR copyright,
    paletteCoul,
    fenprincipalegrignotte,
    plusInfo,
    configuration:fenetreObj;
    menugrignotte:menuObj;
    x,y:INTEGER;
    bout,nbj,jc,savnbj:BYTE;
    gateau:ARRAY [0..9,0..9] OF PartGateau;
    initOK:BOOLEAN;
    joueurCourant,nbjoueur:texteObj;
    finirConfiguration,
    empoisonne,
    DejaMange:fenetreObj;
    sbpro,
    fenChangementFond:fenetreObj;


{**************************************************************************
 *****************  PROCEDURES POINTEES "FAR"  ****************************
 **************************************************************************}
{$F+}




PROCEDURE ActiverPalette(p:ObjetDepPtr);
BEGIN
  paletteCoul.afficher;
END;

PROCEDURE Info(p:objetDepPtr);
BEGIN
  copyright.afficher;
END;

Procedure RecommencerGrignotte(p:objetdepPtr);
VAR x,y:INTEGER;
BEGIN
  IF NOT InitOk THEN EXIT;
  joueurCourant.texte:='1';
  jc:=1;
  FOR Y:=0 TO 9 DO
    FOR x:=0 TO 9 DO
    IF gateau[x,y].presser THEN BEGIN
      gateau[x,y].titre:='*';
      gateau[x,y].presser:=FALSE;
    END;
  gateau[0,0].titre:='P';
  fenprincipalegrignotte.afficher;
END;

PROCEDURE DebloquerPremierPlan(p:objetDepPtr);
BEGIN
  BlocagePremierPlan:=FALSE;
  p^.possesseur^.cacher;
END;


PROCEDURE CrocPoison(p:objetDepPtr);
BEGIN
  BlocagePremierPlan:=FALSE;
  p^.possesseur^.cacher;
  recommencerGrignotte(p);
  fenprincipaleGrignotte.cacher;
  jc:=1;
  joueurCourant.texte:='1';
  fenPrincipaleGrignotte.afficher;
END;


PROCEDURE ClicGateau(p:objetdepptr);
VAR part:partgateauptr;
    x,y:INTEGER;
    savCoul:BYTE;
BEGIN
  IF configuration.visible THEN BEGIN
    finirconfiguration.afficher;
    BlocagePremierPlan:=TRUE;
    EXIT;
  END;
  part:=@p^;
  IF (part^.px=0) AND (part^.py=0) THEN BEGIN
    empoisonne.afficher;
    BlocagePremierPlan:=TRUE;
    EXIT;
  END;
  IF part^.presser THEN BEGIN
    dejaMange.afficher;
    blocagePremierPlan:=TRUE;
    Exit;
  END;
  FOR y:=part^.py to 9 do
  BEGIN
    for x:=part^.px to 9 do
    BEGIN
      IF NOT gateau[x,y].presser THEN
      BEGIN
        gateau[x,y].presser:=TRUE;
        gateau[x,y].titre:=' ';
        gateau[x,y].afficher;
      END;
    END;
  END;
  savCoul:=joueurCourant.couleur;
  joueurCourant.couleur:=fenprincipaleGrignotte.couleurFond;
  joueurCourant.afficher;
  IF jc=nbj THEN jc:=1 ELSE inc(jc);
  str(jc,joueurCourant.texte);
  joueurCourant.couleur:=savCoul;
  joueurCourant.afficher;
  REPEAT GetMouse(x,y,bout) UNTIL bout=0;
END;


PROCEDURE InitGateau;
VAR x,y:BYTE;
BEGIN
  nbj:=2;
  jc:=1;
  savnbj:=2;
  str(nbj,nbjoueur.texte);
  str(jc,joueurCourant.texte);
  IF InitOK THEN EXIT;
  FOR Y:=0 TO 9 DO
    FOR x:=0 TO 9 DO
    WITH gateau[x,y] DO BEGIN
      gateau[x,y].creer(x*15+2,y*15+15,x*15+16,y*15+14+15,OUI,
                        '*',4,grisclair,ClicGateau,#0#0);

      gateau[x,y].px:=x;
      gateau[x,y].py:=y;
      fenprincipalegrignotte.ajouter(@gateau[x,y]);
    END;
  Gateau[0,0].detruire;
  gateau[0,0].Creer(2,15,14+2,14+15,OUI,'P',4,RED,ClicGateau,#0#0);
  InitOk:=TRUE;
  fenprincipalegrignotte.ajouter(NEW(texteObjPtr,Creer(10,163,'Joueur Nø ',
                GothicFont,Yellow,3,TexteNormal)));
  joueurCourant.creer(135,163,'1',GothicFont,green,3,TexteNormal);
  fenprincipalegrignotte.ajouter(@joueurcourant);
END;


PROCEDURE Activergrignotte(p:objetDepPtr);
BEGIN
  initGateau;
  ActiverObjetAdr(@menuGrignotte);
  menuGrignotte.afficher;
  ActiverObjetAdr(@fenPrincipaleGrignotte);
  FenPrincipalegrignotte.afficher;
END;

PROCEDURE Configurer(p:objetDepPtr);
BEGIN
  configuration.afficher;
END;

PROCEDURE Beep(p:objetDepPtr);
BEGIN
  sound(440);delay(500);nosound;
END;

PROCEDURE Fingrignotte(p:objetdepPtr);
BEGIN
  menugrignotte.cacher;
  fenPrincipalegrignotte.cacher;
  configuration.cacher;
END;

PROCEDURE ChangenbJoueur(p:objetDepPtr);
VAR b:boutonObjPtr;
    savCoul:BYTE;
BEGIN
  b:=@p^;
  savCoul:=NbJoueur.couleur;
  nbjoueur.couleur:=configuration.couleurFond;
  nbjoueur.afficher;
  IF b^.titre='-' THEN IF savnbj>1 THEN Dec(savnbj);
  IF b^.titre='+' THEN IF savnbj<nbjmax THEN inc(savnbj);
  str(savnbj,nbjoueur.texte);
  nbjoueur.couleur:=savCoul;
  nbjoueur.afficher;
END;


PROCEDURE OKnbJoueur(p:objetDepPtr);
BEGIN
  nbj:=savnbj;
  configuration.cacher;
  recommencerGrignotte(p);
END;


PROCEDURE InfoPlus(p:objetDepPtr);
BEGIN
  plusinfo.afficher;
END;

PROCEDURE ChutSynthe(p:ObjetDepPtr);
BEGIN
  Nosound;
END;

PROCEDURE _Do(p:objetDepPtr);
BEGIN
  nosound;
  sound(261);
END;

PROCEDURE _Dod(p:objetDepPtr);
BEGIN
  nosound;
  sound(277);
END;

PROCEDURE _re(p:objetDepPtr);
BEGIN
  nosound;
  sound(293);
END;

PROCEDURE _red(p:objetDepPtr);
BEGIN
  nosound;
  sound(311);
END;


PROCEDURE _mi(p:objetDepPtr);
BEGIN
  nosound;
  sound(329);
END;

PROCEDURE _fa(p:objetDepPtr);
BEGIN
  nosound;
  sound(349);
END;

PROCEDURE _fad(p:objetDepPtr);
BEGIN
  nosound;
  sound(369);
END;


PROCEDURE _sol(p:objetDepPtr);
BEGIN
  nosound;
  sound(391);
END;

PROCEDURE _sold(p:objetDepPtr);
BEGIN
  nosound;
  sound(415);
END;



PROCEDURE _la(p:objetDepPtr);
BEGIN
  nosound;
  sound(440);
END;

PROCEDURE _lad(p:objetDepPtr);
BEGIN
  nosound;
  sound(466);
END;



PROCEDURE _si(p:objetDepPtr);
BEGIN
  nosound;
  sound(493);
END;



PROCEDURE AfficherPreference(p:objetDepPtr);
BEGIN
  ActiverObjetAdr(@fenChangementFond);
  fenChangementFond.afficher;
END;



PROCEDURE ChargerDick(p:objetdepPtr);
BEGIN
  ChargerFondEcran('dick.bml');
END;
PROCEDURE ChargerEinstein(p:objetdepPtr);
BEGIN
  ChargerFondEcran('albert.bml');
END;
PROCEDURE ChargerEarth(p:objetdepPtr);
BEGIN
  ChargerFondEcran('earth.bml');
END;
PROCEDURE ChargerPhenix(p:objetdepPtr);
BEGIN
  ChargerFondEcran('phoenix.bml');
END;
PROCEDURE ChargerSigle(p:objetdepPtr);
BEGIN
  ChargerFondEcran('sigliut.bml');
END;
PROCEDURE Chargercarte(p:objetdepPtr);
BEGIN
  ChargerFondEcran('carte.bml');
END;

{$F-}
{***************************************************************************}
{***************************************************************************}
{***************************************************************************}
VAR ni:BYTE;


BEGIN

  paletteCoul.creer(50,50,130,50+(GetMaxColor+1)*20+25,grisClair,'Palette');
  FOR ni:=0 TO GetMaxColor DO
    paletteCoul.ajouter(NEW(boiteObjPtr,creer(5,20+ni*20,75,20+ni*20+15,ni
                        ,rienObjDep)));

  WITH menuGrignotte DO BEGIN
    Creer(1,1,100,'WSB MENU');
    Ajouter('Configurer',configurer,NON,'c');
    Ajouter('Finir',fingrignotte,NON,'f');
    Ajouter('Recommencer',recommencergrignotte,NON,'r');
  END;

  WITH fenprincipalegrignotte DO BEGIN
    Creer(100,100,253,300,GrisClair,'Jeu de la Grignotte');
  END;

  WITH configuration DO BEGIN
    Creer(250,150,450,310,GrisClair,'Grignotte : Configuration');
    Ajouter(NEW(CadreObjPtr,Creer(10,20,188,100,'Nombre de joueur(s)',rienObjDep)));
    Ajouter(NEW(BoutonObjPtr,Creer(18,35,85,90,NON,'+',20,GrisClair,changeNbJoueur,'+')));
    Ajouter(NEW(BoutonObjPtr,Creer(115,35,178,90,NON,'-',20,GrisClair,changeNbJoueur,'-')));
    nbJoueur.Creer(95,45,'2',triplexFont,NOIR,3,3);
    Ajouter(@nbjoueur);
    Ajouter(NEW(iconeObjPtr,creer(45,108,'LSFSIGLE',OKnbJoueur,#13#0)));
  END;

  WITH finirConfiguration DO BEGIN
    Creer(250,120,420,198,YELLOW,'Finir la configuration');
    Ajouter(NEW(boutonObjPtr,Creer(10,24,160,62,NON,'~H',15,Grisclair,
                debloquerPremierPlan,#13#0)));
  END;

  WITH empoisonne DO BEGIN
    Creer(250,120,420,198,RED,'The Death ...');
    Ajouter(NEW(boutonObjPtr,Creer(10,24,160,62,NON,'You''re Dead !',5,Grisclair,
                CrocPoison,#13#0)));
  END;

  WITH dejaMange DO BEGIN
    creer(250,120,420,198,GrisClair,'Plus faim ?');
    Ajouter(NEW(boutonObjPtr,Creer(10,24,160,62,NON,'Miam Miam ?',5,Green,
                debloquerPremierPlan,#13#0)));
  END;


  WITH PlusInfo DO BEGIN
    Creer(20,20,220,320,GrisClair,'Plus d''info ? : en Voila !');
    Ajouter(NEW(texteObjPtr,creer(18,7,'Lsf WIN',sansserifFont,noir,5,1)));
    Ajouter(NEW(TexteObjPtr,creer(168,17,'TM',smallfont,grisfonce,5,1)));
    Ajouter(NEW(cadreObjPtr,creer(10,55,190,150,'Programmeurs',rienObjDep)));
    Ajouter(NEW(TexteObjPtr,creer(18,65,'Id‚e originale :',
                smallFont,noir,4,TexteNormal)));
    Ajouter(NEW(TexteObjPtr,creer(80,75,'Nicolas CLERC',
                smallFont,blue,4,TexteNormal)));
    Ajouter(NEW(TexteObjPtr,creer(18,95,'Graphisme et ‚ffet relief',
                smallFont,noir,4,TexteNormal)));
    Ajouter(NEW(TexteObjPtr,creer(80,105,'Nicolas CLERC',
                smallFont,yellow,4,TexteNormal)));
    Ajouter(NEW(TexteObjPtr,creer(18,125,'Programmation :',
                smallFont,noir,4,TexteNormal)));
    Ajouter(NEW(TexteObjPtr,creer(80,135,'Nicolas CLERC',
                smallFont,red,4,TexteNormal)));
    Ajouter(NEW(cadreObjPtr,creer(10,155,190,290,' AUTRES ',rienObjDep)));
    Ajouter(NEW(ascenceurVertiObjPtr,creer(12,162,87,60,100)));
    Ajouter(NEW(ascenceurHorizObjPtr,creer(30,272,120,60,100)));
    Ajouter(NEW(saisieObjPtr,creer(38,170,16,150,
                'Boite de Saisie !!!!!!!  N''est ce pas qu''elle est bien mon interface ? ',
                noir,green,#0#0)));
    Ajouter(New(boutonObjPtr,Creer(46,192,60,220,OUI,'Z',3,grisfonce,_dod,'z')));
    Ajouter(NEW(boutonObjPtr,creer(68,192,82,220,OUI,'E',3,grisfonce,_red,'e')));
    Ajouter(NEW(boutonObjPtr,creer(112,192,126,220,OUI,'T',3,grisfonce,_fad,'t')));
    Ajouter(NEW(boutonObjPtr,creer(134,192,148,220,OUI,'Y',3,grisfonce,_sold,'y')));
    Ajouter(NEW(boutonObjPtr,creer(156,192,170,220,OUI,'U',3,grisfonce,_lad,'u')));
    Ajouter(NEW(boutonObjPtr,creer(32,250,185,269,NON,'Chut ...',4,grisClair,chutSynthe,'ý')));
    Ajouter(NEW(boutonObjPtr,creer(32,190,53,248,OUI,'Q',3,grisclair,_do,'q')));
    Ajouter(NEW(boutonObjPtr,creer(54,190,75,248,OUI,'S',3,grisclair,_re,'s')));
    Ajouter(NEW(boutonObjPtr,creer(76,190,97,248,OUI,'D',3,grisclair,_mi,'d')));
    Ajouter(NEW(boutonObjPtr,creer(98,190,119,248,OUI,'F',3,grisclair,_fa,'f')));
    Ajouter(NEW(boutonObjPtr,creer(120,190,141,248,OUI,'G',3,grisclair,_sol,'g')));
    Ajouter(NEW(boutonObjPtr,creer(142,190,163,248,OUI,'H',3,grisclair,_la,'h')));
    Ajouter(NEW(boutonObjPtr,creer(164,190,185,248,OUI,'J',3,grisclair,_si,'j')));
  END;

  WITH fenChangementFond DO BEGIN
       Creer(150,150,280,340,GrisClair,'Changement Fond');
       Ajouter(NEW(boutonObjPtr,creer(10,25,120,50,NON,'Dick Tracy',4,grisclair,ChargerDick,'d')));
       Ajouter(NEW(boutonObjPtr,creer(10,55,120,80,NON,'Albert Einstein',4,grisclair,chargerEinstein,'a')));
       Ajouter(NEW(boutonObjPtr,creer(10,85,120,110,NON,'Earth',4,grisclair,chargerEarth,'e')));
       Ajouter(NEW(boutonObjPtr,creer(10,115,120,140,NON,'Phoenix',4,grisclair,chargerPhenix,'p')));
       Ajouter(NEW(boutonObjPtr,creer(10,145,120,170,NON,'Carte',4,grisclair,chargerCarte,'c')));
  END;



  ShowMouse;
  LSFmenu.ajouter('Jeu de la GRIGNOTTE',activergrignotte,NON,'g');
  Lsfmenu.deplacer(50,50);
  LsfMenu.ajouter('plus Info',infoplus,NON,'i');
  lsfMenu.ajouter('Fond d''ecran',afficherPreference,NON,'f');
  InitOk:=FALSE;
  EXECUTE;

END.


