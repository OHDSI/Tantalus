# Copyright 2018 Observational Health Data Sciences and Informatics
#
# This file is part of Tantalus
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Check Numeric Difference
#'
#' @description
#' Find and sort all the numeric values in the old and new value and returns if they are differences.
#'
#' @param x         result object
#'
#' @return
#' A boolean which is True if not all numerical value are present in both strings
#'
#' @export

checkNumericDifference = function(x, output) {
	old <- getNumericFromString(x[8])
	new <- getNumericFromString(x[9])
	if (length(old) != length(new)) {
		return(TRUE)
	} else {
		if (length(old) == 0 && length(new) == 0) {
			return(FALSE)
		} else {
			return(!identical(as.numeric(old),as.numeric(new)))
		}
	}
}

#' Get Numerical Values from String
#'
#' @description
#' Retrieves and order list of numerical values in a string
#'
#' @param str			  String to check
#'
#' @return
#' An ordered string list of numerical values
#'
#' @export
#'
getNumericFromString = function(str) {
	y <- gregexpr("[0-9.]+", str)
	x2 <- sort(unlist(regmatches(str, y)))
}
