* Calculate SPDS Partition Size v 1.3__________________
* Source
*       Type: String
*      Group: General
*      Label: Source table being loaded into SPD Server
*       Attr:  Modifiable, Required
*_______________________________________________________
* PARTS
*       Type: Numeric
*      Group: General
*      Label: SPD Server R&D recommends 2 parts per
*             file system allocated for the data component
*             of an SPD Server table
*       Attr:  Modifiable, Required
*______________________________________________________
* FILESYSTEMS
*       Type: String
*      Group: General
*      Label: the number of files system dedicated to the 
*             data component of the SPDS table, refer to 
*             LIBNAMES.PARM
*       Attr:  Modifiable, Required
*______________________________________________________
* FILE
*       Type: String
*      Group: General
*      Label: a temp file that is used to store the SPDS 
*             statement to set the correct partition size
*       Attr:  Modifiable, Required
*______________________________________________________
* NOBS
*       Type: Numeric
*      Group: General
*      Label: the number of rows in the source table being 
*             loaded into the SPDS table
*       Attr: Data driven
*_________________________________________________________
* LRS
*       Type: Numeric
*      Group: General
*      Label: the logical record length of the source table 
*             being loaded into the SPDS table.
*       Attr: Data driven
*_________________________________________________________;
%global lrs nobs partsize spdssize;
%macro partsize(SOURCE=sashelp.voption,PARTS=2,FILESYSTEMS=10,FILE="/tmp/&sysuserid..partsize.sas");
	proc contents 
		data=&Source 
		out=contents (keep=length nobs)
		noprint; 
	run;  

	data _null_;
		set contents end=done;
		lrs + length;
		if done then do;
		   call symput ('lrs',trim(left(put(lrs,8.))));
		   call symput ('nobs',trim(left(put(nobs,8.))));
		end;
	run;

	%if &nobs eq . %then %do;
		proc sql;
			create table nobs as select count(*)as nobs from &SOURCE;
		quit;
		data _null_;
	   		set nobs;
	   		call symput ('nobs',trim(left(put(nobs,8.))));
		run;
	%end;


	data partsize;
   		file &FILE;
   		format observations logical_record_length rows_per_filesystem file_systems 
               rows_per_partition parts bytes kbytes mbytes gbytes tbytes comma24.0;
   		observations=&NOBS;
   		file_systems=&FILESYSTEMS;
   		logical_record_length=&LRS;
   		parts=&PARTS;
   		rows_per_filesystem=ceil(observations/file_systems);
		rows_per_partition=rows_per_filesystem/&PARTS;
   		partsize=CEIL((rows_per_filesystem * logical_record_length) / (1024*1024));
		partsize=CEIL(partsize/&parts);
		if partsize <=16 then partsize=16;
   		bytes=&nobs*&lrs;
   		kbytes=bytes/1024;
   		mbytes=bytes/1024**2;
   		gbytes=bytes/1024**3;
   		tbytes=bytes/1024**4;
   		cpartsize=partsize || 'M';
   		call symput ('partsize',trim(left(put(cpartsize,$30.))));
   		put '%let spdssize=' cpartsize ';';
	run;
	options source2;
	%inc &FILE;
	options nosource2;
	%put For the table &Source there are &NOBS rows with a logical record length of &LRS bytes.;
	%put Creating &parts partitions per data path, the partition size for &Source is &PARTSIZE;
	title "SPD Server Parition Size for &Source is &PARTSIZE";
	proc print uniform Label;	
   		Label parts='Desired Number of Data Components per File System per Table'
	    	rows_per_filesystem='Number of Rows per File System'
	    	rows_per_partition='Number of Rows per Partition'
			Observations='Number of Rows in Table'
			file_systems='Number of File Systems for SPDS Data Component'
			partsize='Partition size of SPD Server Table'
			logical_record_length='Logical Record length'
			bytes='Bytes'
			kbytes='Kilobytes'
			mbytes='Megabytes'
			gbytes='Gigabytes'
			tbytes='Terabytes';
   		var partsize observations logical_record_length file_systems parts rows_per_filesystem  
            rows_per_partition bytes kbytes mbytes 
            gbytes tbytes;
	run;

	title;

%mend;
*%partsize(SOURCE=speedy.qrt1,PARTS=16,FILESYSTEMS=1,FILE="c:\temp\&sysuserid..partsize.sas");

