/* From Chung Chang: http://listserv.uga.edu/cgi-bin/wa?A2=ind0508E&L=sas-l&P=R7400 */
/* Other, weaker common tests are: */
/* %if &VAR= %then <insert code>*/
/* %if "&VAR"="" %then <insert code>*/
/* %if &VAR=%str() %then <insert code>*/

%macro test(var);
  %if "%superq(var)"="" %then
    %put **%superq(var)** is nothing;
  %else
    %put **%superq(var)** is something;
%mend;

%test(yes)
%test(%str( ))
%test(%str())
%test()
%test(  )
%test(%str(%"))
/*
**yes** is something
** ** is something
**** is nothing
**** is nothing
**** is nothing
**"** is something
*/ 
