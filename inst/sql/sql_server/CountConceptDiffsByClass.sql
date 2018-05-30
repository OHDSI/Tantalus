---
--- How has the distribution of concepts changed, stratified by class?
---
	   
with concept1 as (
select concept_class_id, count(*) cnt
  from @old_vocabulary_database_schema.concept
 group by concept_class_id
), concept2 as (
select concept_class_id, count(*) cnt
  from @new_vocabulary_database_schema.concept
 group by concept_class_id
 )
 select c2.concept_class_id,c1.cnt old_count, c2.cnt new_count, c2.cnt - c1.cnt diff 
   from concept1 c1
   join concept2 c2 on c1.concept_class_id = c2.concept_class_id
  where c1.cnt - c2.cnt != 0
  order by 4 desc;
