# Repository Contents
## barcodes.qsub
Execution: `qsub barcodes.qsub`  
Input: SRR3879604, SRR3879605, and SRR3879606 `SRRXXXXXXX_1_bc.fastq.gz` files
Output: `merged_counts.txt`, `whitelist.txt`, CDF of barcode frequencies

Extract barcodes from each run, merge them, and count the	number of reads per distinct barcode.	Plot the cumulative distribution using `plot.R`, and retrieve the whitelist for `salmon alevin`.

## index.qsub
Execution: `qsub index.qsub`  
Input: `gencode.v37.transcripts.fa` downloaded from the current human reference (GRCh38.p13) transcript sequences from [Gencode](https://www.gencodegenes.org/human/)  
Output: `gencode.v37.index`

Creates the salmon index of the reference transcriptome using `salmon index`

## mapping.qsub
Execution: `qsub mapping.qsub`  
Input: `gencode.v37.transcripts.fa` downloaded from the current human reference (GRCh38.p13) transcript sequences from [Gencode](https://www.gencodegenes.org/human/)  
Output: `txp2gene.tsv`

Creates transcript ID (ENSTXXX…) to gene (ENSGXXX…) map file as described in the `salmon alevin` documentation, to enable `salmon` to collapse from the transcript to the gene level.

## salmon.qsub
Execution: `qsub salmon.qsub`  
Input: `SRRXXXXXXX_1_bc.fastq.gz`, `SRRXXXXXXX_2.fastq.gz`, `gencode.v37.index`, `txp2gene.tsv`, `whitelist.txt`  
Output: `salmon_output/` with UMI matrix

Generates UMI matrix using `salmon alevin` and statistics about how well the reads mapped.
