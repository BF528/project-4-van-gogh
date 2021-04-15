###################################################################
# Data Curator: Elysha Sameth					                            #    
#	                                                  						  #
# Plot the cumulative distribution and histogram.                 #
# Run using: R --vanilla --args run_id counts_file < plot.R       #
###################################################################

# Get arguments
args <- commandArgs(trailingOnly = TRUE)
run_id <- args[1]
counts_file <-args[2]

# Read in count file
counts <- read.table(counts_file, row.names = 'V2')
colnames(counts) <- 'count'

# Create images
png(paste(run_id, ".png"))
par(mfrow=c(1,2), oma=c(0,0,2,0))
plot(ecdf(counts$count), main='CDF of Barcode Frequency',
     xlab='Unique Barcode Frequency')
hist(log10(counts$count), main='Histogram of Barcode Frequency', 
     xlab='Unique Barcode Frequency (log10)')
mtext(run_id, line=0, side=3, outer=TRUE, cex=2)
dev.off()