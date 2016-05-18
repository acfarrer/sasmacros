%macro egoshv(service=ProcessManager);
filename egoshv pipe "egosh service view &service";
data egoshv;
   length egosh_service_view $90.;
   infile egoshv firstobs=2 truncover;
   input @1 egosh_service_view $90.;
run;
title "EGO View of Service &service";
proc print data=egoshv;
run;
%mend egoshv;

