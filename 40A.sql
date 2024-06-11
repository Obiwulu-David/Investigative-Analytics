Obiwulu Chinyeaka David
/*A crime
has taken place and the detective needs your help. 
The detective gave you the crime scene report, but you somehow lost it.
You vaguely remember that the crime was a ​murder​ that occurred sometime on 
​Jan.15, 2018​ and that it took place in ​SQL City​. 
Start by retrieving the corresponding crime scene report 
from the police department’s database. */

select * from crime_scene_report
--start by filtering 1- A murder. 2- Date = 2018/01/15. 3- in SQL City
select * from crime_scene_report
where crime_type = 'murder' 
and date = 20180115 and city = 'SQL City';

--After filtering the crime scene report:
/*Security footage shows that there were 2 witnesses. 
The first witness lives at the last house on "Northwestern Dr". 
The second witness, named Annabel, lives somewhere on "Franklin Ave".*/

--find both witness --1 in the last house in 'Northwestern Dr'
--2 anyone with name 'Annabel' and lives somewhere on 'Franklin Ave'

--witnes1
select * from person
where address_street_name = 'Northwestern Dr'
order by address_number desc
limit 1;
--First witness name is Morty Schapiro, id is 14887, Licence id is 118009, ssn is 111564949

--witness2
select * from person
where name like '%Annabel%' and 
address_street_name = 'Franklin Ave';
--Second witness name is Annabel Miller, id is 16371, Licence id is 490173, ssn is 318771143

--Now that we have the witnesses details, lets look for their records in the interview record
select * from interview
where person_id in (16371, 14887);

--witness1: Morty Schapiro with ID - 14887 said:
/* I heard a gunshot and then saw a man run out. He had a "Get Fit Now Gym" bag. 
The membership number on the bag started with "48Z". Only gold members have those bags. 
The man got into a car with a plate that included "H42W". */

--witness2: Annebel Miller with ID - 16371 said:
/*I saw the murder happen, and I recognized the killer from my gym when I was 
working out last week on January the 9th. */

/* 
A MAN 
A GET FIT NOW GYM MEMBER WITH MEMBERSHIP NO STARTING WITH 48Z
HE IS A GOLD MEMBER 
ENTER A CAR THAT HAS H42W AS PART OF THE PLATE NUMBER 
THE KILLER WAS AT THE GYM ON JAN 9TH
*/

select * from get_fit_now_member
where membership_status = 'gold' and id like '48Z%';
/* there are 2 people in this category
1- jeo germuska with id-48Z7A, Personal ID-28819, start date 2016/03/05
2- jeremy bowers with id 48Z55, personal ID-67318, start date 2016/01/01 */

select * from get_fit_now_check_in
where check_in_date = '20180109' and membership_id like '48Z%';
/* there are 2 suspect also
1- membership ID- 48Z7A, in date- 2018/01/09,in time- 1600, out time- 1730
2- membership ID- 48Z55, in date- 2018/01/09, in time- 1530, out time- 1700 */

select * from drivers_license
where gender = 'male' and plate_number like '%H42W%';
/* there are 2 suspects still
1- ID- 423327, age 30, height 70 eyeclour brown, haircolour brown, 
plate_no: 0H42W2, car: Chevrolet, carmodel  Spark LS
2- ID- 664760, age 21, height 71 eyecolour black, haircolour black, 
plate_no: 4H42WR, car: Nissan, carmodel: Altima */

select * from facebook_event_checkin
where person_id in (67318, 28819);
--only person ID 67318 was found and his name is Jeromy Bowers

--lets go back to the interview and hear what statement he gave
select * from interview
where person_id = 67318;
/*I was hired by a woman with a lot of money. I don't know her name but I 
know she's around 5'5" (65") or 5'7" (67"). She has red hair and she 
drives a Tesla Model S. I know that she attended the SQL Symphony Concert 
3 times in December 2017. */

--lets start by pulling out the given description from the drivers_license report
select * from drivers_license
where hair_color = 'red' and car_make = 'Tesla' and height <= 67;
/* there are 3 female with the above description
1- ID-202298, plateno-500123
2- ID-291182, plateno-08CM64
3- ID-918773, plateno-917UU3
lets check out those that attended the SQL Symphony Concert 3 times
*/
select * from facebook_event_checkin
where event_name = 'SQL Symphony Concert';
--there are 212 person so lets filter further

create table new_suspect as	 
(select *
from facebook_event_checkin
where event_name = 'SQL Symphony Concert' 
and date between 20171201 and 20171231);

select person_id, count(person_id)
from new_suspect
group by person_id
order by count desc;
--there are also 2 persons who attended the even 3 times in dec 2017 
--their person_id are 99716 and 24556

select * from person
where id in (99716,24556);
/* from the person table, the person_id-99716 (Miranda Priestly), aligns with statement of Jeromy Bowers
"license_id 202298 as a female, who is rich, she's around 5'5" (65") or 5'7" (67"). 
She has red hair, drives a Tesla Model S., and attended the SQL Symphony Concert 
3 times in December 2017". */

















