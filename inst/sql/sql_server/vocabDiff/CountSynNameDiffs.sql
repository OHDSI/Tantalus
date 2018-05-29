---
--- How many concepts have lost synonyms?
---
 
with current_CS as (
select cs.concept_id, count(cs.concept_synonym_name) cnt
  from @new_vocabulary_database_schema.concept c
  join @new_vocabulary_database_schema.concept_synonym cs on c.concept_id = cs.concept_id 
 where c.standard_concept = 'S'
   and c.invalid_reason is null
 group by cs.concept_id
), prior_CS as (
select cs.concept_id, count(cs.concept_synonym_name) cnt
  from @old_vocabulary_database_schema.concept c
  join @old_vocabulary_database_schema.concept_synonym cs on c.concept_id = cs.concept_id 
 where c.standard_concept = 'S'
   and c.invalid_reason is null
 group by cs.concept_id
)
select count(*)
  from prior_CS pcs
  join current_CS ccs on pcs.concept_id = ccs.concept_id
 where pcs.cnt > ccs.cnt
 
