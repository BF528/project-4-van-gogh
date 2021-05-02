# Monil Gandhi - Programmer

#File Description - Created the unique molecular identified (UMI) count matrix and performed analysis using the Seurat object and outputs a .rda file

# install packages and load libraries
install.packages("pacman")
library("biomaRt")
require(pacman)  
library(reshape2)
library(grid)
library(gridExtra)
library(Seurat)
library(tximport)
library(SeqGSEA)
#loads the package needed to import alevin data
library("tximport", lib.loc="~/R/x86_64-pc-linux-gnu-library/3.6")

#run pacman for downloading the necessary libraries
pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, 
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny, 
               stringr, tidyr, ggpubr, grid, gridExtra, Seurat, tximport, biomaRt, SeqGSEA) 

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("fishpond")
BiocManager::install("SeqGSEA")
BiocManager::install('grimbough/biomaRt')
BiocManager::install('org.Hs.eg.db')
BiocManager::install("EnsDb.Hsapiens.v79")

library(AnnotationDbi)
library(EnsDb.Hsapiens.v79)
library(org.Hs.eg.db)

#import the file
file_path = file.path("/projectnb/bf528/users/van-gogh/project_4/data/salmon_output_merged_drop_100/alevin/quants_mat.gz")

#import the file using the tximport package 
file_avelian <- tximport(file_path, type="alevin", )

#creating the SeuratObject 
pbmc <- CreateSeuratObject(counts = file_avelian$counts, project = "proj4_panc", min.cells = 3, min.features = 200)

pbmc

#sub the gene symbols
gene_names <- sub("[.][0-9]*$", "", pbmc@assays$RNA@counts@Dimnames[[1]])

#using the EnsDb.Hsapiens.v79 to cover the ensembl symbols
geneIDs <- ensembldb::select(EnsDb.Hsapiens.v79, keys= gene_names, keytype = "GENEID", columns = c("SYMBOL","GENEID"))

#assign the symbols to the seurat object
gene_original_names <- geneIDs$SYMBOL

pbmc@assays$RNA@counts@Dimnames[[1]] <- gene_original_names
pbmc@assays$RNA@data@Dimnames[[1]] <- gene_original_names

#mitochondria PercentageFeatureSet - The percentage of reads that map to the mitochondrial genome
pbmc[["percent.mt"]] <- PercentageFeatureSet(pbmc, pattern = "^MT-")

# Visualize QC metrics as a violin plot
VlnPlot(pbmc, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)

# FeatureScatter is typically used to visualize feature-feature relationships, but can be used
# for anything calculated by the object, i.e. columns in object metadata, PC scores etc.
plot1 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "percent.mt")
plot2 <- FeatureScatter(pbmc, feature1 = "nCount_RNA", feature2 = "nFeature_RNA")
CombinePlots(plots = list(plot1, plot2))

#subsetting the matrix based on certain paramters
pbmc <- subset(pbmc, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

pbmc

#normalize the data
pbmc <- NormalizeData(pbmc, normalization.method = "LogNormalize", scale.factor = 10000)

#Identification of highly variable features 
pbmc[["RNA"]]@meta.features <- data.frame(row.names = rownames(pbmc[["RNA"]]))
pbmc <- FindVariableFeatures(pbmc, selection.method = "vst", nfeatures = 2000)
top10 <- head(VariableFeatures(pbmc), 10)

#variable plot
plot1 <- VariableFeaturePlot(pbmc)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot2

#Scaling the data
all.genes <- rownames(pbmc)
pbmc <- ScaleData(pbmc, features = all.genes)

#Perform linear dimensional reduction
pbmc <- RunPCA(pbmc, features = VariableFeatures(object = pbmc))
print(pbmc[["pca"]], dims = 1:5, nfeatures = 5)
DimPlot(pbmc, reduction = "pca")
DimHeatmap(pbmc, dims = 1, cells = 500, balanced = TRUE)

#Determine the ‘dimensionality’ of the dataset
ElbowPlot(pbmc)

#Cluster the cells
pbmc <- FindNeighbors(pbmc, dims = 1:10)
pbmc <- FindClusters(pbmc, resolution = 1.5)
head(Idents(pbmc), 5)

#clusters dataframe
cluster_centers <- Idents(pbmc)
plot(cluster_centers)
df <- as.data.frame(table(cluster_centers))
df_10 <- df[1:10, ]

#Clusters histogram
p<-ggplot(data=df_10, aes(x=cluster_centers, y=Freq)) + ggtitle("Gene Count Bar Plot") + theme(plot.title = element_text(hjust = 0.5)) + 
  geom_bar(stat="identity")
p + labs(x = "Clusters", y = "Frequency", size = 16)

# save(pbmc, file = "/projectnb/bf528/users/van-gogh/project_4/programmer/pbmc.rda")
pbmc <- RunUMAP(pbmc, dims = 1:5)

DimPlot(pbmc, reduction = "umap")





