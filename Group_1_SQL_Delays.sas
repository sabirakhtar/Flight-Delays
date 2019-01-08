libname delays 'C:\Users\jdeleval\Documents\SQL\Group Assignment';


*******************************************************************************
********************************* READING THE FILES ***************************
*******************************************************************************;


PROC IMPORT out=DELAYS.AIRLINES DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/airlines.csv' DBMS=CSV;
GETNAMES=YES;
RUN;

PROC IMPORT out=DELAYS.AIRPORTS DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/airports.csv' DBMS=CSV;
GETNAMES=YES;
RUN;

PROC IMPORT out=DELAYS.FLIGHTS DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/flights.csv' DBMS=CSV;
GETNAMES=YES;
RUN;

PROC IMPORT out=DELAYS.PLANES DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/planes.csv' DBMS=CSV;
GETNAMES=YES;
RUN;

PROC IMPORT out=DELAYS.WEATHER DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/weather.csv' DBMS=CSV;
GETNAMES=YES;
RUN;
 
PROC IMPORT out=DELAYS.FLIGHTS2 DATAFILE='C:/Users/jdeleval/Documents/SQL/Group Assignment/flights2.csv' DBMS=CSV;
GETNAMES=YES;
RUN;


****************************************************************************************
*************************************** CREATING A NEW DATA SET ************************
****************************************************************************************;


DATA DELAYS.DELAYS1; 
SET DELAYS.FLIGHTS;
IF dep_delay =< 0 THEN dummy_latedeparture = 0;
ELSE dummy_latedeparture=1;
IF arr_delay =< 0 THEN dummy_latearrival = 0;
ELSE dummy_latearrival=1;
IF arr_delay < 0 THEN delay_at_arrival= 0;
ELSE delay_at_arrival = arr_delay;
IF dep_delay < 0 THEN delay_at_departure= 0;
ELSE delay_at_departure = dep_delay;
Time_of_Day = timepart(time_hour);
Speed = round(distance/(air_time/60),0.1);
FORMAT Time_of_Day nltime10.; 
RUN;


***********************************************************************************
**************************************** DELAYS ***********************************
***********************************************************************************;

/*Creating a table to plot the worst time in terms of departure delay and arrival delay*/

PROC SQL;
CREATE TABLE delays.Best_Worst_Route as
SELECT	airo.name as Airport_Origin,
		aird.name as Airport_Destiny,
		cat(fli.origin,'-',fli.dest) as Route,
		avg(fli.delay_at_arrival) as AVG_Delay_Arr format=8.2,
		avg(fli.delay_at_departure) as AVG_Delay_Dep format=8.2,
		count(*) as Number_of_Flights format=COMMA9.
FROM	delays.delays1 as fli, delays.airports as airo, delays.airports as aird
WHERE	fli.origin=airo.faa AND
		fli.dest=aird.faa
GROUP BY 1,2,3
ORDER BY 4 DESC, 5 DESC
;
title 'Best_Worst_Route';

QUIT;


/* Calculating the number of delayed flight for each route*/
PROC SQL; 
SELECT origin,dest, sum(dummy_latedeparture) AS Number_Dep_Delayed_Flight, 
			   sum(dummy_latearrival) AS Number_Arr_Delayed_Flight,
			   count(flight) AS Total_Number_Fligths, 
			   sum(dummy_latedeparture)/count(flight) AS Percent_Dep_Delayed_Flights,
			   sum(dummy_latearrival)/count(flight) AS Percent_Arr_Delayed_Flights
FROM DELAYS.DELAYS1
GROUP BY dest, origin
ORDER BY dest;
QUIT;

/*  Average Delays for each origin airports */
PROC SQL;
TITLE 'Average delays by origin airport';
SELECT origin, round(mean(delay_at_arrival),1) AS Average_Arr_Delay_Time, round(mean(delay_at_departure),1) AS Average_Dep_Delay_Time
FROM DELAYS.DELAYS1
GROUP BY origin;
QUIT;

