---Data preparation
SELECT *
  FROM [traffic_crashes].[dbo].[traffic_crashes]

---Data Processing
---Checking for duplicate values
  SELECT DISTINCT(CRASH_RECORD_ID)
  FROM [traffic_crashes].[dbo].[traffic_crashes]
 --- There are null values in some columns, but they wont be removed.

 ---Checking for distinct values in the columns
 DELETE
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE CRASH_RECORD_ID IS NULL

 SELECT DISTINCT(TRAFFIC_CONTROL_DEVICE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE TRAFFIC_CONTROL_DEVICE IS NOT NULL

 SELECT DISTINCT(DEVICE_CONDITION)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE DEVICE_CONDITION IS NOT NULL

 SELECT DISTINCT(WEATHER_CONDITION)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE WEATHER_CONDITION IS NOT NULL

 SELECT DISTINCT(LIGHTING_CONDITION)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE LIGHTING_CONDITION IS NOT NULL

 SELECT DISTINCT(FIRST_CRASH_TYPE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE FIRST_CRASH_TYPE IS NOT NULL

 SELECT DISTINCT(TRAFFICWAY_TYPE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE TRAFFICWAY_TYPE IS NOT NULL

 SELECT DISTINCT(ALIGNMENT)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE ALIGNMENT IS NOT NULL

SELECT DISTINCT(ROADWAY_SURFACE_COND)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE ROADWAY_SURFACE_COND IS NOT NULL

 SELECT DISTINCT ROAD_DEFECT
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE CRASH_DATE_EST_I IS NOT NULL 

 SELECT DISTINCT(REPORT_TYPE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE REPORT_TYPE IS NOT NULL

 SELECT DISTINCT(PRIM_CONTRIBUTORY_CAUSE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE PRIM_CONTRIBUTORY_CAUSE IS NOT NULL

 SELECT DISTINCT(SEC_CONTRIBUTORY_CAUSE)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE SEC_CONTRIBUTORY_CAUSE IS NOT NULL

 SELECT DISTINCT(STREET_DIRECTION)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE STREET_DIRECTION IS NOT NULL

 SELECT DISTINCT(MOST_SEVERE_INJURY)
 FROM [traffic_crashes].[dbo].[traffic_crashes]
 WHERE MOST_SEVERE_INJURY IS NOT NULL

 ---Replacring the abbreviated text in the Street Direction column
 UPDATE [traffic_crashes].[dbo].[traffic_crashes]
SET STREET_DIRECTION = 'South'
WHERE STREET_DIRECTION = 'S'

UPDATE [traffic_crashes].[dbo].[traffic_crashes]
SET STREET_DIRECTION = 'SOUTH'
WHERE STREET_DIRECTION = 'South'

UPDATE [traffic_crashes].[dbo].[traffic_crashes]
SET STREET_DIRECTION = 'WEST'
WHERE STREET_DIRECTION = 'W'

UPDATE [traffic_crashes].[dbo].[traffic_crashes]
SET STREET_DIRECTION = 'NORTH'
WHERE STREET_DIRECTION = 'N'

UPDATE [traffic_crashes].[dbo].[traffic_crashes]
SET STREET_DIRECTION = 'EAST'
WHERE STREET_DIRECTION = 'E'

---- Creating a column for months when the police were notified of the crash
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD NOTIFIED_MONTH nvarchar(50)

--- Inserting the months into the column
UPDATE  [traffic_crashes].[dbo].[traffic_crashes]
SET NOTIFIED_MONTH =  DATENAME(MONTH, DATE_POLICE_NOTIFIED) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE NOTIFIED_MONTH IS NULL

---- Creating a column for weekday when the police were notified of the crash
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD NOTIFIED_DAY nvarchar(50)

--- Inserting the days into the column
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET NOTIFIED_DAY =  DATENAME(WEEKDAY,DATE_POLICE_NOTIFIED) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE NOTIFIED_DAY IS NULL

---- Creating a column for the year when the the police were notified of the crash
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD NOTIFIED_YEAR int

--- Inserting the year into the column
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET NOTIFIED_YEAR = DATEPART(YEAR, DATE_POLICE_NOTIFIED) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE NOTIFIED_YEAR IS NULL

---- Creating a column for the Notified time
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD  NOTIFIED_TIME time

--- Inserting the time
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET NOTIFIED_TIME =  CAST(DATE_POLICE_NOTIFIED as time) 
FROM [traffic_crashes].[dbo].[traffic_crashes]
WHERE NOTIFIED_TIME IS NOT NULL

---Updating the Crash month column
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET CRASH_MONTH = DATENAME(MONTH, CRASH_DATE) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE CRASH_MONTH IS NOT NULL

---Updating the Crash day column
ALTER TABLE  [traffic_crashes].[dbo].[traffic_crashes] 
DROP COLUMN CRASH_DAY_OF_WEEK

ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD CRASH_DAY nvarchar(50)

UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET CRASH_DAY = DATENAME(WEEKDAY, CRASH_DATE) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE CRASH_DAY IS NULL

---Extracting the Crash time from the datetime  column
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
DROP COLUMN CRASH_HOUR
 
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD CRASH_TIME time

--- Inserting the time into the column
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET CRASH_TIME = CAST(CRASH_DATE as time)
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 WHERE CRASH_TIME IS NULL
 
----Creating a column for Year of Crash
ALTER TABLE [traffic_crashes].[dbo].[traffic_crashes] 
ADD CRASH_YEAR int

----Inserting the Year
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET CRASH_YEAR = DATEPART(YEAR, CRASH_DATE) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE CRASH_YEAR IS NULL

--- Checking for time values that might be negative
SELECT CRASH_TIME,NOTIFIED_TIME
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE CRASH_TIME > NOTIFIED_TIME
----Deleting
DELETE 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE CRASH_TIME > NOTIFIED_TIME

---Creating a column that calculates the time it took for the police to be notified of the crash
ALTER TABLE  [traffic_crashes].[dbo].[traffic_crashes] 
ADD DURATION int 

--- Inserting the duration into the column
UPDATE [traffic_crashes].[dbo].[traffic_crashes] 
SET DURATION = DATEDIFF(MINUTE,CRASH_TIME,NOTIFIED_TIME)
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE DURATION IS NULL
 sp_rename '[traffic_crashes].[dbo].[traffic_crashes].DURATION', 'DURATION(mins)'
 

 sp_rename '[traffic_crashes].[dbo].[traffic_crashes].HIT_AND_RUN_I','HIT_AND_RUN'

--- Check for the  distinct crash year
SELECT DISTINCT(CRASH_YEAR)
FROM [traffic_crashes].[dbo].[traffic_crashes] 
ORDER BY CRASH_YEAR ASC

----ANALYSIS
---How many crash occured in each year?
SELECT CRASH_YEAR, COUNT(CRASH_RECORD_ID) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY CRASH_YEAR
 ORDER BY CRASH_YEAR DESC
 
 --- How many of the crashes were a hit and run
 
 SELECT COUNT(HIT_AND_RUN_I) 
 FROM[traffic_crashes].[dbo].[traffic_crashes]
 WHERE HIT_AND_RUN_I = 'Y'
  
---- How were the report of the crashes made?
SELECT REPORT_TYPE, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY REPORT_TYPE
ORDER BY count DESC

--- How many crashes led to injury?
SELECT CRASH_TYPE, COUNT(CRASH_RECORD_ID) AS count 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY CRASH_TYPE
ORDER BY count DESC

--- Which street had the most crashes
SELECT TOP (10) STREET_NAME, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY STREET_NAME
ORDER BY count DESC

--- In how many crashes were there 1 or more injured?
SELECT COUNT(INJURIES_TOTAL)
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 WHERE INJURIES_TOTAL >= 1
 ---with 81,288 cases of 1 or more people injured, then for the rest of the cases, they werem't injured.

--- How many of the injured were fatal injuries
SELECT  COUNT(INJURIES_FATAL)
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE INJURIES_FATAL >= 1

--- How many were incapacitating?
SELECT COUNT (INJURIES_INCAPACITATING)
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE INJURIES_INCAPACITATING >= 1
--- How many were non-incapacitating
SELECT COUNT(INJURIES_NON_INCAPACITATING)
FROM [traffic_crashes].[dbo].[traffic_crashes] 
WHERE INJURIES_NON_INCAPACITATING >= 1

--- In what weekday do most crash occur?
SELECT CRASH_DAY, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY CRASH_DAY
ORDER BY count DESC
---Looks like most crash occur on the weekends.
--- Which month has the highest crash recorded
SELECT CRASH_MONTH, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY CRASH_MONTH
ORDER BY count DESC
--- what time of the day do most crash occur
SELECT TOP (10) CRASH_TIME, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY CRASH_TIME
ORDER BY count DESC
--- Most crash happen in the noon between 12pm-4pm
---
 ---How long(average) does it take for to police to be notified about a crash?
 SELECT CONCAT(AVG(DURATION),' ', 'minutes')
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 
 ---What is the longest time it took the police to be notified about a crash and what else can we learn abut the crash?
 SELECT CONCAT(MAX(DURATION),' ', 'minutes')
 FROM [traffic_crashes].[dbo].[traffic_crashes] 

 SELECT * 
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 WHERE DURATION =
 (SELECT  MAX(DURATION)
 FROM [traffic_crashes].[dbo].[traffic_crashes] )

 ---- Under what weather condition do most crashes occur?
 SELECT WEATHER_CONDITION, COUNT(CRASH_RECORD_ID) AS count
  FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY WEATHER_CONDITION
  ORDER BY count DESC
  --- Most crashes occur under a clear  weather condition and a fair amount under a rainy weather
  ---- Under what lighting condition do most crashes occur?
 SELECT LIGHTING_CONDITION, COUNT(CRASH_RECORD_ID) AS count
  FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY LIGHTING_CONDITION
  ORDER BY count DESC
 --- Most crashes occur in Daylight, and the ones that did occur in the dark/night time were lighted roads.
 ----It safe to assume that, harsh weather conditions and dark lighting doesnt neccessarily contribute to most of the crashes.
 --- How many crashes were caused by road defects?
 SELECT ROAD_DEFECT,COUNT(CRASH_RECORD_ID) AS count
  FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY ROAD_DEFECT
  ORDER BY count DESC
---There were no road defects in majority of the crashes

---What were the types of first collision crash
SELECT FIRST_CRASH_TYPE, COUNT(CRASH_RECORD_ID) AS count
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 GROUP BY FIRST_CRASH_TYPE
 ORDER BY count DESC

---- In what traffic way did most crash occur?
SELECT TRAFFICWAY_TYPE, COUNT(CRASH_RECORD_ID) AS count
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 GROUP BY TRAFFICWAY_TYPE
 ORDER BY count DESC
 ---Most crash occur on the non-divided traffic way

 --- What was the street alignment the location of most crash
 SELECT ALIGNMENT, COUNT(CRASH_RECORD_ID) AS count
  FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY ALIGNMENT
  ORDER BY count DESC
--- In how many of the crash occured as a result of an intersection 
SELECT COUNT(INTERSECTION_RELATED_I) AS count
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 WHERE INTERSECTION_RELATED_I = 'Y'

 --- Damage caused by the crash
 SELECT DAMAGE, COUNT(CRASH_RECORD_ID) AS count
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY DAMAGE
  ORDER BY count DESC
  ---Most crash cost a damage of over $1500
--- What was the primary cause of most crash
SELECT PRIM_CONTRIBUTORY_CAUSE, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY PRIM_CONTRIBUTORY_CAUSE
  ORDER BY count DESC
--- What was the secondary cause of most crash
SELECT	SEC_CONTRIBUTORY_CAUSE, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY SEC_CONTRIBUTORY_CAUSE
  ORDER BY count DESC

  --- How many unit who were involved a crash got their statements taken
SELECT STATEMENTS_TAKEN_I, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY STATEMENTS_TAKEN_I
  HAVING STATEMENTS_TAKEN_I = 'Y'
  ORDER BY count DESC

----How many crash occured in an active work zone
--- What was the primary cause of most crash
SELECT WORK_ZONE_I, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY WORK_ZONE_I
  HAVING WORK_ZONE_I = 'Y'
  ORDER BY count DESC

---What crash incident had the highest number of units involved and what can we know about it.
SELECT *
FROM  [traffic_crashes].[dbo].[traffic_crashes] 
WHERE NUM_UNITS =
(SELECT MAX(NUM_UNITS)
FROM [traffic_crashes].[dbo].[traffic_crashes])

---Does the presence of a traffic control device reduce the amount of crash
SELECT TRAFFIC_CONTROL_DEVICE, COUNT(CRASH_RECORD_ID) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
  GROUP BY TRAFFIC_CONTROL_DEVICE
  ORDER BY count DESC
--- Yes it does. Most crash scene had no trafiic control device. And a fair amount had a traffic control device
--- For the crash scene/location that had a traffic control device present, how many of the device were functioning?
SELECT TRAFFIC_CONTROL_DEVICE,DEVICE_CONDITION, COUNT(*)
 OVER(PARTITION BY  DEVICE_CONDITION  ) AS count
 FROM [traffic_crashes].[dbo].[traffic_crashes] 
 GROUP BY TRAFFIC_CONTROL_DEVICE, DEVICE_CONDITION
HAVING TRAFFIC_CONTROL_DEVICE != 'NO CONTROLS'
AND DEVICE_CONDITION != 'NO CONTROLS'

SELECT TRAFFIC_CONTROL_DEVICE, DEVICE_CONDITION, COUNT(DEVICE_CONDITION) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes] 
 GROUP BY TRAFFIC_CONTROL_DEVICE, DEVICE_CONDITION
HAVING TRAFFIC_CONTROL_DEVICE != 'NO CONTROLS'
AND DEVICE_CONDITION != 'NO CONTROLS'
ORDER BY DEVICE_CONDITION

--- Average speed limit in different weather conditions
SELECT WEATHER_CONDITION,AVG(CAST(POSTED_SPEED_LIMIT AS int)) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY WEATHER_CONDITION

SELECT LIGHTING_CONDITION,AVG(CAST(POSTED_SPEED_LIMIT AS int)) 
FROM [traffic_crashes].[dbo].[traffic_crashes] 
GROUP BY LIGHTING_CONDITION

SELECT *
FROM [traffic_crashes].[dbo].[traffic_crashes]
WHERE POSTED_SPEED_LIMIT =
(SELECT MAX(CAST(POSTED_SPEED_LIMIT AS int)) 
FROM [traffic_crashes].[dbo].[traffic_crashes] )

--- How severe are the crashes that occur on the weekends comapred to those that happen on weekdays
SELECT CRASH_DAY, MOST_SEVERE_INJURY,CRASH_TYPE, COUNT(CRASH_RECORD_ID) OVER(PARTITION BY CRASH_TYPE, MOST_SEVERE_INJURY,CRASH_DAY) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes]
WHERE CRASH_DAY IN ('Friday','Saturday','Sunday')
AND  MOST_SEVERE_INJURY IS NOT NULL

SELECT CRASH_DAY, MOST_SEVERE_INJURY,CRASH_TYPE, COUNT(CRASH_RECORD_ID)  AS count
FROM [traffic_crashes].[dbo].[traffic_crashes]
GROUP BY CRASH_DAY,MOST_SEVERE_INJURY, CRASH_TYPE
HAVING CRASH_DAY IN ('Friday','Saturday','Sunday')
AND  MOST_SEVERE_INJURY IS NOT NULL
ORDER BY CRASH_DAY, count DESC

SELECT CRASH_DAY, MOST_SEVERE_INJURY,CRASH_TYPE, COUNT(CRASH_RECORD_ID)  AS count
FROM [traffic_crashes].[dbo].[traffic_crashes]
GROUP BY CRASH_DAY,MOST_SEVERE_INJURY, CRASH_TYPE
HAVING CRASH_DAY IN ('Monday','Tuesday','Wednesday', 'Thursday')
AND  MOST_SEVERE_INJURY IS NOT NULL
ORDER BY CRASH_DAY, count DESC

 SELECT COUNT(MOST_SEVERE_INJURY) AS count
FROM [traffic_crashes].[dbo].[traffic_crashes]
WHERE MOST_SEVERE_INJURY = 'FATAL'
--- its safe to say, most crashes were not fatal/ less severe both on the weekends and on the weekdays