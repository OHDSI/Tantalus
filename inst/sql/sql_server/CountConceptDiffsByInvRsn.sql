---
--- How has the distribution of concepts changed, stratified by invalid_reason?
---
	   
with concept1 as (
select invalid_reason, count(*) cnt
  from @old_vocabulary_database_schema.concept
 group by invalid_reason
), concept2 as (
select invalid_reason, count(*) cnt
  from @new_vocabulary_database_schema.concept
 group by invalid_reason
 )
 select case when c2.invalid_reason = 'D' then 'Deleted' else 'Updated' end reason,
        c1.cnt old_count, c2.cnt new_count, c2.cnt - c1.cnt diff 
   from concept1 c1
   join concept2 c2 on c1.invalid_reason = c2.invalid_reason
  where c1.cnt - c2.cnt != 0
  order by 4 desc
