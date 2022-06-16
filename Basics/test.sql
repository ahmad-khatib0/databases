SELECT
  substring('hello worlk', 5, 8);

  GRANT ALL PRIVILEGES ON datahase_name.* TO "username"@'localhost' IDENTFIED BY 'PASSWORD' ; 

  SHOW GRANTS FOR 'username'@'localhost' ; 



  insert into pages(id , item_name_id , page_name , content , rank ,visible,status)
  values  (1  ,   3   ,  "JAVA"  ,   "THIS IS JAVA PAGE" , 1  , 1  , 1    ) , 
          (2  ,   3   ,  "PY"  ,   "THIS IS py PAGE" , 2  , 1  , 1    ) , 
          (3  ,   3   ,  "C"  ,   "THIS IS c PAGE" , 3  , 1  , 1    ) , 
          (4  ,   3   ,  "C++"  ,   "THIS IS c++ PAGE" , 4  , 1  , 1    ) , 
          (5  ,   3   ,  "web app"  ,   "THIS IS web PAGE" , 5  , 1  , 1    ) , 
          (6  ,   4   ,  "front end "  ,   "THIS IS frontend PAGE" , 1  , 1  , 1    ) , 
          (7  ,   4   ,  "pc"  ,   "THIS IS  pc" , 2  , 1  , 1    ) , 
          (8  ,   4   ,  "newwork"  ,   "THIS IS  newwork" , 3  , 1  , 1    ) , 
          (9  ,   4   ,  "c#"  ,   "THIS IS  c#" , 4  , 1  , 1    ) , 
          (10  ,   5   ,  "ruby"  ,  "THIS IS  ruby" , 1  , 1  , 1    ) , 
          (11  ,   5   ,  "javasercip "  ,  "THIS IS javasercip PAGE" , 2  , 1  , 1    ) , 
          (12  ,   5   ,  "notepad "  ,  "THIS IS notepad PAGE" , 3  , 1  , 1  )  ;  