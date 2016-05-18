%macro bhosts;
filename bhosts pipe "bhosts";
data bhosts;
   infile bhosts firstobs=2 dlm=" ";
   length HostName $20. Status $20. JobsPerUser $5. MaxJobs $5. NumJobs $5. Running $20. SSuspend $20. USuspend $20. RSV $20.;
   input HostName $ Status $ JobsPerUser $ MaxJobs $ NumJobs $ Running $ SSuspend $ USuspend $ RSV $;
label jobsperuser="Jobs Per User"
      Maxjobs="Max Jobs"
      numjobs="Num Jobs";
   run;
title "Bhosts Listing";
proc print data=bhosts label;
run;
title;
%mend bhosts;

