---
--- How many CA parent-child mappings have been lost?
---

select count(*) cnt
  from ( 
select ca.ancestor_concept_id, ca.descendant_concept_id
  from @old_vocabulary_database_schema.concept_ancestor ca
  join @old_vocabulary_database_schema.concept c1 on c1.concept_id = ca.descendant_concept_id
  join @old_vocabulary_database_schema.concept c2 on c2.concept_id = ca.ancestor_concept_id
except
select ca.ancestor_concept_id, ca.descendant_concept_id
  from @new_vocabulary_database_schema.concept_ancestor ca
  join @new_vocabulary_database_schema.concept c1 on c1.concept_id = ca.descendant_concept_id
  join @new_vocabulary_database_schema.concept c2 on c2.concept_id = ca.ancestor_concept_id
       ) tmp;
