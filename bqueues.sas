%macro bqueues;
filename bqueues pipe "bqueues";
data bqueues;
   infile bqueues firstobs=3 dlm=" ";
   length QueueName $20. Priority $20. Status $20. MaxJobs $5. JobsPerUser $5. JobsPerProcessor $5. 
          JobsPerHost $5. NumJobs $5. Pending $5. Running $5. Suspended $5.;
   input QueueName $ Priority $ Status $ MaxJobs $ JobsPerUser $ JobsPerProcessor $ JobsPerHost $ NumJobs $ Pending $ Running $ Suspended $;
   label MaxJobs="Max Jobs"
         JobsPerUser="Jobs Per User"
         JobsPerProcessor="Jobs Per CPU"
         JobsPerHost="Jobs Per Host"
         NumJobs="Num Jobs"
         Pending="Jobs Pend"
         Running="Jobs Run"
         Suspended="Jobs Susp"
         ;
   run;
title "Bqueues Listing";
proc print data=bqueues label;
run;
title;
%mend bqueues;

