%macro gsstatus(jobid=all);
filename results pipe "&gsconfigdir./sasgsub -gridgetstatus &jobid";
data status;
   infile results dlm="," missover truncover;
   length status $200. start $200. end $200. rc $10.;
   input status start end rc;
   if substr(status,1,1) in (" ","C","S") then delete;
run;
title "My SASGSUB Jobs Status";
proc print data=status;
run;
%mend gsstatus;



