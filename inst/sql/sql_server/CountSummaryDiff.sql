---
---  Return the old count, new count, and diff for each table in the vocab.
--- 
with prior_concept as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept 
 ), current_concept as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept 
), prior_concept_ancestor as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept_ancestor 
), current_concept_ancestor as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept_ancestor 
), prior_concept_class as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept_class 
), current_concept_class as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept_class 
), prior_concept_relationship as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept_relationship 
), current_concept_relationship as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept_relationship 
), prior_concept_synonym as (
select count(*) cnt
  from @old_vocabulary_database_schema.concept_synonym 
), current_concept_synonym as (
select count(*) cnt
  from @new_vocabulary_database_schema.concept_synonym 
), prior_domain as (
select count(*) cnt
  from @old_vocabulary_database_schema.domain 
), current_domain as (
select count(*) cnt
  from @new_vocabulary_database_schema.domain 
), prior_relationship as (
select count(*) cnt
  from @old_vocabulary_database_schema.relationship 
), current_relationship as (
select count(*) cnt
  from @new_vocabulary_database_schema.relationship 
), prior_vocabulary as (
select count(*) cnt
  from @old_vocabulary_database_schema.vocabulary 
), current_vocabulary as (
select count(*) cnt
  from @new_vocabulary_database_schema.vocabulary 
)
select 'CONCEPT' table_name,
       pc.cnt old_count,
       cc.cnt new_count,
       cc.cnt-pc.cnt diff
  from prior_concept pc,
       current_concept cc
 union all
select 'CONCEPT_ANCESTOR',
       pca.cnt old_ca_count,
       cca.cnt new_ca_count,
       cca.cnt-pca.cnt ca_diff
  from prior_concept_ancestor pca,
       current_concept_ancestor cca
 union all
select 'CONCEPT_CLASS',
       pcc.cnt old_cc_count,
       ccc.cnt new_cc_count,
       ccc.cnt-pcc.cnt cc_diff
  from prior_concept_class pcc,
       current_concept_class ccc
 union all
select 'CONCEPT_RELATIONSHIP',
       pcr.cnt old_cr_count,
       ccr.cnt new_cr_count,
       ccr.cnt-pcr.cnt cr_diff
  from prior_concept_relationship pcr,
       current_concept_relationship ccr
 union all
select 'CONCEPT_SYNONYM',
       pcs.cnt old_cs_count,
       ccs.cnt new_cs_count,
       ccs.cnt-pcs.cnt cs_diff
  from prior_concept_synonym pcs,
       current_concept_synonym ccs
 union all
select 'DOMAIN',
       pd.cnt old_dom_count,
       cd.cnt new_dom_count,
       cd.cnt-pd.cnt dom_diff
  from prior_domain pd,
       current_domain cd
 union all
select 'RELATIONSHIP',
       pr.cnt old_count,
       cr.cnt new_count,
       cr.cnt-pr.cnt rel_diff
  from prior_relationship pr,
       current_relationship cr
 union all
select 'VOCABULARY',
       pv.cnt old_vocab_count,
       cv.cnt new_vocab_count,
       cv.cnt-pv.cnt vocab_diff      
  from prior_vocabulary pv,
       current_vocabulary cv;
       
       

