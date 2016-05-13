#' ---
#' title: "Benckmark: order"
#' author: "Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#' ---



#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')
#' 

library(data.table)
library(rbenchmark)

df = data.frame(col1 = rnorm(1000000), col2 = rnorm(1000000))
dt = data.table(df)
dt_key = copy(dt)
setkey(dt_key, col1, col2)

replications = 100

#' Function to test order using data.frame:

order_df_shell = function(df) {
    temp = df
    temp[order(temp$col1, -temp$col2),]
}

#' Function to test order using data.frame:

order_df_radix = function(df) {
    temp = df
    temp[order(temp$col1, -temp$col2, method = "radix"),]
}

#' Function to test order using data.table:

order_dt = function(dt) {
    temp = copy(dt)
    temp[order(col1, -col2), ]
}

#' Function to test order using data.table with index:

order_dt_key = function(dt_key) {
    temp = copy(dt_key)
    temp[order(col1, -col2), ]
}

#' Here we use rbenchmark to test above two functions

within(benchmark(order_df_shell_out <- order_df_shell(df),
                 order_df_radix_out <- order_df_radix(df),
                 order_dt_out <- order_dt(dt),
                 order_dt_key_out <- order_dt_key(dt_key),
                 replications = replications,
                 columns=c('test', 'replications', 'elapsed', "relative")),
       { average = elapsed/replications })
identical(data.table(order_df_shell_out), order_dt_out)

sessionInfo()
