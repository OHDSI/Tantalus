---
--- Count how many concepts underwent name changes from one vocab to the next.
---

select count(*) cnt
  from @old_vocabulary_database_schema.concept c1
  join @new_vocabulary_database_schema.concept c2 on c1.concept_id = c2.concept_id
 where ltrim(rtrim(lower(c1.concept_name))) != ltrim(rtrim(lower(c2.concept_name)));

   