/* Average Delays for each destination airports*/
PROC SQL;
TITLE 'Average delays by destination airport';
SELECT dest, round(mean(delay_at_arrival),1) AS Average_Arr_Delay_Time, round(mean(delay_at_departure),1) AS Average_Dep_Delay_Time
FROM DELAYS.DELAYS1
GROUP BY dest;
QUIT;


**************************************************************************************
************************************ CARRIERS ****************************************
**************************************************************************************;

/* Average delay per carriers */

PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('9E')
ORDER BY b.arr_delay desc;
RUN;
proc sort data = delays.Airlines out=delays.Airlines1;
by carrier;
Run;
proc sort data = delays.flights out=delays.flights1;
by carrier;
Run;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('AA')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
Select distinct carrier from delays.Airlines1;
run;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('AS ')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('B6')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('DL')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('EV')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('F9')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('FL')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('HA')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('MQ')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('OO')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('UA')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('US')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('VX')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('WN')
ORDER BY b.arr_delay desc;
RUN;
PROC SQL;
SELECT  distinct a.name,b.dest,b.arr_delay,b.carrier
FROM
delays.Airlines1 a, delays.Flights1 b
WHERE a.carrier=b.carrier
and a.carrier IN ('YV')
ORDER BY b.arr_delay desc;
RUN;

***************************************************************************
************************* PLANES MODEL ************************************
***************************************************************************;

/*Creating a table for the average delays per model of planes*/

PROC SQL;
CREATE TABLE delays.delay_plane_model as
SELECT	pla.model,
		avg(fli.delay_at_arrival) as AVG_Delay_arrival format=8.2,
		avg(fli.delay_at_departure) as AVG_Delay_departure format=8.2,
		count(*) as Number_of_Flights format=COMMA9.
FROM	delays.delays1 as fli, delays.planes as pla
WHERE pla.tailnum=fli.tailnum
GROUP BY 1
ORDER BY 2 DESC, 3 DESC
;

title 'Model_Max_Delay';
QUIT;


*************************************************************************
************************************* SPEED *****************************
*************************************************************************;

/*speed planes & average delay at arrival per model*/

PROC SQL;
SELECT P.model, round(mean(D.average_speed),0.1) AS mean_speed, round(mean(D.Average_Delay),0.1) AS Delay_Arrival
FROM (SELECT tailnum, round(mean(speed),0.1) AS average_speed, round(mean(delay_at_arrival),0.1)AS Average_Delay
		FROM DELAYS.DELAYS1
		GROUP BY tailnum) AS D, 
	DELAYS.PLANES P
WHERE D.tailnum = P.tailnum
GROUP BY P.model
ORDER BY 2 DESC;
QUIT;


***********************************************************************************
************************************* WEATHER *************************************
***********************************************************************************;

/*Average departure delay based on Humidity*/

PROC SQL;
CREATE TABLE delays.Dep_Delay_Humidity as
SELECT	avg(fli.dep_delay) AS AVG_Dep_Delay,
		avg(wea.humid) AS AVG_Humidity,
		CASE
			WHEN wea.humid <= 10 THEN '00-10'
			WHEN wea.humid le 20 THEN '10-20'
			WHEN wea.humid le 30 THEN '20-30'
			WHEN wea.humid le 40 THEN '30-40'
			WHEN wea.humid le 50 THEN '40-50'
			WHEN wea.humid le 60 THEN '50-60'
			WHEN wea.humid le 70 THEN '60-70'
			WHEN wea.humid le 80 THEN '70-80'
			WHEN wea.humid le 90 THEN '80-90'
			ELSE '90-100' END AS Humidity_Range
FROM	delays.weather as wea, delays.flights as fli
WHERE	/*input(wea.var1,best.) le 1000 AND/*omit to get all the rows*/
		wea.time_hour=fli.time_hour
GROUP BY 3	
;

title 'Dep_Delay_Humidity';
QUIT;


