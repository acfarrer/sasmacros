%macro mygsubpri(mypgm);
 /*data _null_;
   command="&gsconfigdir./sasgsub -gridsubmitpgm &mypgm" -gridjobopts queue=priority;
   call system(command);
  run;*/
filename results pipe "&gsconfigdir./sasgsub -gridsubmitpgm &mypgm -gridjobopts queue=priority";
data mygsubjob;
   infile results dlm=":" missover truncover;
   length Job $200. Info $200. ;
   input Job Info;
   if substr(job,1,1) not in ("J") then delete;
run;
title "My SASGSUB Jobs";
proc print data=mygsubjob; where info ne " ";
run;

%mend mygsubpri;
