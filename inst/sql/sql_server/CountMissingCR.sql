---
--- Count the number of missing relationships.
---

select count(*) cnt
  from (
select concept_id_1, concept_id_2 
  from @old_vocabulary_database_schema.concept_relationship cr
  join @old_vocabulary_database_schema.concept c1 on cr.concept_id_1 = c1.concept_id
  join @old_vocabulary_database_schema.concept c2 on cr.concept_id_2 = c2.concept_id
except
select concept_id_1, concept_id_2 
  from @new_vocabulary_database_schema.concept_relationship cr
  join @new_vocabulary_database_schema.concept c1 on cr.concept_id_1 = c1.concept_id
  join @new_vocabulary_database_schema.concept c2 on cr.concept_id_2 = c2.concept_id
       ) tmp;
