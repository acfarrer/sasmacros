data ds1 (label=' 123456 - some text with spaces - more text') ; run ;
data ds2 (label='123456 - some text with spaces - more text') ; run ;
data ds3 (label=' 123456- some text with spaces - more text') ; run ;

%let feeddate = 123456 ;
option mlogic mprint  ;
%macro yymm(feedfile) ;
%global label feedyymm ;
%let dsid = %sysfunc(open(&feedfile,I)) ; /* Open dataset to read contents info */
%put &dsid ;
%if (&dsid = 0) %then %put %sysfunc(sysmsg()) ;
%else %do ;
	%let label = %sysfunc(attrc(&dsid,label));
	%put %sysfunc(attrc(&dsid,label)) ;
	%if %bquote(&label) ne %str( ) %then %do ;
    	%let feedyymm = %scan(%sysfunc(attrc(&dsid,label)),1,'-') ;
		%if %scan(%sysfunc(attrc(&dsid,label)),1,'-') ne &feeddate %then %put 
		    Dates do not match ;
	%end ;
	%else %put No label found ;
    %let RC = %sysfunc(close(&dsid));
%end ;
%put &label &feedyymm ;
%mend yymm ;
*yymm(ds1) ;
*yymm(ds2) ;
%yymm(ds3) ;
%put &label &feedyymm ;

proc datasets lib = work ;
modify ds1 (label='123456- some other text with spaces - source file details') ;
quit ;