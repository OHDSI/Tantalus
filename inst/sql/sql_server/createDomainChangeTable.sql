IF OBJECT_ID('@target_database_schema.@domain_change_table') IS NOT NULL
    DROP TABLE @target_database_schema.@domain_change_table;

CREATE TABLE @target_database_schema.@domain_change_table (
    [concept_id] int,
    [old_domain_id] varchar(255),
    [new_domain_id] varchar(255),
    [domain_switch] int,
    [standard_concept] varchar(2)
)
WITH (DISTRIBUTION = REPLICATE);
