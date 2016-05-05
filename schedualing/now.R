#!/usr/bin/env Rscript

# Use argparser
library(argparser, quietly = TRUE)

# Create an arg.parser object.
p <- arg_parser("Hi! What time it is?")

# Add a positional argument
p <- add_argument(p, arg = "who", help = "Who are you")

# Add an optional argument
# Rscript will raise a warning message if you pass with -g
# but it doenn't matter
p <- add_argument(p, arg = "--greeting", short = "-g", default = "How's going?", type = "character",
                  help = "Greeting word")

# Add a flag, default value is FALSE
p <- add_argument(p, arg = "--chat", short = "-c", flag = TRUE,
                  help = "Whether or not to have a greeting")

# Parse commandArgs(trailingOnly = TRUE) into args
args <- parse_args(p)

print(args)
str(args)

# The original arguments
command_args <- commandArgs(trailingOnly = TRUE)
cat("args:")
print(command_args)

# Get system time
now <- as.character(Sys.time())

# Construct greeting string
greeting <- sprintf("Hi %s! It is %s.", args$who, now)

if (args$chat) {
    greeting <-  paste(greeting, args$greeting)
}

print(greeting)

# Write to a text file
writeChar(greeting, "now.txt")
