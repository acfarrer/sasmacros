%macro gskill(jobid=0000);
filename kill pipe "&gsconfigdir./sasgsub -gridkilljob &jobid";
data kill;
   infile kill;
   input Kill_Status $200.;
   if substr(Kill_Status,1,1)="S" then delete;
run;
title "Kill JobID &jobid Status";
proc print data=kill;
run;
%mend gskill;

