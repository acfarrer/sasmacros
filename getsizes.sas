%macro getsizes ( data = &syslast
                , out = sizes
                , critpct = 10 ) ;
   %local nvc nvn critcnt ;
   %let data = &data ;
   data _null_ ;
      set &data nobs=nobs ;
      call symputx ( "critcnt" , nobs * &critpct / 100 ) ;
      array __xn (*) _numeric_ ;
      call symputx ( "nvn" , dim(__xn) ) ;
      array __xc (*) _character_ ;
      call symputx ( "nvc" , dim(__xc) ) ;
      stop ;
   run ;

   data &out ( keep = var ndistinct misscnt role) ;
      goto main ; %* buffer must be at top of step ;
   read: set &data end = eof ; return ;
   main:
      %if &nvn > 0 %then %__gszsetup ( t = n ) ;
      %if &nvc > 0 %then %__gszsetup ( t = c ) ;
      length var $ 32 role $10 ndistinct misscnt 8 ;
      do until ( eof ) ;
         link read ;
         %if &nvn > 0 %then %__gszloop ( t = n ) ;
         %if &nvc > 0 %then %__gszloop ( t = c ) ;
      end ;
      %if &nvn > 0 %then %__gszeof ( t = n ) ;
      %if &nvc > 0 %then %__gszeof ( t = c ) ;
      ***remn.output(dataset: "work.lookn") ;
      ***remc.output(dataset: "work.lookc") ;
   run ;
%mend  getsizes ;
%macro __gszsetup ( t = n /* or c */ ) ;
      %let t = %upcase (&t) ;
      array __x&t (&&nv&t )
         %if &t = C %then _character_ ;
         %else _numeric_ ;
      ;
      array __cts&t (&&nv&t) _temporary_ ;
      array __mct&t (&&nv&t) _temporary_ ;
      %if &t = C %then
          %str(length __valC $200 ;) ;
      if _n_ = 1 then
      do ;
         declare hash rem&t(hashexp:16) ;
         rc = rem&t..defineKey("__ix", "__val&t" ) ;
         rc = rem&t..defineData ( "__ix", "__val&t" ) ;
         call missing ( __ix, __val&t ) ;
         rc = rem&t..defineDone() ;
      end ;
%mend  __gszsetup ;

%macro __gszloop ( t = n /* or c */
                 , eff = 1
                      /* 1 counts stop at critical pt
                         0 no stop
                      */
                 ) ;
         %let t = %upcase(&t) ;
         do __ix = 1 to dim ( __x&t ) ;
            __val&t = __x&t[__ix] ;
            if missing ( __val&t ) then __mct&t[__ix] + 1 ;
            else
            %if &eff %then
            %do ;
               if __cts&t[__ix] >= &critcnt then ;
               else
            %end ;
            do ;
               __rc = rem&t..add() ;
               if __rc = 0 then __cts&t[__ix] + 1 ;
            end ;
         end ;
%mend  __gszloop ;

%macro __gszeof ( t = n /* or c */ ) ;
      %let t = %upcase(&t) ;
      do __ix = 1 to dim ( __x&t ) ;
         var = vname ( __x&t[__ix] ) ;
         ndistinct = __cts&t[__ix] ;
         if ndistinct >= &critcnt then role = "Continuous" ;
         else role = "Category" ;
         misscnt = __mct&t[__ix] ;
         output ;
      end ;
%mend  __gszeof ; 