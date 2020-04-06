/* Patrick Cuba's date dimension macro */
/* From https://raw.githubusercontent.com/PatrickCuba/SASDateDimension/master/dates.sas */
/* Since holidaytest() is valid for Canada, exclude Australian holidays and hash function */

%Macro CreateDateDim(StartDate=, EndDate=);
     Data D_Date(Index=(Date_sk));
           Attrib Date_sk            Length=8.                     Label='PK: Date_sk'
                  Date               Length=8. Format=yymmdd10.    Label='Date'
                  Datetime           Length=8. Format=Datetime22.  Label='Date time'
                  Date_Start_sk      Length=8.
                  Date_End_sk        Length=8.
                  Excel_Date_sk      Length=8.
                  Month_End_Flag     Length=3.
                  Week_End_Flag      Length=3.
                  Num_Day            Length=3.
                  Num_Month          Length=3.
                  Num_Year           Length=3.
                  Num_Quarter        Length=3.
                  NA_Public_Holiday  Length=3.
                  Fin_Qtr            Length=3.
              %Do i=1 %To 12;
                   PrevDate_&i.m_sk      Length=8. Format=yymmdd10.
                   PrevDate_&i.mStart_sk Length=8. Format=yymmdd10.
                   PrevDate_&i.mEnd_sk   Length=8. Format=yymmdd10.
              %End;
              %Do i=1 %to 12;
                   NextDate_&i.m_sk      Length=8. Format=yymmdd10.
                   NextDate_&i.mStart_sk Length=8. Format=yymmdd10.
                   NextDate_&i.mEnd_sk   Length=8. Format=yymmdd10.
            %End;
                ;
                
        
         Do Date_sk = "&StartDate."d to "&EndDate"d;
              Date_Start_sk=Intnx('Month', Date_sk, 0, 'begin');
              Date_End_sk=Intnx('Month', Date_sk, 0, 'end');
              Date=Date_sk; 
              Datetime=Date_sk*24*60*60;
              Excel_Date_sk=Date_sk+21916;

              If Date_sk=Date_End_sk Then Month_End_Flag=1;
              Else Month_End_Flag=0;

              /* Create Numerics */
            Num_Day=Day(Date_sk);
            Num_Month=Month(Date_sk);
            Num_Year=Year(Date_sk);
            Num_Quarter=QTR(Date_sk);

              /* Create Texts - long/short*/
            Txt_DOW=Put(Date_sk, DOWName. -L);
            Julian_Date=Put(Date_sk, JulDay. -L);
            Txt_Month_Name=Put(Date_sk, MonName. -L);
            Txt_Week_Date=Put(Date_sk, WeekDate. -L);
            If Strip(Txt_DOW) in ('Saturday' 'Sunday') Then Week_End_Flag=1;
            Else Week_End_Flag=0;

              /* SQL Server Date & Datetime */
              Txt_Date=Put(Date_sk, yymmddd10.);
              Txt_DateTime=Compbl(Put(Date_sk, yymmddd10.)|| ' 00:00:00');

              /* Current Date */
              /* Report Date */
              
              /* Holidays */
             If holidaycount(Date_sk,'en_CA ') gt 1 then NA_Public_Holiday = 1 ;

              /* Adjust financial quarter for each site */
             Select(Num_Quarter);
             	When (1) Fin_Qtr=3;
             	When (2) Fin_Qtr=4;
             	When (3) Fin_Qtr=1;
             	When (4) Fin_Qtr=2;
             	Otherwise;
             End;

              /* Last Month Dates and Keys - start, end, sameday */
              %Do i=1 %To 12;
                   PrevDate_&i.m_sk=Intnx('Month', Date_sk, -&i., 'same');
                   PrevDate_&i.mStart_sk=Intnx('Month', Date_sk, -&i., 'begin');
                   PrevDate_&i.mEnd_sk=Intnx('Month', Date_sk, -&i., 'end');

                   NextDate_&i.m_sk=Intnx('Month', Date_sk, &i., 'same');
                   NextDate_&i.mStart_sk=Intnx('Month', Date_sk, &i., 'begin');
                   NextDate_&i.mEnd_sk=Intnx('Month', Date_sk, &i., 'end');
              %End;
              /* Month End, Weekend, Quarter End Flags */
            Output;
         End;
     Run;
%Mend;
%CreateDateDim(StartDate=01JAN2017, EndDate=31JAN2017);


Proc SQL Noprint Outobs=1;
	Select Date Into :Report_Date 
	from D_Date 
	where NA_Public_Holiday=0
      and Week_End_Flag=0
	  and Date < Today()
	Order by Date Desc;
Quit;

%Put Report_Date=&Report_Date.;
