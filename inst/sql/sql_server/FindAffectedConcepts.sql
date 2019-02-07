--
-- These queries help determine the impact the potential new vocabulary will have on cohorts
-- by determining which concept_ids have changed or are missing.
-- A "severity" flag is computed based on what changed.
--

-- Find CONCEPT table changes:
-- These are concept_ids that exist in both old and new vocabularies, but have changed in some way.

select c1.concept_id,
       case when c1.concept_name                  != c2.concept_name                  then 1 else 0 end name_change,
       case when c1.domain_id                     != c2.domain_id                     then 1 else 0 end domain_change,
       case when c1.vocabulary_id                 != c2.vocabulary_id                 then 1 else 0 end vocab_change,
       case when c1.concept_class_id              != c2.concept_class_id              then 1 else 0 end class_change,
       case when c1.concept_code                  != c2.concept_code                  then 1 else 0 end code_change,
       case when c1.valid_start_date              != c2.valid_start_date              then 1 else 0 end start_date_change,
       case when c1.valid_end_date                != c2.valid_end_date                then 1 else 0 end end_date_change,
       case when isnull(c1.invalid_reason,'NA')   != isnull(c2.invalid_reason,'NA')   then 1 else 0 end invalid_reason_change,
       case when isnull(c1.standard_concept,'NA') != isnull(c2.standard_concept,'NA') then 1 else 0 end standard_concept_change,
       0 relationship_change, 0 descendant_change, 0 is_missing,
       case when c1.domain_id                     != c2.domain_id
              or c1.vocabulary_id                 != c2.vocabulary_id
              or c1.concept_code                  != c2.concept_code
              or c1.valid_start_date              != c2.valid_start_date
              or c1.valid_end_date                != c2.valid_end_date
              or isnull(c1.invalid_reason,'NA')   != isnull(c2.invalid_reason,'NA')
              or isnull(c1.standard_concept,'NA') != isnull(c2.standard_concept,'NA') 
            then 1 else 0
       end severity  
  from @old_vocabulary_database_schema.concept c1
  join @new_vocabulary_database_schema.concept c2 
    on c1.concept_id = c2.concept_id
 where c1.concept_name                  != c2.concept_name
    or c1.domain_id                     != c2.domain_id
    or c1.vocabulary_id                 != c2.vocabulary_id
    or c1.concept_class_id              != c2.concept_class_id
    or c1.concept_code                  != c2.concept_code
    or c1.valid_start_date              != c2.valid_start_date
    or c1.valid_end_date                != c2.valid_end_date
    or isnull(c1.invalid_reason,'NA')   != isnull(c2.invalid_reason,'NA')
    or isnull(c1.standard_concept,'NA') != isnull(c2.standard_concept,'NA') 

union 

-- Find CONCEPT_RELATIONSHIP changes and deletions:
-- These concept_id_1s are from pairs of concept_ids whose relationship have been changed or removed. 

select concept_id_1 concept_id, 0,0,0,0,0,0,0,0,0,1,0,0
  from (
select * from @old_vocabulary_database_schema.concept_relationship where relationship_id in ('Mapped from','Maps to')
except
select * from @new_vocabulary_database_schema.concept_relationship where relationship_id in ('Mapped from','Maps to')
       ) tmp

union

-- Find CONCEPT_ANCESTOR changes and deletions:
-- These ancestor_concept_ids are from pairs of concept_ids whose ancestor-descendant relationships have been changed or removed. 

select ancestor_concept_id concept_id, 0,0,0,0,0,0,0,0,0,0,1,0
  from (
select ancestor_concept_id, descendant_concept_id from @old_vocabulary_database_schema.concept_ancestor
except
select ancestor_concept_id, descendant_concept_id from @new_vocabulary_database_schema.concept_ancestor
       ) tmp

union 

-- Find CONCEPT table deletions:
-- These are concept_ids that exist in the old, but not the new vocabulary.

select concept_id, 0,0,0,0,0,0,0,0,0,0,0,1 
  from (
select concept_id from @old_vocabulary_database_schema.concept
except
select concept_id from @new_vocabulary_database_schema.concept 
       ) tmp;
