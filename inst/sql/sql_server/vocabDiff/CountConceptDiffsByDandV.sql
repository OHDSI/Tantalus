---
--- How has the distribution of concepts changed, stratified by domain and vocab?
---
	   
with concept1 as (
select vocabulary_id, domain_id, count(*) cnt
  from @old_vocabulary_database_schema.concept
 group by vocabulary_id, domain_id
), concept2 as (
select vocabulary_id, domain_id, count(*) cnt
  from @new_vocabulary_database_schema.concept
 group by vocabulary_id, domain_id
 )
 select c2.vocabulary_id,c2.domain_id,c1.cnt old_count,c2.cnt new_count,c2.cnt - c1.cnt diff 
   from concept1 c1
   join concept2 c2 on c1.vocabulary_id = c2.vocabulary_id and c1.domain_id = c2.domain_id
  where c1.cnt - c2.cnt != 0
  order by 5 desc
