--IF OBJECT_ID('tempdb..#DOMAIN_CHANGE', 'U') IS NOT NULL DROP TABLE #DOMAIN_CHANGE
IF OBJECT_ID('@target_database_schema.@domain_change_table') IS NOT NULL
    DROP TABLE @target_database_schema.@domain_change_table;

SELECT *
INTO @target_database_schema.@domain_change_table
FROM (
	SELECT C.CONCEPT_ID,
			C.DOMAIN_ID AS OLD_DOMAIN_ID,
			C1.DOMAIN_ID AS NEW_DOMAIN_ID,
			CASE
				WHEN C.DOMAIN_ID <> C1.DOMAIN_ID
					THEN 1
				ELSE 0
			END AS DOMAIN_SWITCH,
			C1.STANDARD_CONCEPT

	FROM @oldVocabSchema.CONCEPT C
	JOIN @newVocabSchema.CONCEPT C1
		ON C.CONCEPT_ID = C1.CONCEPT_ID
 ) B
 WHERE DOMAIN_SWITCH = 1 AND STANDARD_CONCEPT = 'S'
 ;
