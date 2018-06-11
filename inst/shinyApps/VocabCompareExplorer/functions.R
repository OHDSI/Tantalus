# utils
checkNumericValues = function(x, output) {
	old <- getNumericFromString(x[8])
	new <- getNumericFromString(x[9])
	if (length(old) != length(new)) {
		return(FALSE)
	} else {
		if (length(old) == 0 && length(new) == 0) {
			return(TRUE)
		} else {
			return(identical(as.numeric(old),as.numeric(new)))
		}
	}
}

getNumericFromString = function(x) {
	y <- gregexpr("[0-9.]+", x)
	x2 <- sort(unlist(regmatches(x, y)))
}
