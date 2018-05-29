---
--- Return vocabulary_version for given vocabularies.  Will be used in naming the JSON file.
---

select 
(select replace(vocabulary_version,' ','-') from @new_vocabulary_database_schema.vocabulary where vocabulary_id = 'none') current_vocab,
(select replace(vocabulary_version,' ','-') vocab from @old_vocabulary_database_schema.vocabulary where vocabulary_id = 'none') prior_vocab