/*Average departure delay based on Visibility*/
PROC SQL;
CREATE TABLE delays.Dep_Delay_Visibility as
SELECT	avg(fli.dep_delay) AS AVG_Dep_Delay,
		avg(wea.visib) AS AVG_Visibility,
		CASE
			WHEN wea.visib <= 1 THEN '00-01'
			WHEN wea.visib le 2 THEN '01-02'
			WHEN wea.visib le 3 THEN '02-03'
			WHEN wea.visib le 4 THEN '03-04'
			WHEN wea.visib le 5 THEN '04-05'
			WHEN wea.visib le 6 THEN '05-06'
			WHEN wea.visib le 7 THEN '06-07'
			WHEN wea.visib le 8 THEN '07-08'
			WHEN wea.visib le 9 THEN '08-09'
			ELSE '09-10' END AS Visibility_Range
FROM	delays.weather as wea, delays.flights as fli
WHERE	/*input(wea.var1,best.) le 1000 AND/*omit to get all the rows*/
		wea.time_hour=fli.time_hour
GROUP BY 3
;
title 'Dep_Delay_Visibility';
;
QUIT;

/*Average departure delay based on Precipitation*/
/*Scale for precipitation: https://rmets.onlinelibrary.wiley.com/doi/full/10.1002/met.1356*/

PROC SQL;
CREATE TABLE delays.Dep_Delay_Precipitation as
SELECT	avg(fli.dep_delay) AS AVG_Dep_Delay,
		avg(wea.precip) AS AVG_Precipitation,
		CASE
			WHEN wea.precip le 0.1 THEN '0.0-0.1'
			WHEN wea.precip le 0.2 THEN '0.1-0.2'
			WHEN wea.precip le 0.3 THEN '0.2-0.3'
			WHEN wea.precip le 0.4 THEN '0.3-0.4'
			WHEN wea.precip le 0.5 THEN '0.4-0.5'
			WHEN wea.precip le 0.6 THEN '0.5-0.6'
			WHEN wea.precip le 0.7 THEN '0.6-0.7'
			WHEN wea.precip le 0.8 THEN '0.7-0.8'
			WHEN wea.precip le 0.9 THEN '0.8-0.9'
			WHEN wea.precip le 1.0 THEN '0.9-1.0'
			WHEN wea.precip le 1.1 THEN '1.0-1.1'
			WHEN wea.precip le 1.2 THEN '1.1-1.2'
			ELSE '1.2-1.3' END AS Precipitation_Range
FROM	delays.weather as wea, delays.flights as fli
WHERE	/*input(wea.var1,best.) le 1000 AND/*omit to get all the rows*/
		wea.time_hour=fli.time_hour
GROUP BY 3
;
title 'Dep_Delay_Precipitation';
;
QUIT;

/*Average departure delay based on Pressure*/
/*no correlation*/

PROC SQL;
CREATE TABLE delays.Dep_Delay_Pressure as
SELECT	avg(fli.dep_delay) AS AVG_Dep_Delay,
		avg(wea.pressure) AS AVG_Pressure
FROM	delays.weather as wea, delays.flights as fli
WHERE	/*input(wea.var1,best.) le 1000 AND/*omit to get all the rows*/
		wea.time_hour=fli.time_hour
GROUP BY 2
;
title 'Dep_Delay_Pressure';
;
QUIT;

/*Average departure delay based on Dew*/
/*no correlation*/
PROC SQL;
CREATE TABLE delays.Dep_Delay_Dewp as
SELECT	avg(fli.dep_delay) AS AVG_Dep_Delay,
		avg(wea.dewp) AS AVG_Dewp
FROM	delays.weather as wea, delays.flights as fli
WHERE	/*input(wea.var1,best.) le 1000 AND/*omit to get all the rows*/
		wea.time_hour=fli.time_hour
GROUP BY 2
;
title 'Dep_Delay_Dewp';
;
QUIT;