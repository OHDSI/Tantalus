---
--- How has relationship changed?
---

select sum(case when r1.is_hierarchical  != r2.is_hierarchical then 1 else 0 end) change_hierarchy,
       sum(case when r1.defines_ancestry != r2.defines_ancestry then 1 else 0 end) change_ancestry,
       sum(case when r1.reverse_relationship_id != r2.reverse_relationship_id then 1 else 0 end) change_reverse_rel,
       sum(case when r1.relationship_concept_id != r2.relationship_concept_id then 1 else 0 end) change_rel_concept
  from @old_vocabulary_database_schema.relationship r1
  join @new_vocabulary_database_schema.relationship r2 on r1.relationship_id = r2.relationship_id
  
