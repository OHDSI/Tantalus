IF OBJECT_ID('@target_database_schema.@map_switches_cdm_table') IS NOT NULL
    DROP TABLE @target_database_schema.@map_switches_cdm_table;

CREATE TABLE @target_database_schema.@map_switches_cdm_table (
    [db] varchar(255),
    [table_name] varchar(255),
    [source_code] varchar(255),
    [source_vocabulary_id] varchar(255),
    [old_target_concept_Id] int,
    [old_target_deprecated] int,
    [new_target_concept_id] int,
    [new_target_domain_id] varchar(255),
    [NEW_MAP_EXISTS_IN_OLD_VOCAB] int,
    [concept_name] varchar(255),
    [person_count] bigint
)
WITH (DISTRIBUTION = REPLICATE);

