#' Write to a file using a configurable fixed width format
#'
#' You can learn more about package authoring with RStudio at:
#'
#' @param conf Config list object
#' @param data Data Frame you are intending to write
#' @param file Write to File? (FALSE or string to be the file name) (optional)
#' @seealso \code{\link{fw.check}} for config validation function
#' @importFrom utils write.table
#' @export
#' @examples
#' # Example Configuration List
#' conf = list(
#'   item1 = list(
#'     start = 1,
#'     end = 10,
#'     align = "l",
#'     padding = " ",
#'     required = TRUE
#'   ),
#'   item2 = list(
#'     start = 11,
#'     end = 20,
#'     align = "r",
#'     padding = 0,
#'     required = FALSE,
#'     default = " "
#'   )
#' )
#'
#' # Example Data
#' data = data.frame(item1 = c("AAAA", "BBBB", "CCCC"), item2 = c(254, 2.25, 1.4))
#'
#' fw.make(conf, data, file = FALSE)
fw.make <- function(conf, data, file = FALSE) {
  # Number of column in the configuration
  conf.cols = length(conf)
  conf.names = names(conf)

  # Make the non-required fields
  # Make a Data Frame of the non required fields with default values
  x = c()
  x2 = data.frame(1)
  for (i in 1:conf.cols) {
    if (conf[[i]][5] == FALSE) {
      x = c(x, i)
      x2 = cbind(x2, data.frame(conf[[i]][6]))
    }
  }
  x2 = data.frame(x2[, -1])
  colnames(x2) = conf.names[x]

  data = cbind(data, x2)

  # Put the data frame in the correct orders
  dta = data[, conf.names]

  # Apply string formatting to all columns
  dta = apply(X = dta, MARGIN = 2, FUN = function(X) as.character(X))

  # Look through each config list
  for (i in 1:conf.cols) {

    # Target vector (trim special characters)
    x = as.character(dta[, i])
    x = gsub(pattern = "[^0-9a-zA-Z]+", replacement = "", x = x)

    # Padding
    conf.padding = as.character(conf[[i]][4])
    conf.length = as.numeric(conf[[i]][2]) - as.numeric(conf[[i]][1]) + 1
    conf.align = as.character(conf[[i]][3])

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
    row.names(dta) = NULL
   write.table(x = dta, file = file, sep = "", quote = FALSE, col.names = FALSE)
  } else {
   return(dta)
  }
}
