# Repository Contents
## barcodes.qsub
Execution: `qsub barcodes.qsub`  
Input: SRR3879604, SRR3879605, and SRR3879606 `SRRXXXXXXX_1_bc.fastq.gz` files
Output: `count.txt` which contains the number of reads per distinct barcode 

Extract barcodes from each run, and count the	number of reads per distinct barcode.	For each run, plot the cumulative distribution and histogram using `plot.R`, and run `UMI-tools` to confirm inflection point and retrieve the whitelist for `salmon alevin`

## index.qsub
Execution: `qsub index.qsub`  
Input: `gencode.v37.transcripts.fa` downloaded from the current human reference (GRCh38.p13) transcript sequences from [Gencode](https://www.gencodegenes.org/human/)  
Output: `gencode.v37.index`

Creates the salmon index of the reference transcriptome using `salmon index`

## mapping.qsub
Execution: `qsub mapping.qsub`  
Input: `gencode.v37.transcripts.fa` downloaded from the current human reference (GRCh38.p13) transcript sequences from [Gencode](https://www.gencodegenes.org/human/)  
Output: `txp2gene.tsv`

Transcript ID (ENSTXXX…) to gene (ENSGXXX…) map file as described in the `salmon alevin` documentation, to enable `salmon` to collapse from the transcript to the gene level.
