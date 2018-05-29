---
--- How has the distribution of concepts changed, stratified by standard_concept?
---
	   
with concept1 as (
select standard_concept, count(*) cnt
  from @old_vocabulary_database_schema.concept
 group by standard_concept
), concept2 as (
select standard_concept, count(*) cnt
  from @new_vocabulary_database_schema.concept
 group by standard_concept
 )
 select case when c2.standard_concept = 'S' then 'Standard'
             when c2.standard_concept = 'C' then 'Classification'
             when c2.standard_concept is null then 'Non-Standard'
         end standard_concept,c1.cnt old_count, c2.cnt new_count, c2.cnt - c1.cnt diff 
   from concept1 c1
   join concept2 c2 on c1.standard_concept = c2.standard_concept
  where c1.cnt - c2.cnt != 0
  order by 4 desc
