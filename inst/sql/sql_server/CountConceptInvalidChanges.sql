---
--- How many concepts have become invalid?
---
	   
select count(*)
  from @old_vocabulary_database_schema.concept c1
  join @new_vocabulary_database_schema.concept c2 on c1.concept_id = c2.concept_id
 where c1.invalid_reason is null
   and c2.invalid_reason is not null;
   
