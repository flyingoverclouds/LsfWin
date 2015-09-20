  USES  Crt;
  VAR
    Ch : Char;
  BEGIN
   repeat
     Ch := ReadKey;
     IF Ch = #0 THEN
       BEGIN
       Ch := ReadKey;
       WriteLn('D‚tect‚ touche … code ‚tendu : #00 + ',
               Ord(Ch));
       END
     ELSE
       WriteLn('D‚tect‚ touche de code ASCII : ',ch,' = ',
               Ord(Ch));
   until false
  END.
