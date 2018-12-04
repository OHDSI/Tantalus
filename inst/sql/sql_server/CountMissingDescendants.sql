---
--- Count the number of missing descendants.
---

with missingDescendants as (
select descendant_concept_id from @old_vocabulary_database_schema.concept_ancestor
except
select descendant_concept_id from @new_vocabulary_database_schema.concept_ancestor
)
select count(*) cnt
  from missingDescendants md
  join @old_vocabulary_database_schema.concept c on c.concept_id = md.descendant_concept_id;
 
