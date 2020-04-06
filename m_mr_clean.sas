/* From https://blogs.sas.com/content/sgf/2018/07/17/delete-sas-logs-admin/ */
%macro mr_clean(dirpath=,dayskeep=30,ext=.log);
   data _null_;
      length memname $256;
      deldate = today() - &dayskeep;
      rc = filename('indir',"&dirpath");
      did = dopen('indir');
      if did then
      do i=1 to dnum(did);
         memname = dread(did,i);
         if reverse(trim(memname)) ^=: reverse("&ext") then continue;
         rc = filename('inmem',"&dirpath/"!!memname);
         fid = fopen('inmem');
         if fid then 
         do;
            moddate = input(finfo(fid,'Last Modified'),date9.); /* see WARNING below */
            rc = fclose(fid);
            if . < moddate <= deldate then rc = fdelete('inmem');
         end;
      end; 
      rc = dclose(did);
      rc = filename('inmem');
      rc = filename('indir');
   run;
%mend mr_clean;

/*
WARNING: In most cases, finfo(fid,'Last Modified') returns a date/time string in the DDMMMYYYY:HH:MM:SS format as described in the Usage Note 40934. In these cases applying DATE9 informat produces valid SAS date. In some other cases using ANYDTDTM informat may be appropriate. However, as reported by reader Rajeev Meena there are OS installations that return date/time strings in some odd formats, such as "Mon Jun 21 11:11:00 2018". I am not aware of any SAS informat that can directly convert such a string into SAS date. In such cases, some string parsing might be in order to get a convertible string (see Rajeev's suggested solution in his comment below). I suggest checking your operating system for returned date/time string format by running the following code:

data _null_;
   rc = filename('infile','full_path_name_of_any_existing_file');
   fid = fopen('infile');
   s = finfo(fid,'Last Modified');
   rc = fclose(fid);
   put s=;
run;

*/