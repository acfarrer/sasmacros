%macro gjobs94;

filename jobs94 pipe "bjobs -a -w";

data jobs94;

   infile jobs94 firstobs=2 dlm=" " missover truncover;

   length job_id $20. user $20. status $20. queue $20. sub_server $20. ex_server $20. jobname $80. month $30. day $30. time $30. 
          temp1 $30. temp2 $30. temp3 $30. temp4 $30. temp5 $30. temp6 $30. temp7 $30. temp8 $30. temp9 $30. temp10 $30. temp11 $30. temp12 $30.;

   input job_id $ user $ status $ queue $ sub_server $ ex_server $ jobname $ month $ day $ time $ 
         temp1 $ temp2 $ temp3 $ temp4 $ temp5 $ temp6 $ temp7 $ temp8 $ temp9 $ temp10 $ temp11 $ temp12 $;

   *if substr(sasgsub_job_status,1,1)="S" then delete;

   if temp12 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4)||trim(temp5)||trim(temp6)||trim(temp7)||trim(temp8)||trim(temp9);
      month=trim(temp10);
      day=trim(temp11);
      time=trim(temp12); 
   end; 
   else if temp11 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4)||trim(temp5)||trim(temp6)||trim(temp7)||trim(temp8);
      month=trim(temp9);
      day=trim(temp10);
      time=trim(temp11); 
   end;
   else if temp10 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4)||trim(temp5)||trim(temp6)||trim(temp7);
      month=trim(temp8);
      day=trim(temp9);
      time=trim(temp10); 
   end; 
   else if temp9 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4)||trim(temp5)||trim(temp6);
      month=trim(temp7);
      day=trim(temp8);
      time=trim(temp9); 
   end; 
   else if temp8 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4)||trim(temp5);
      month=trim(temp6);
      day=trim(temp7);
      time=trim(temp8); 
   end;
   else if temp7 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3)||trim(temp4);
      month=trim(temp5);
      day=trim(temp6);
      time=trim(temp7); 
   end;  
   else if temp6 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2)||trim(temp3);
      month=trim(temp4);
      day=trim(temp5);
      time=trim(temp6); 
   end;  
   else if temp5 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1)||trim(temp2);
      month=trim(temp3);
      day=trim(temp4);
      time=trim(temp5); 
   end;  
   else if temp4 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time)||trim(temp1);
      month=trim(temp2);
      day=trim(temp3);
      time=trim(temp4); 
   end;   
   else if temp3 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day)||trim(time);
      month=trim(temp1);
      day=trim(temp2);
      time=trim(temp3); 
   end;   
   else if temp2 ne " " then do; 
      jobname=trim(jobname)||trim(month)||trim(day);
      month=trim(time);
      day=trim(temp1);
      time=trim(temp2); 
   end; 
   else if temp1 ne " " then do; 
      jobname=trim(jobname)||trim(month);
      month=trim(day);
      day=trim(time);
      time=trim(temp1); 
   end; 
run;

title "My Grid Jobs Today";

proc print data=jobs94;

var job_id user status queue sub_server ex_server jobname month day time;
run;

title;

%mend gjobs94;

