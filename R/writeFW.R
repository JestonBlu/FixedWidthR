#' Write to a file using a configurable fixed width format
#'
#' You can learn more about package authoring with RStudio at:
#'
#' @param conf Config list object
#' @param data Data Frame you are intending to write
#' @param file FALSE or character verctor of desired file name
write.fw <- function(conf, data, file = FALSE) {
  # How many columns in the conf file
  conf.cols = length(conf)

  # Put the data frame in the correct orders
  dta = data[, 1:conf.cols]

  # Look through each config list
  for (i in 1:conf.cols) {

    # Target vector (trim special characters)
    x = as.character(dta[, i])
    x = gsub(pattern = "[^0-9a-zA-Z]+", replacement = "", x = x)

    # Padding
    conf.padding = as.character(conf[[i]][5])
    conf.length = as.numeric(conf[[i]][3]) - as.numeric(conf[[i]][2]) + 1
    conf.align = as.character(conf[[i]][4])

    # Calculate Padding
    calc.padding = function(conf.padding, conf.length, dta.nchar) {
      x = paste(rep(conf.padding, conf.length - dta.nchar), collapse = "")
      return(x)
    }

    # Get Padding
    tmp.padding = as.character(lapply(X = x, FUN = function(X) calc.padding(conf.padding, conf.length, nchar(as.character(X)))))

    # Get Alignment
    if (conf.align == "l") {
      dta[, i] = paste(x, tmp.padding, sep = "")
    } else {
      dta[, i] = paste(tmp.padding, x, sep = "")
    }
  }

  # Write out file
  if (file != FALSE) {
    write.table(x = dta, file = file, sep = "", quote = FALSE, col.names = FALSE)
  } else {
    return(dta)
  }

}
