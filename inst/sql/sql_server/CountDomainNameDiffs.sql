---
--- How many domain name changes are there?
---

select count(*) cnt
  from @old_vocabulary_database_schema.domain d1
  join @new_vocabulary_database_schema.domain d2 on d1.domain_id = d2.domain_id
 where ltrim(rtrim(lower(d1.domain_name))) != ltrim(rtrim(lower(d2.domain_name)));
 
