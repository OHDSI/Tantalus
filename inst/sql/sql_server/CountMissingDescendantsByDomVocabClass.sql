---
--- Distribution of missing descendants stratified by domain, vocab, concept_class.
--- Rewrite this query as soon as a future version of APS supports ROLLUP() or GROUPING_SETS(), 
--- so we won't need to do the unioning and pivoting.
---
--- Query breakdown:
---  (i)    CTE "missingDescendants" contains descendants that exist in the old vocab, but not the new.
---  (ii)   CTE "stacked" contains the distribution of these missing descendants by domain,
---         vocabulary, and concept class - unioned together.
---  (iii)  CTE "sparse" uses the "flag" column to correctly pivot the rows into columns.
---         The use of row_number() is to enable us to rank the domain, vocab, and class rows separately.
---  (iv)   The final part of the query uses max and rn to squeeze out the nulls.
---

with missingDescendants as (
select descendant_concept_id 
  from @old_vocabulary_database_schema.concept_ancestor
except
select descendant_concept_id 
  from @new_vocabulary_database_schema.concept_ancestor
), stacked as (
select 'domain' flag, c.domain_id colName, count(*) cnt
  from @old_vocabulary_database_schema.concept c
 where c.concept_id in (select descendant_concept_id from missingDescendants)
 group by c.domain_id
 union all
select 'vocab' flag, c.vocabulary_id, count(*) cnt
  from @old_vocabulary_database_schema.concept c
 where c.concept_id in (select descendant_concept_id from missingDescendants)
 group by c.vocabulary_id
 union all
select 'class' flag, c.concept_class_id, count(*) cnt
  from @old_vocabulary_database_schema.concept c
 where c.concept_id in (select descendant_concept_id from missingDescendants)
 group by c.concept_class_id
), sparse as (
select case when flag = 'vocab'  then colName end vocabulary_id,
       case when flag = 'vocab'  then cnt     end vocab_cnt,
       case when flag = 'domain' then colName end domain_id,
       case when flag = 'domain' then cnt     end domain_cnt,
       case when flag = 'class'  then colName end concept_class_id,   
       case when flag = 'class'  then cnt     end concept_class_cnt,   
       row_number()over(partition by flag order by cnt) rn
  from stacked
)
select max(vocabulary_id)      vocabulary_id,
       max(vocab_cnt)          vocab_count,
       max(domain_id)          domain_id,
       max(domain_cnt)         domain_count,
       max(concept_class_id)   concept_class_id,
       max(concept_class_cnt)  concept_class_count
  from sparse
 group by rn;
