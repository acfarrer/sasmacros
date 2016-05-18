%macro lsload;
filename lsload pipe "lsload";
data lsload;
   infile lsload firstobs=2 dlm=" ";
   length HostName $20. Status $20. r15s $20. r1m $20. r15m $20. CPU_utilization $20. pg $20. ls $20. it $20. tmp $20. swp $20. mem $20.;
   input HostName $ Status $ r15s $ r1m $ r15m $ CPU_utilization $ pg $ ls $ it $ tmp $ swp $ mem $;
   run;
title "lsload Listing";
proc print data=lsload;
run;
title;
%mend lsload;

