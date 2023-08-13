/*
Objectives
Come up with flu shots dashboard for 2022 that does the following

1.) Total % of patients getting flu shots stratified by
   a.) Age
   b.) Race
   c.) County (On a Map)
   d.) Overall
2.) Running Total of Flu Shots over the course of 2022
3.) Total number of Flu shots given in 2022
4.) A list of Patients that show whether or not they received the flu shots
   
Requirements:

Patients must have been "Active at our hospital"
*/

with active_patients as
(
select distinct patient
from encounters as es
join patients as pts
	on es.patient = pts.id
where start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
	and pts.deathdate is null
	and extract(month from age('2022-12-31', pts.birthdate)) >= 6
)

select extract(year from age('2022-12-31', pts.birthdate)) as Age,
	   pts.race,
	   pts.ethnicity,
	   pts.county,
	   pts.id,
	   pts.first,
	   pts.last,
	   pts.gender,
	   case when pts.zip = 0 then NULL else pts.zip end as zip,
	   subq.earliest_flu_shot_2022,
	   CASE WHEN subq.patient IS NULL THEN 0 ELSE 1 END AS flu_shot_2022
from patients as pts
left JOIN (
    SELECT patient, 
		   MIN(date) AS earliest_flu_shot_2022
    FROM immunizations
    WHERE date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
    AND code = '5302'
    GROUP BY patient
) as subq 
	on pts.id = subq.patient
where 1=1 --placeholder--
	and pts.id in (select patient from active_patients)
	



