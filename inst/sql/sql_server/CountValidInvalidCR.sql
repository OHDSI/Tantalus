---
--- Count the number of valid CR rows that have invalid standard concepts (parent or child).
---

with current_count as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept_relationship cr
  join @new_vocabulary_database_schema.concept c1 on cr.concept_id_1 = c1.concept_id
  join @new_vocabulary_database_schema.concept c2 on cr.concept_id_2 = c2.concept_id
 where cr.invalid_reason is null
   and c1.standard_concept = 'S'
   and c2.standard_concept = 'S'
   and (c1.invalid_reason is not null or c2.invalid_reason is not null)
 ), prior_count as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept_relationship cr
  join @old_vocabulary_database_schema.concept c1 on cr.concept_id_1 = c1.concept_id
  join @old_vocabulary_database_schema.concept c2 on cr.concept_id_2 = c2.concept_id
 where cr.invalid_reason is null
   and c1.standard_concept = 'S'
   and c2.standard_concept = 'S'
   and (c1.invalid_reason is not null or c2.invalid_reason is not null) 
)
select pc.cnt "prior", cc.cnt "current", cc.cnt - pc.cnt diff
  from prior_count pc, current_count cc;
 
