#' ---
#' title: "Benckmark: read data"
#' author: "Mansun Kuo"
#' date: "`r Sys.Date()`"
#' output: 
#'   html_document: 
#'     toc: yes
#'     toc_float: true
#' ---

#+ include=FALSE
# set root dir when rendering
knitr::opts_knit$set(root.dir = '..')
#' 

library(data.table)
replications = 10

#' ## Read small files

filepaths = list.files("data/daily/", pattern = "*.csv", full.names = TRUE)
locations = gsub("data\\/daily\\/|_....-..-..\\.csv", "", filepaths)
dates = gsub("data\\/daily\\/.*_|\\.csv", "", filepaths)

get_dt = function() {
    dt = list()
    for (i in 1:length(filepaths)) {
        dt[[i]] = fread(filepaths[i])
        dt[[i]][, city := locations[i]]
        dt[[i]][, date := dates[i]]
    }
    rbindlist(dt)
}


get_df = function() {
    df = list()
    for (i in 1:length(filepaths)) {
        df[[i]] = read.csv(filepaths[i])
        df[[i]]$city = locations[i]
        df[[i]]$date = dates[i]
    }
    do.call(rbind, df)
}


#' Here we use rbenchmark to test above two functions

library(rbenchmark)
within(benchmark(get_dt(), get_df(), replications = replications,
                 columns=c('test', 'replications', 'elapsed', "relative")),
       { average = elapsed/replications })


#' ## Write data

weather = get_dt()
within(benchmark(fwrite(weather, "weather.csv"), 
                 write.csv(weather, "weather.csv"), 
                 replications = replications,
                 columns=c('test', 'replications', 'elapsed', "relative")),
       { average = elapsed/replications })


#' ## Read a larger file

within(benchmark(weather <- fread("weather.csv"), 
                 weather <- read.csv("weather.csv"), 
                 replications = replications,
                 columns=c('test', 'replications', 'elapsed', "relative")),
       { average = elapsed/replications })
