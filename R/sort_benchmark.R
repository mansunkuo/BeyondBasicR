library(rbenchmark)
library(data.table)
x = matrix(rnorm(100000*100), nrow = 100000, ncol = 100)
n = 20

topn_index_order = function(x, n) {
    head(order(x, decreasing = TRUE), n)
}

topn_index_dt = function(xx, n) {
    xx = as.vector(xx)
    dt = data.table(value = xx,
                    index = seq.int(1, length(xx)))
    setkey(dt, value)
    dt[order(-value), index][seq.int(1, n)]
}

benchmark(x1 <- apply(x, 2, topn_index_order, n),
          x2 <- apply(x, 2, topn_index_dt, n),
          replications = 1)
identical(x1, x2)
