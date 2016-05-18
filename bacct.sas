%macro bacct(guser=all);
filename bacct pipe "bacct -u &guser";
data bacct;
   infile bacct truncover;
   input bacct_Status $400.;
   run;
title "Bacct Status for user &guser";
proc print data=bacct;
run;
%mend bacct;

