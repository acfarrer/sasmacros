%macro macrovar2runrecord(outdir) ;
/* Dump all session macrovars to one line of named values */
/* Allows loose structure that can be queried and appended */
%if %bquote(&outdir) eq %str( ) %then %let outdir = !TMP ;
%if &SYSSCP eq 'WIN' %then %let slash = %str(\) ;
                     %else %let slash = %str(/) ;
data _null_ ;
file "&outdir.&slash.runparms.txt" mod /* Force append */ ls=2000 ;
set sashelp.vmacro 
	(where=(scope = 'GLOBAL' and 
            name not like 'SQL%' and
			name not = 'USERPW'
			)
	) ;
if _n_ = 1 then do ;
  recordhdr = 
  "rundate=%sysfunc(today(),date9.) runtime=%sysfunc(time(),time5.) 
 sysjobid=&sysjobid sysuserid=&sysuserid ## " ;
   put recordhdr @ ;
end ;
put name +(-1) '=' value '## ' @ ;
run ;
/* Create view in same location that can be expanded as nec. */
libname here "&outdir" ;

data here.runparms /view=here.runparms ;
infile 'runparms.txt' ;
length 	rundate $ 9
		runtime $ 5  
		sysuserid $ 8
		PATH $ 20 
		USERID $ 8
		MLIB $ 22 ;
input rundate= 
	runtime=  
	sysjobid= 
	sysuserid= 
	PATH= 
	USERID= 
	MLIB= ;
run ;
libname here clear ;

%mend macrovar2runrecord ;  
