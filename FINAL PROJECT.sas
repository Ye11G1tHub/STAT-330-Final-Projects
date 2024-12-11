/*********************************** Part 1 ***************************************/
%macro import_gapminder(mydataset1, path, mylibname);
	libname &mylibname "&path";
 	%let new_name = %scan(&mydataset1, 1, ".");   /*gets rid of .csv on file name */
	proc import
		datafile = "&path.&mydataset1"
		out = &new_name
		dbms = csv
		replace;
	run;
%mend;

%import_gapminder(child_mortality.csv, /home/u64036343/, flash);

proc print data = child_mortality (obs = 10);
run;

/*********************************** Part 2 ***************************************/
%macro reshape_gapminder(mydataset1, mylibname);
	libname &mylibname "/home/u64036343/";
	proc sort data = &mydataset1;
		by country;
	run;

	proc transpose 
		data = &mydataset1 
		out = child_mortality_long(rename = (_name_ = year col1 = ChildMortality));
		by country;
		var "1799"n--"2099"n;
	run;
	
	data gapminder_mini;
		set &mylibname..gapminder_data;
	run;

	data child_mortality_long_fixed; /* removes character variable year */
		set child_mortality_long;
		drop year;
	run;
	
	proc sort data = gapminder_mini;
		by country;
	run;
	
	data mygapminder;
		merge gapminder_mini child_mortality_long_fixed;
	run;
%mend;

%reshape_gapminder(child_mortality, flash);

proc print data = child_mortality_long_fixed (obs = 400);
run;

proc print data = mygapminder (obs = 100);
run;

/*********************************** Part 3 ***************************************/
%macro visualize_gapminder(mylibname, mystartyear, myendyear);
	%do i = &mystartyear %to &myendyear; /* loops through every year in the range and prints out a graph for each year */
		proc sgplot data = mygapminder;
			title "Relationship between Child Mortality and Life Expectancy in &i";
			label ChildMortality = "Child Mortality (thousands)";
			where year = &i;
			bubble x = life_exp y = ChildMortality size = population
			/ group = four_regions ;
		run;
	%end;
%mend;

options printerpath = gif animation = start animduration = .5 animloop = yes noanimoverlay nodate nonumber;
ods printer file = "/home/u64036343/Final Project GIF";
%visualize_gapminder(flash, 1990, 1990);
%visualize_gapminder(flash, 1970, 2000);
options printerpath = gif animation = stop;
ods printer close;