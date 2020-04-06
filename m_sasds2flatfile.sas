/* Create flatfile from SAS dataset. SAS-L solution */
options mprint;
%macro flatfile(lib=,dsn=,file=);
  %let lib=%upcase(&lib);  /* uppercase library and dataset names */
  %let dsn=%upcase(&dsn);

 proc sql;
   create view temp as
     select name, type, format, length
     from dictionary.columns
     where libname = "&lib" and memname = "&dsn";
 quit;

 data _null_;
   set temp end=last;
   call symput ('var'!!left(put(_n_,3.)),name);
   if format ne ' ' then
       call symput ('fmt'!!left(put(_n_,3.)),format);
   else
     if upcase(type) = 'CHAR' then
       call symput ('fmt'!!left(put(_n_,3.)),'$'!!put(length,3.)!!'.');
     else
       call symput ('fmt'!!left(put(_n_,3.)),'best10.');

  if last then call symput('numvar',left(put(_n_,3.)));

   data _null_;
     set &lib..&dsn;
     file "&file";
     put
     %do i = 1 %to &numvar;
       &&var&i &&fmt&i +1
     %end;
     ;   /* end put statement */
   run;
 %mend;
%flatfile(lib=mydata,dsn=userdtls,file=c:\temp\userdtls.txt) ;