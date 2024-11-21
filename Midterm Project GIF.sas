libname flash "/home/u64036343/";

%macro CO2vLife(years);
data flash.gapminder_MINI;
	set flash.gapminder_data;
	label life_exp = "Life Expectancy";
	label co2_emissions = "CO2 Emissions (tons per capita)";
	label four_regions = "Regions:";
	proc sgplot data = flash.gapminder_MINI;
		title "Relationship between CO2 emissions and Life Expectancy in &years";
		where year = &years;
		scatter x = life_exp y = co2_emissions
		/ group = four_regions markerattrs = (symbol = CircleFilled size = 10);
		yaxis values = (0, 10, 20, 30, 40);
		xaxis values = (30, 40, 50, 60, 70, 80, 90); 
	run;
%mend;

options printerpath = gif animation = start animduration = .5 animloop = yes noanimoverlay nodate nonumber;
ods printer file = "/home/u64036343/Midterm Project GIF";

%CO2vLife(1940);
%CO2vLife(1944);
%CO2vLife(1948);
%CO2vLife(1952);
%CO2vLife(1956);
%CO2vLife(1960);
%CO2vLife(1964);
%CO2vLife(1968);
%CO2vLife(1972);
%CO2vLife(1976);
%CO2vLife(1980);
%CO2vLife(1984);
%CO2vLife(1988);
%CO2vLife(1992);
%CO2vLife(1996);
%CO2vLife(2000);
%CO2vLife(2004);
%CO2vLife(2008);
%CO2vLife(2012);
%CO2vLife(2016);

options printerpath = gif animation = stop;
ods printer close;
