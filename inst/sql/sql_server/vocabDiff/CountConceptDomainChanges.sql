---
--- Count how many concepts underwent domain changes from one vocab to the next.
---

select count(*) cnt
  from @old_vocabulary_database_schema.concept c1
  join @new_vocabulary_database_schema.concept c2 on c1.concept_id = c2.concept_id
 where ltrim(rtrim(lower(c1.domain_id))) != ltrim(rtrim(lower(c2.domain_id))) 
   and c1.standard_concept = 'S' and c2.standard_concept = 'S'
   and c1.invalid_reason is null and c2.invalid_reason is null
