Step 1: Install the MySQL Node Package
npm install mysql 
Step 2: Connect to Database*
var mysql = require('mysql');
var faker = require("faker")

var connection = mysql.createConnection({
  host     : 'localhost',
  user     : 'root',     // your root username
  database : 'join_us'   // the name of your db
});

-- Step 3: Run Queries
-- Running a super simple SQL query like:   SELECT 1 + 1; 
-- Using the MySQL Node Package:
connection.query('SELECT 1 + 1 AS solution', function (error, results, fields) {
   if (error) throw error;
   console.log('The solution is: ', results[0].solution);
});

-- Another sample query, this time selecting 3 things:
var q = 'SELECT CURTIME() as time, CURDATE() as date, NOW() as now';
connection.query(q, function (error, results, fields) {
  if (error) throw error;
  console.log(results[0].time);
  console.log(results[0].date);
  console.log(results[0].now);
});

connection.end();     --AFTER  detreming ,so exit  

CREATE TABLE users (
    email VARCHAR(255) PRIMARY KEY,
    created_at TIMESTAMP DEFAULT NOW()
);

-- To count the number of users in the database:
var q = 'SELECT COUNT(*) AS total FROM users ';
connection.query(q, function (error, results, fields) {
  if (error) throw error;
  console.log(results[0].total);
});

-- Inserting Data Using Node  Approach #1
var q = 'INSERT INTO users (email) VALUES ("rusty_the_dog@gmail.com")';
connection.query(q, function (error, results, fields) {
  if (error) throw error;
  console.log(results);
});

-- An easier approach that allows for dynamic data
var person = {
    email: faker.internet.email(),
    created_at: faker.date.past()
};   
--if you disabled var_result(under) and inserted something using just facker.date  , this date will be 
-- retored as like 0000 00 00  00:00  in the DATABASE  , so the soluthion is that :
--mysql packge is going to make this date (faker.date.past) syntexaly accepted in mysql DATABASE  
var end_result = connection.query('INSERT INTO users SET ?', person, function(err, result) {
  if (err) throw err;
  console.log(result);
})

-- The Code To INSERT 500 Random Users
var data = [];
for(var i = 0; i < 500; i++){
    data.push([
        faker.internet.email(),
        faker.date.past()
    ]);
}
var q = 'INSERT INTO users (email, created_at) VALUES ?'; 

connection.query(q, [data], function(err, result) {
  console.log(err);
  console.log(result);
});
 
connection.end();


-- Solutions To 500 Users Exercises

-- Challenge 1
SELECT 
    DATE_FORMAT(MIN(created_at), "%M %D %Y") as earliest_date 
FROM users;

-- Challenge 2
SELECT * 
FROM   users 
WHERE  created_at = (SELECT Min(created_at) 
                     FROM   users); 
-- Challenge 3
SELECT Monthname(created_at) AS month, 
       Count(*)              AS count 
FROM   users 
GROUP  BY month 
ORDER  BY count DESC; 

-- Challenge 4
SELECT Count(*) AS yahoo_users 
FROM   users 
WHERE  email LIKE '%@yahoo.com'; 

-- Challenge 5
SELECT CASE 
         WHEN email LIKE '%@gmail.com' THEN 'gmail' 
         WHEN email LIKE '%@yahoo.com' THEN 'yahoo' 
         WHEN email LIKE '%@hotmail.com' THEN 'hotmail' 
         ELSE 'other' 
       end      AS provider, 
       Count(*) AS total_users 
FROM   users 
GROUP  BY provider 
ORDER  BY total_users DESC; 