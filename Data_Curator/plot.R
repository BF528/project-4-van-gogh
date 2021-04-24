###################################################################
# Data Curator: Elysha Sameth					                            #    
#	                                                  		          #
# Process barcodes and plot the cumulative distribution           #
# Run using: R --vanilla --args counts_file < plot.R              #
###################################################################

# Get arguments
args <- commandArgs(trailingOnly = TRUE)
counts_file <-args[1]

# Read in count file
counts <- read.table(counts_file, row.names = 'V2')
colnames(counts) <- 'count'

# Order by counts and drop rows that don't have the correct barcode length
counts <- counts[order(counts$count), , drop=FALSE]
counts <- counts[nchar(rownames(counts)) == 19, , drop=FALSE]

# Create images
png("merged.png")
plot(ecdf(counts$count), main='CDF of Barcode Frequency',
     xlab='Rank', xlim=c(0,600))
dev.off()

# Write out whitelist file
writeLines(as.character(rownames(counts[100:nrow(counts), , drop=FALSE])), 
           file('whitelist.txt'), sep="\n")
