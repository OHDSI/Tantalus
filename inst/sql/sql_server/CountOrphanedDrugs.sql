---
--- Count how many drugs do not map to their ingredient.
---
		
with current_orphans as (
select count(*) cnt
  from (
select ca.descendant_concept_id
  from @new_vocabulary_database_schema.concept c
  join @new_vocabulary_database_schema.concept_ancestor ca on ca.descendant_concept_id = c.concept_id
  join @new_vocabulary_database_schema.concept          c2 on c2.concept_id = ca.ancestor_concept_id
 where c.domain_id = 'drug' 
 group by ca.descendant_concept_id
having 0 =  max(case when c2.concept_class_id = 'ingredient' then 1 else 0 end)
       ) tmp
), prior_orphans as (
select count(*) cnt
  from (
select ca.descendant_concept_id cnt
  from @old_vocabulary_database_schema.concept c
  join @old_vocabulary_database_schema.concept_ancestor ca on ca.descendant_concept_id = c.concept_id
  join @old_vocabulary_database_schema.concept          c2 on c2.concept_id = ca.ancestor_concept_id
 where c.domain_id = 'drug' 
 group by ca.descendant_concept_id
having 0 =  max(case when c2.concept_class_id = 'ingredient' then 1 else 0 end)
       ) tmp
)
select po.cnt "prior", co.cnt "current", co.cnt-po.cnt diff
  from current_orphans co, prior_orphans po;
