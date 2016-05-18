%macro gsresults(jobid=all, mydir=c:\sas\grpb\bstuff);
 filename results pipe "&gsconfigdir./sasgsub -gridgetresults &jobid -gridresultsdir &mydir";
data results;
   infile results dlm="," missover truncover;
   length Result_Status $100. Start $100. End $100. RC $10.;
   input Result_Status Start End RC;
   if substr(Result_Status,1,1) in ("S","C"," ") then delete;
run;
title "Move Results JobID &jobid Status";
proc print data=results;
  var Result_Status ;
run;
%mend gsresults;

