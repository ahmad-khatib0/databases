
CREATE TABLE cities (
	cityid UUID PRIMARY KEY NOT NULL default gen_random_uuid(),
	name varchar NOT null
);

INSERT INTO cities (name) values('Melbourne');

SELECT * FROM cities; 

ALTER TABLE people ADD phone STRING AS (personData->> 'phone' ) VIRTUAL;

DROP TABLE people;

CREATE TABLE people (
	  personId UUID PRIMARY KEY NOT NULL default gen_random_uuid(),
	  cityId UUID ,
  	personData JSONB,
  	FirstName STRING AS (personData->>'FirstName') VIRTUAL,
  	LastName STRING AS (personData->>'LastName') VIRTUAL,
  	FOREIGN KEY (cityId) REFERENCES cities(cityid),
  	INDEX  (LastName, Firstname)
);

INSERT INTO people (personData) VALUES(
'{ 
  "Address" : "1913 Hanoi Way",
	"City" : "Sasebo",
	"Country" : "Japan",
	"District" : "Nagasaki",
	"FirstName" : "Mary",
	"LastName" : "Smith",
	"Phone" : "886780309",
	"dob" :  "1982-02-20T13:00:00Z",
  "likes": ["Dinosaurs","Dogs","People"] 
}');
     
SELECT * FROM people; 

EXPLAIN SELECT * FROM people WHERE LastName='Smith' AND FirstName='Mary';


-- Now when we want to get the classes for a particular student, we can “unnest” the
-- array and JOIN the resulting class_id values directly to the classes table:
WITH students_classes AS (
  SELECT student_id , UNNEST(classes) class_id
  FROM students
); 

SELECT class_name FROM classes
JOIN students_classes USING(class_id)
WHERE student_id = '000390a6-4e1d-4bc1-aad7-66b645131d54';

-- ╒═══════════════════════════════════════════════════════════════════════════════════════════════╕
--   Do bear in mind that by embedding foreign keys this way, we lose the capability of            
--   defining FOREIGN KEY constraints and create some opportunities for data inconsisten‐          
--   cies. Furthermore, with this solution, it is difficult to find all students for a given class 
--   because we would have to unpack the array of classes for every student.                       
-- └───────────────────────────────────────────────────────────────────────────────────────────────┘



