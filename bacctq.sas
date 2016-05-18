%macro bacctq(guser=all, que=normal);
filename bacctq pipe "bacct -u &guser -q &que";
data bacctq;
   infile bacctq truncover;
   input bacct_Status $400.;
run;
title "Bacct Status for user &guser on queue &que";
proc print data=bacctq;
run;
%mend bacctq;

