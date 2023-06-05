-- simple CTE
WITH tags AS (
  SELECT user_id , created_at FROM caption_tags;
  UNION
  SELECT user_id, created_at FROM photo_tags;
)
SELECT user_name, tags.created_at  FROM users 
JOIN tags ON tags.user_id = users.id 
WHERE tags.created_at > '2010-09-24';



-- recursive CTE

WITH RECURSIVE countdown(val) (
  SELECT 3  as val -- this called the initial, or the non-recursive query 
  UNION
  SELECT val -1  FROM countdown WHERE val > 1 -- Recursive query;
)
SELECT * FROM countdown;
-- this will print:    3 => 2 => 1  



WITH RECURSIVE suggestions (leader_id , follower_id , depth ) AS (
   -- the first is the initial query
    SELECT leader_id , follower_id, 1 as depth -- initial pepole depth as 1;
    FROM  followers 
    WHERE follower_id = 1000
  UNION 
  -- the recursive query
    SELECT followers.leader_id , followers.follower_id, depth + 1
    FROM followers 
    JOIN suggestions ON suggestions.leader_id = followers.follower_id 
    WHERE depth < 3
)

SELECT DISTINCT users.id , users.username  
  FROM suggestions 
JOIN users ON  users.id = suggestions.leader_id  
  WHERE depth > 1
LIMIT 5; 
