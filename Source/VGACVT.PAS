USES crt;

{*************************************************************************
 **                                                                     **
 **       PROGRAMME de conversion des image capture par VGAB            **
 **                         en format BMP                               **
 **                                                                     **
 *************************************************************************}

VAR fichierSource,fichierBut:file;
    MemCharg:ARRAY[1..40000] of BYTE;

PROCEDURE VerifIO(nom:STRING);
BEGIN
  IF ioresult<>0 THEN BEGIN
    Writeln('   ERREUR I/O ',ioresult,' sur  ',nom);
    Halt(1);
  END;
END;

PROCEDURE Aide;
BEGIN
  Writeln(' Usage de VGAcvt : ');
  Writeln('     VGAvgt <chemin> <fichier.BML>');
  writeln('               Â         Â');
  writeln('               ³         ÀÄÄNom du fichier but SANS extension');
  writeln('               ÀÄÄÄÄÄÄÄÄÄÄÄÄChemin des fichier CPICBx.VGA');
  writeln;
  HALT(0);
END;


BEGIN
{$I-}
  Writeln(' ** VGAcvt : conversion d''image pour LSFWin');
  Writeln(' ** Copyright Lionsoft 1993');
  writeln(' ** Programme par Nicolas CLERC');
  writeln(' ** Disponible en shareware');
  writeln;

  IF paramstr(1)='/?' THEN aide;


  IF paramCount<>2 THEN BEGIN
    Writeln(' ERREUR : nombre de parametres incorrects !');
    writeln('  VGACVT /? pour aide');
    writeln;
    Halt(0);
  END;

  Assign(fichierBut,paramstr(2)+'.BML');
  Rewrite(fichierBut,1);
  verifIO(paramstr(2)+'.BML');

  Assign(fichierSource,paramstr(1)+'\CPICB0.EGA');
  Reset(fichierSource,1);
  verifIO(paramstr(1)+'\CPICB0.EGA');
  BlockRead(fichierSource,memcharg[1],7);
  BlockRead(fichierSource,memcharg[1],38400);
  BlockWrite(FichierBut,memcharg[1],38400);
  close(fichierSource);

  Assign(fichierSource,paramstr(1)+'\CPICB1.EGA');
  Reset(fichierSource,1);
  verifIO(paramstr(1)+'\CPICB1.EGA');
  BlockRead(fichierSource,memcharg[1],7);
  BlockRead(fichierSource,memcharg[1],38400);
  BlockWrite(FichierBut,memcharg[1],38400);
  close(fichierSource);

  Assign(fichierSource,paramstr(1)+'\CPICB2.EGA');
  Reset(fichierSource,1);
  verifIO(paramstr(1)+'\CPICB2.EGA');
  BlockRead(fichierSource,memcharg[1],7);
  BlockRead(fichierSource,memcharg[1],38400);
  BlockWrite(FichierBut,memcharg[1],38400);
  close(fichierSource);

  Assign(fichierSource,paramstr(1)+'\CPICB3.EGA');
  Reset(fichierSource,1);
  verifIO(paramstr(1)+'\CPICB3.EGA');
  BlockRead(fichierSource,memcharg[1],7);
  BlockRead(fichierSource,memcharg[1],38400);
  BlockWrite(FichierBut,memcharg[1],38400);
  close(fichierSource);

  close(fichierBut);

END.