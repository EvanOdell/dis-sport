
/* Import all of extract_class as 'text' format */

/* Need to combine 'extract_object' into 1 file*/

create table charity.extract_proper_object as
SELECT regno, seqno, string_agg(object, ', ')
FROM charity.extract_objects
GROUP BY regno, seqno
ORDER by seqno ASC;

create table charity.class_name_regno as
SELECT *
FROM charity.extract_class_ref
INNER JOIN charity.extract_class
ON extract_class.class = extract_class_ref.classno;

create table charity.cat_details AS
SELECT *
FROM crosstab(
  'select regno, classtext, class
   from charity.class_name_regno
   where classno = ''203'' or classno = ''104'' or classno= ''110'' or classno= ''116''
   order by 1,2')
AS ct(regno text, category_1 text, category_2 text, category_3 text, category_4 text);


create table charity.gya_prospects as
SELECT charity.extract_charity.regno,
	charity.extract_charity.subno,
	charity.extract_charity.name,
	charity.extract_charity.gd,
	charity.extract_charity.aob,
	charity.extract_charity.aob_defined,
	charity.extract_charity.nhs,
	charity.extract_charity.ha_no,
	charity.extract_charity.corr,
	charity.extract_charity.add1,
	charity.extract_charity.add2,
	charity.extract_charity.add3,
	charity.extract_charity.add4,
	charity.extract_charity.add5,
	charity.extract_charity.postcode,
	charity.extract_charity.phone,
	charity.extract_charity.fax,
	charity.extract_main_charity.web,
	charity.extract_main_charity.income,
	charity.extract_main_charity.incomedate,
	charity.extract_objects.object,
	charity.cat_details.category_1,
	charity.cat_details.category_2,
	charity.cat_details.category_3,
	charity.cat_details.category_4
FROM charity.extract_charity
INNER JOIN charity.extract_main_charity ON extract_charity.regno = extract_main_charity.regno
INNER JOIN charity.cat_details ON extract_charity.regno = cat_details.regno
INNER JOIN charity.extract_objects ON extract_charity.regno = extract_objects.regno 
and extract_charity.subno = extract_objects.subno and charity.extract_main_charity.incomedate >= '2015-06-01 00:00:00';


create table charity.gya_prospects2 as
SELECT * FROM charity.gya_prospects LEFT JOIN charity.england_postcodes USING (postcode);
