![](https://travis-ci.org/JestonBlu/fixedWidth.svg?branch=master)
![CII Best Practices](htps://bestpractices.coreinfrastructure.org/projects/2041)

# An R Package for Writing Configurable Fixed Width Files

This package is intended to help make creating fixed width files easier to generate in R where customization is needed on a column by column basis. 

```r
devtools::install_github("jestonblu/fixedWidth")
```

The main function behind this package is `fw.make(conf, data)`. It leverages a configuration input stored as a list object to convert a data frame into a fixed width file. Be aware that this function strips out all special characters from the input dataframe. Numeric data in decimal format will use the highest precision value as the basis for padding. It is recommended that you trim your numeric data to a standard decimal position.

```r
# Example Configuration List
conf = list(
  item1 = list(
    start = 1,
    end = 10,
    align = "l",
    padding = " ",
    trim = TRUE,
    required = TRUE
  ),
item2 = list(
    start = 11,
    end = 20,
    align = "r",
    padding = 0,
    trim = TRUE,
    required = FALSE,
    default = " "
  )
)

# Example Data Frame
data = data.frame(item1 = c("AAAA", " BBBB", "CCCC"), item2 = c(254, 2.25, 1.4))

fw.make(conf, data, file = 'EXAMPLE')

# EXAMPLE file output
# AAAA      0000025400
# BBBB      0000000225
# CCCC      0000000140

```
