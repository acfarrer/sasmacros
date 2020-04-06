/* Whitlock's macro to loop thru months and execute another macro */
/* Note usage of %nrstr and %unquote */
%macro loop_through_months(startmon=, endmon=, sas_code_to_loop=);
    %local mon ;
    %do mon = %sysfunc(inputn(01&startmon,date9.))
              %to %sysfunc(inputn(01&endmon,date9.)) ;
        %unquote (&sas_code_to_loop)(mon=&mon)
        %let mon = %sysfunc(intnx(month,&mon,0,e)) ;
    %end;
%mend loop_through_months;

%macro test_macro(mon=);
    %put ====> test_macro executing,
curr_yyyymm=%sysfunc(putn(&mon,yymmn6.)) ;
%mend test_macro ;

%loop_through_months(startmon=dec2002,
                     endmon=feb2003,
                     sas_code_to_loop=%nrstr(%test_macro))
