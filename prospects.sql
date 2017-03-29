/* Import all of extract_class and extract_class_ref as 'text' format */

/* Uses:
 * extract_objects
 * extract_class_ref
 * extract_class
 * extract_charity
 * cat_details
 * extract_main_charity
 * extract_proper_object
 * england_postcodes
 * class_name_regno
 *  */

/* Set 1 */
ALTER TABLE charity.england_postcodes RENAME COLUMN "Latitude" TO latitude;
ALTER TABLE charity.england_postcodes RENAME COLUMN "Longitude" TO longitude;
ALTER TABLE charity.england_postcodes RENAME COLUMN "District" TO district;
ALTER TABLE charity.england_postcodes RENAME COLUMN "Region" TO region;
ALTER TABLE charity.england_postcodes RENAME COLUMN "Postcode" TO postcode;



/* Set 2 */
/* If downloading data direct from the charity commission, run this command to create the extract_proper_object table */
create table charity.extract_proper_object as
SELECT regno, seqno, subno, string_agg(object, ', ')
FROM charity.extract_objects
GROUP BY regno,subno, seqno
ORDER by seqno ASC;



/* Set 3 */
create table charity.class_name_regno as
SELECT *
FROM charity.extract_class_ref
INNER JOIN charity.extract_class
ON extract_class.class = extract_class_ref.classno;



/* Set 4 */
create table charity.cat_details AS
SELECT *
FROM crosstab(
  'select regno, classtext, class
   from charity.class_name_regno
   where classno = ''203'' or classno = ''104'' or classno= ''110'' or classno= ''116''
   order by 1,2')
AS ct(regno text, category_1 text, category_2 text, category_3 text, category_4 text);



/* Set 5 */
create table charity.gya_prospects as
SELECT charity.extract_charity.regno,
	charity.extract_charity.subno,
	charity.extract_charity.name,
	charity.extract_charity.gd,
	charity.extract_charity.aob,
	charity.extract_charity.aob_defined,
	charity.extract_charity.ha_no,
	charity.extract_charity.add1,
	charity.extract_charity.add2,
	charity.extract_charity.add3,
	charity.extract_charity.add4,
	charity.extract_charity.add5,
	charity.extract_charity.postcode,
	charity.extract_charity.phone,
	charity.extract_main_charity.web,
	charity.extract_main_charity.incomedate,
	charity.extract_proper_object.string_agg,
	charity.cat_details.category_1,
	charity.cat_details.category_2,
	charity.cat_details.category_3,
	charity.cat_details.category_4,
	charity.england_postcodes.latitude,
	charity.england_postcodes.longitude,
	charity.england_postcodes.district,
	charity.england_postcodes.region
FROM charity.extract_charity
INNER JOIN charity.extract_main_charity ON extract_charity.regno = extract_main_charity.regno
INNER JOIN charity.cat_details ON extract_charity.regno = cat_details.regno
INNER JOIN charity.extract_proper_object ON extract_charity.regno = extract_proper_object.regno
left join charity.england_postcodes on extract_charity.postcode = england_postcodes.postcode
and extract_charity.subno = extract_proper_object.subno and charity.extract_main_charity.incomedate >= '2015-07-01 00:00:00';
