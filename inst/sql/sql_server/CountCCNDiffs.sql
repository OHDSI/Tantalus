---
--- How many concept_class_name changes are there?
---

select count(*) cnt
  from @old_vocabulary_database_schema.concept_class cc1
  join @new_vocabulary_database_schema.concept_class cc2 on cc1.concept_class_id = cc2.concept_class_id
 where ltrim(rtrim(lower(cc1.concept_class_name))) != ltrim(rtrim(lower(cc2.concept_class_name)))
 
