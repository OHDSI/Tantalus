IF OBJECT_ID('tempdb..#domainChange') IS NOT NULL
    DROP TABLE tempdb..#domainChange;

SELECT *
into #domainChange
FROM (
     SELECT @source_short_name AS DB,
    	'CONDITION_OCCURRENCE' AS TABLE_NAME,
    	VC.CONCEPT_ID,
    	OLD_DOMAIN_ID,
    	NEW_DOMAIN_ID,
    	CONCEPT_NAME,
    	COUNT(*) AS PERSON_COUNT
    FROM @cdm_database_schema.CONDITION_OCCURRENCE CO
    JOIN @target_database_schema.@domain_change_table VC
    	ON CO.CONDITION_CONCEPT_ID = VC.CONCEPT_ID
    JOIN @old_vocab_schema.CONCEPT C
    	ON VC.CONCEPT_ID = C.CONCEPT_ID
    GROUP BY VC.CONCEPT_ID, OLD_DOMAIN_ID, NEW_DOMAIN_ID, CONCEPT_NAME
    --ORDER BY COUNT(*) DESC
    UNION ALL

     SELECT @source_short_name AS DB,
    	'PROCEDURE_OCCURRENCE' AS TABLE_NAME,
    	VC.CONCEPT_ID,
    	OLD_DOMAIN_ID,
    	NEW_DOMAIN_ID,
    	CONCEPT_NAME,
    	COUNT(*) AS PERSON_COUNT
    FROM @cdm_database_schema.PROCEDURE_OCCURRENCE CO
    JOIN @target_database_schema.@domain_change_table VC
    	ON CO.PROCEDURE_CONCEPT_ID = VC.CONCEPT_ID
    JOIN @old_vocab_schema.CONCEPT C
    	ON VC.CONCEPT_ID = C.CONCEPT_ID
    GROUP BY VC.CONCEPT_ID, OLD_DOMAIN_ID, NEW_DOMAIN_ID, CONCEPT_NAME
    --ORDER BY COUNT(*) DESC
    UNION ALL

     SELECT @source_short_name AS DB,
    	'MEASUREMENT' AS TABLE_NAME,
    	VC.CONCEPT_ID,
    	OLD_DOMAIN_ID,
    	NEW_DOMAIN_ID,
    	CONCEPT_NAME,
    	COUNT(*) AS PERSON_COUNT
    FROM @cdm_database_schema.MEASUREMENT CO
    JOIN @target_database_schema.@domain_change_table VC
    	ON CO.MEASUREMENT_CONCEPT_ID = VC.CONCEPT_ID
    JOIN @old_vocab_schema.CONCEPT C
    	ON VC.CONCEPT_ID = C.CONCEPT_ID
    GROUP BY VC.CONCEPT_ID, OLD_DOMAIN_ID, NEW_DOMAIN_ID, CONCEPT_NAME
    --ORDER BY COUNT(*) DESC

    UNION ALL

     SELECT @source_short_name AS DB,
    	'OBSERVATION' AS TABLE_NAME,
    	VC.CONCEPT_ID,
    	OLD_DOMAIN_ID,
    	NEW_DOMAIN_ID,
    	CONCEPT_NAME,
    	COUNT(*) AS PERSON_COUNT
    FROM @cdm_database_schema.OBSERVATION CO
    JOIN @target_database_schema.@domain_change_table VC
    	ON CO.OBSERVATION_CONCEPT_ID = VC.CONCEPT_ID
    JOIN @old_vocab_schema.CONCEPT C
    	ON VC.CONCEPT_ID = C.CONCEPT_ID
    GROUP BY VC.CONCEPT_ID, OLD_DOMAIN_ID, NEW_DOMAIN_ID, CONCEPT_NAME
    --ORDER BY COUNT(*) DESC

    UNION ALL

     SELECT @source_short_name AS DB,
    	'DRUG_EXPOSURE' AS TABLE_NAME,
    	VC.CONCEPT_ID,
    	OLD_DOMAIN_ID,
    	NEW_DOMAIN_ID,
    	CONCEPT_NAME,
    	COUNT(*) AS PERSON_COUNT
    FROM @cdm_database_schema.DRUG_EXPOSURE CO
    JOIN @target_database_schema.@domain_change_table VC
    	ON CO.DRUG_CONCEPT_ID = VC.CONCEPT_ID
    JOIN @old_vocab_schema.CONCEPT C
    	ON VC.CONCEPT_ID = C.CONCEPT_ID
    GROUP BY VC.CONCEPT_ID, OLD_DOMAIN_ID, NEW_DOMAIN_ID, CONCEPT_NAME
    --ORDER BY COUNT(*) DESC
) a
;

insert into @target_database_schema.@domain_change_cdm_table (
    db,
    table_name,
    concept_id,
    old_domain_id,
    new_domain_id,
    concept_name,
    person_count
)

SELECT *
FROM #domainChange;


