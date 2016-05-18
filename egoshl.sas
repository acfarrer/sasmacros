%macro egoshl;
filename egoshl pipe "egosh service list -l";
data egoshl;
   infile egoshl firstobs=2 missover;
   length SERVICE $20. STATE  $20. ALLOC $20. CONSUMER $20. RGROUP $20. RESOURCE $20. SLOTS $20. SEQ_NO $20. INST_STATE $20.  ACTI $20.;
   input @1 SERVICE $ @24 STATE $ @37 ALLOC $ @43 CONSUMER $ @66 RGROUP $ @89 RESOURCE $ @112 SLOTS $ @120 SEQ_NO $ @128 INST_STATE $ @141 ACTI $ ;
if service in ("res" "sbatchd") then delete;
if service = state then delete;
run;
title "My EGO Controlled Services";
proc print data=egoshl;
   var service resource state inst_state;
run;
title;
%mend egoshl;

