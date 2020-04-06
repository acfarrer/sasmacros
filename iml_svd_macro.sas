/* Create SVD data from report data created by %psi_extract */
/* User edits*/
%let yymm = 0710 ;
%let period = AP ;
%let env = test ;
/* No more user edits. Readonly from here*/

%let libref = PD&yymm.&period. ;
libname &libref "/conslend1/rmar/&env./PD_20&yymm.&period./sasdata" server = sasunix access = readonly ;
%let keepvars = ;

%macro iml_svd(prodcode=) ;
/* Use _REPT_DATA from /conslend1/rmar/test/saslib/psi_extract_batch.sas*/
proc sql noprint ;
select memname into :memname
from dictionary.tables 
where libname = "&libref"
and memname like "PD^_^_REPT^_DATA^_&prodcode._M%" escape '^' ;

%put memname = &memname ;

select   name into :keepvars separated by ' ' 
from dictionary.columns 
where libname = "&libref."
and memname = "&memname."
and name not = 'TOTAL_PCT'
and name like '%_PCT' 
;

%let nvars = &sqlobs ;
quit ;

%put nvars = &nvars ;
%put keepvars = &keepvars ;

DATA TRAN_&prodcode. (KEEP=&KEEPVARS);
     SET &libref..&memname ;
	 WHERE UPCASE(SUBSTR(START_SEG_ID,1,5)) NE UPCASE('TOTAL');
RUN;

PROC IML;
     RESET PRINT;
     USE TRAN_&prodcode.; 
     READ ALL VAR _NUM_ INTO MAT_&prodcode.;
	 MAT_&prodcode.=MAT_&prodcode.-I(&nvars);
 
	 CALL SVD(U_&prodcode.,Q_&prodcode.,V_&prodcode.,MAT_&prodcode.); 

	 CREATE SVD_&prodcode. FROM Q_&prodcode ;
	 APPEND FROM Q_&prodcode.;
QUIT;

title "SVD Mean from &libref..&memname " ;

PROC MEANS DATA=SVD_&prodcode.;
     OUTPUT OUT=SVD_&prodcode._MEAN MEAN=MEANQ_&prodcode.;
RUN;
%mend iml_svd ;

options ps=65 ls=175 nocenter ;
*iml_svd(prodcode =CSC_ ) ;
%iml_svd(prodcode =FLNX ) ;
*iml_svd(prodcode =HOLC ) ;
*iml_svd(prodcode =MORT ) ;


