CREATE VIEW tags AS (
  SELECT id, created_at , user_id , post_id, 'photo_tag' AS type  FROM photo_tags
  UNION ALL
  SELECT id, created_at , user_id , post_id, 'photo_tag' AS type  FROM caption_tags
);

-- So with this view, we've essentially solved this issue of having two separate tables,
-- we've kind of merged them together, but it's not any permanent change whatsoever.
-- We can always remove this view if we want to, and none of the underlying data is going to go anywhere.
-- All the underlying data inside of these two separate tables still exists.
-- also we solve the Problem if we tryied to merge the two tables together, because there will 
-- identical ids (primary keys) on both tables, so these can not be easily solved
-- +---------------------------------------------------------------------------------------------------------+
-- | So now we've got a very convenient way of referring to the union between caption tags and photo tags    |
-- +---------------------------------------------------------------------------------------------------------+

SELECT * FROM tags; -- or by join on it

SELECT username, COUNT(*) 
FROM users 
JOIN tags ON tags.user_id = users.id
GROUP BY username 
ORDER BY COUNT(*) DESC; 





-- Show the users who created the 10 most recent posts
CREATE VIEW recent_posts AS (
  SELECT * 
  FROM posts  
  ORDER BY created_at  DESC
  LIMIT 10
);


-- use the recent_posts view in a reusable manner: 
-- Show the users who were tagged in the 10 most recent posts
SELECT username 
FROM recent_posts 
JOIN users ON  users.id = recent_posts.user_id;


-- updating a VIEW 

CREATE OR REPLACE recent_posts AS (
  SELECT *  FROM posts 
  ORDER BY created_at DESC 
  LIMIT 10
); 


-- deleting 
DROP VIEW recent_posts;



-- For each week, show the number of likes that posts and comments received. Use the 
-- post and comment created_at date, not when the like was received
SELECT 
  date_trunc(
    'week', 
    coalesce( posts.created_at, comments.created_at)
  ) as week, 
  count(posts.id) as num_likes_for_posts, 
  count(comments.id) as num_likes_for_comments 
FROM LIKES 
  LEFT JOIN POSTS ON POSTS.ID = LIKES.POST_ID 
  LEFT JOIN COMMENTS ON COMMENTS.ID = LIKES.COMMENT_ID 
group by week 
order by week;

-- this kind of queries is really slow, so we can solve it with something called MATERIALIZED VIEWS

-- A materialized view is going to run this query at only very specific times.
-- After the query is actually executed, psql is going to hold on to the results 
-- of the query and then we can refer back to those results any time we want: 
CREATE MATERIALIZED VIEW weekly_likes AS (
 SELECT 
  date_trunc(
    'week', 
    coalesce( posts.created_at, comments.created_at)
  ) as week, 
  count(posts.id) as num_likes_for_posts, 
  count(comments.id) as num_likes_for_comments 
FROM LIKES 
  LEFT JOIN POSTS ON POSTS.ID = LIKES.POST_ID 
  LEFT JOIN COMMENTS ON COMMENTS.ID = LIKES.COMMENT_ID 
group by week 
order by week
) WITH DATA; 

-- to referch the result of this query (invalidate its cache): 
REFRESH MATERIALIZED VIEW weekly_likes; 
