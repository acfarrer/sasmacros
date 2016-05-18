%macro gjobs;

filename jobs pipe "bjobs -a -w";

data jobs;

   infile jobs firstobs=2 dlm=" ";

   length job_id $20. user $20. status $20. queue $20. sub_server $20. ex_server $20. jobname $20. month $20. day $20. time $20.;

   input job_id $ user $ status $ queue $ sub_server $ ex_server $ jobname $ month $ day $ time $;

   *if substr(sasgsub_job_status,1,1)="S" then delete;

run;

title "My Grid Jobs Today";

proc print data=jobs;

run;

title;

%mend gjobs;

