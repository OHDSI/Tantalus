/************************************************************************
Copyright 2018 Observational Health Data Sciences and Informatics

This file is part of VocabCompare

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
************************************************************************/
SELECT '14.01' AS test_id,
	'Concept_id missing between old and new vocab' AS test_description,
	'concept' AS vocabulary_table,
	old_concept.concept_id AS concept_id,
	old_concept.concept_name AS concept_name,
	old_concept.vocabulary_id,
	old_concept.domain_id,
	CONCAT (
		old_concept.concept_id,
		' (',
		old_concept.concept_name,
		')'
		) AS old_value,
	'' AS new_value
INTO @result_temp_table
FROM @old_vocabulary_database_schema.concept old_concept
LEFT JOIN @new_vocabulary_database_schema.concept new_concept
	ON old_concept.concept_id = new_concept.concept_id
WHERE new_concept.concept_id IS NULL;
