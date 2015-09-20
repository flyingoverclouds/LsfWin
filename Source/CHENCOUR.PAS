  WITH ChargementEnCours DO BEGIN
    Creer(GetMaxX DIV 2-150,GetMaxY DIV 2-50,GETMaxX DIV 2+150,GetMaxY DIV 2+50,
          grisClair,'MESSAGE SYSTEME');
    Ajouter(NEW(texteObjPtr,creer(120,20,'Chargement',SmallFont,noir,4,
                TexteGrasDB)));
    Ajouter(NEW(texteObjPtr,creer(120,30,'    en',SmallFont,noir,4,
                TexteGrasDB)));
    Ajouter(NEW(texteObjPtr,creer(124,40,'  cours',SmallFont,noir,4,
                TexteGrasDB)));
    Ajouter(NEW(iconeObjPtr,creer(30,24,'LSFSIGLE',rienObjDep)));
    Ajouter(NEW(iconeObjPtr,creer(240,24,'LOAD',rienObjDep)));
  END;
