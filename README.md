# Project Description

Baron et al performed single cell RNA sequencing in a set of post-mortem human donor pancreatic cells from four subjects and two mouse models to better understand the cellular diversity in the pancreas. Analysis of the data identified previously known cell types as well as rare and novel cell type subpopulations, and created a more detailed characterization of the diversity of those cell types. In this project, we will attempt to replicate their primary findings using current analytical methodology and software packages.

In doing so, we will:
* Process the barcode reads of a single cell sequencing dataset
* Perform cell-by-gene quantification of UMI counts
* Perform quality control on a UMI counts matrix
* Analyze the UMI counts to identify clusters and marker genes for distinct cell type populations
* Ascribe biological meaning to the clustered cell types and identify novel marker genes associated with them

Baron, Maayan, Adrian Veres, Samuel L. Wolock, Aubrey L. Faust, Renaud Gaujoux, Amedeo Vetere, Jennifer Hyoje Ryu, et al. 2016. “A Single-Cell Transcriptomic Map of the Human and Mouse Pancreas Reveals Inter- and Intra-Cell Population Structure.” Cell Systems 3 (4): 346–60.e4. PMID: 27667365

# Contributors
* Data Curator: Elysha Sameth (@esameth) 
* Programmer: Monil Gandhi (@gandhimonil9823)
* Analyst: Andrew Gjelsteen (@agjelste)
* Biologist: Lindsay Wang (@LindsayW007) 

# Repository Contents
## Data Curator
### Data_Curator/barcodes.qsub
* Execution: `qsub barcodes.qsub`
* Description: Extracts barcodes from each run, and counts the	number of reads per distinct barcode.	For each run, it plots the cumulative distribution and histogram using `Data_Curator/plots.R`, and runs umi-tools to confirm inflection point and retrieve white-list
* Input: paths to runs SRR3879604, SRR3879605, and SRR3879606
* Output: `[run]_counts.txt` (number of reads per distinct barcode) , images of CDF and histogram, UMI-tools knee output 
