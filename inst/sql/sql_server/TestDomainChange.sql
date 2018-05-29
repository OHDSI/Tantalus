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
SELECT '10.01' AS test_id,
	'Concept domain changed' AS test_description,
	'concept' AS vocabulary_table,
	new_concept.concept_id AS concept_id,
	new_concept.concept_name AS concept_name,
	new_concept.vocabulary_id,
	new_concept.domain_id,
	old_concept.domain_id AS old_value,
	new_concept.domain_id AS new_value
INTO @result_temp_table
FROM @old_vocabulary_database_schema.concept old_concept
INNER JOIN @new_vocabulary_database_schema.concept new_concept
	ON old_concept.concept_id = new_concept.concept_id
WHERE old_concept.domain_id != new_concept.domain_id;
