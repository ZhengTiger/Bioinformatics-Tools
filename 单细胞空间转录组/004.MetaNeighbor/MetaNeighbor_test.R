library(MetaNeighbor)
library(SummarizedExperiment)
library(ggplot2)
source('F:/Github/Biorplot/main/Biorplot.R')
data(mn_data)
data(GOmouse)

# 5.1 Part 1: Supervised MetaNeighbor
AUROC_scores = MetaNeighbor(dat = mn_data,
                            experiment_labels = as.numeric(factor(mn_data$study_id)),
                            celltype_labels = metadata(colData(mn_data))[["cell_labels"]],
                            genesets = GOmouse,
                            bplot = TRUE)
head(AUROC_scores)


# 5.2 Part 2: MetaNeighbor for Data Exploration
library(SingleCellExperiment)
library(Matrix)
baron <- Exlabel_seuratobject
segerstolpe <- Exlabel_seuratobject
common_genes <- intersect(rownames(baron), rownames(segerstolpe))
baron <- baron[common_genes,]
segerstolpe <- segerstolpe[common_genes,]

new_colData = data.frame(
  study_id = rep(c('study_1', 'study_2'), c(ncol(baron), ncol(segerstolpe))),
  cell_type = c(as.character(baron@active.ident), as.character(segerstolpe@active.ident))
)
baron_assays <- baron@assays$RNA@data
colnames(baron_assays) <- paste(rep('study1',ncol(baron_assays)),colnames(baron_assays),sep = '_')
segerstolpe_assays <- segerstolpe@assays$RNA@data
colnames(segerstolpe_assays) <- paste(rep('study2',ncol(segerstolpe_assays)),colnames(segerstolpe_assays),sep = '_')
pancreas <- SingleCellExperiment(
  Matrix(cbind(baron_assays, segerstolpe_assays), sparse = TRUE),
  colData = new_colData
)
dim(pancreas)
celltype_NV = MetaNeighborUS(var_genes = VariableFeatures(object = Exlabel_seuratobject),
                             dat = pancreas,
                             study_id = pancreas$study_id,
                             cell_type = pancreas$cell_type,
                             fast_version = TRUE)
celltype_cor <- celltype_NV[1:38,1:38]
colnames(celltype_cor) <- levels(Exlabel_seuratobject)
rownames(celltype_cor) <- levels(Exlabel_seuratobject)

cols = rev(colorRampPalette(RColorBrewer::brewer.pal(11,"RdYlBu"))(100))
breaks = seq(0, 1, length=101)
library(pheatmap)
breaks <- seq(0.5,1,0.01)
celltype_cor <- celltype_cor[1:31,1:31]
pheatmap(celltype_cor,cluster_rows = F, cluster_cols=F, gaps_row=c(7,21,28),gaps_col=c(7,21,28), 
         color = colorRampPalette(c("white","#D62728FF"))(length(breaks)),
         legend_breaks = seq(0.5,1,0.1),breaks = breaks,main = 'Transcriptome similarity',
         fontsize_row=10,fontsize_col=10,fontsize=20)
write.csv(celltype_cor,file = 'outputfile/10.转录组相似度.csv')

# barcode 和 38群相似度
barcode_cluster <- read.csv('F:/1.课题/1.神经环路/2.实验汇总/3.barcode聚类分析/outfile/3.barcode_cluster.csv',row.names = 1)
t_cluster <- Exlabel_seuratobject
b_cluster <- subset(Exlabel_seuratobject,cells=rownames(barcode_cluster))
b_cluster$barcode_cluster <- barcode_cluster$Target_Cluster
common_genes <- intersect(rownames(t_cluster), rownames(b_cluster))
t_cluster <- t_cluster[common_genes,]
b_cluster <- b_cluster[common_genes,]

new_colData = data.frame(
  study_id = rep(c('t_cluster', 'b_cluster'), c(ncol(t_cluster), ncol(b_cluster))),
  cell_type = c(as.character(t_cluster@active.ident), as.character(b_cluster$barcode_cluster))
)

t_cluster_assays <- t_cluster@assays$RNA@data
colnames(t_cluster_assays) <- paste(rep('t_cluster',ncol(t_cluster_assays)),colnames(t_cluster_assays),sep = '_')
b_cluster_assays <- b_cluster@assays$RNA@data
colnames(b_cluster_assays) <- paste(rep('b_cluster',ncol(b_cluster_assays)),colnames(b_cluster_assays),sep = '_')
pancreas <- SingleCellExperiment(
  Matrix(cbind(t_cluster_assays, b_cluster_assays), sparse = TRUE),
  colData = new_colData
)
dim(pancreas)
celltype_NV = MetaNeighborUS(var_genes = VariableFeatures(object = Exlabel_seuratobject),
                             dat = pancreas,
                             study_id = pancreas$study_id,
                             cell_type = pancreas$cell_type,
                             fast_version = TRUE)
cluster_target_cor <- celltype_NV[39:46,1:28]
colnames(cluster_target_cor) <- levels(Exlabel_seuratobject)[1:28]
cluster_target_cor <- cluster_target_cor[c(3,2,4,6,5,1,7,8),]
rownames(cluster_target_cor) <- c('CPU.L single-target','CPU multi-target','CPU.R single-target',
                                  'NAc.L single-target','NAc.L multi-target','BLA.L multi-target',
                                  'V2.L multi-target','V2.L single-target')
pheatmap(cluster_target_cor,cluster_rows = F, cluster_cols=F, gaps_row = c(3,5,6),
         gaps_col=c(7,21), display_numbers=T)
  
  
  
# 38群投射组相似度
barcode_data <- read.csv('F:/1.课题/1.神经环路/2.实验汇总/3.barcode聚类分析/outfile/1.barcode_norm.csv',row.names = 1)
assay1 <- t(barcode_data)
assay2 <- assay1
barcode_data$Cluster <- Exlabel_seuratobject@active.ident[match(rownames(barcode_data),names(Exlabel_seuratobject@active.ident))]

new_colData = data.frame(
  study_id = rep(c('assay1', 'assay2'), c(ncol(assay1), ncol(assay2))),
  cell_type = c(paste('assay1',as.character(barcode_data$Cluster)), paste('assay2',as.character(barcode_data$Cluster)))
)

colnames(assay1) <- paste(rep('assay1',ncol(assay1)),colnames(assay1),sep = '_')
colnames(assay2) <- paste(rep('assay2',ncol(assay2)),colnames(assay2),sep = '_')
pancreas <- SingleCellExperiment(
  Matrix(cbind(assay1, assay2), sparse = TRUE),
  colData = new_colData
)
dim(pancreas)
celltype_NV = MetaNeighborUS(var_genes = rownames(assay1),
                             dat = pancreas,
                             study_id = pancreas$study_id,
                             cell_type = pancreas$cell_type,
                             fast_version = TRUE)
cluster_barcode_cor <- celltype_NV[1:38,1:38]
colnames(cluster_barcode_cor) <- levels(Exlabel_seuratobject)
rownames(cluster_barcode_cor) <- levels(Exlabel_seuratobject)
breaks <- seq(0.5,1,0.01)
cluster_barcode_cor <- cluster_barcode_cor[1:31,1:31]
pheatmap(cluster_barcode_cor,cluster_rows = F, cluster_cols=F, gaps_row=c(7,21,28),
         gaps_col=c(7,21,28), color = colorRampPalette(c("white","#1F77B4FF"))(length(breaks)),
         legend_breaks = seq(0.5,1,0.1),breaks = breaks,main = 'Projectome similarity',
         fontsize_row=10,fontsize_col=10,fontsize=20)
write.csv(cluster_barcode_cor,file = 'outputfile/10.投射组相似度.csv')

# 转录组与投射组相似度
Transcriptome_sim <- read.csv('outputfile/10.转录组相似度.csv',row.names = 1)
colnames(Transcriptome_sim) <- rownames(Transcriptome_sim)
Transcriptome_sim <- Bior_Dim2to1(Transcriptome_sim)
Projectome_sim <- read.csv('outputfile/10.投射组相似度.csv',row.names = 1)
colnames(Projectome_sim) <- rownames(Projectome_sim)
Projectome_sim <- Bior_Dim2to1(Projectome_sim)
df_dimilarity <- matrix(nrow = nrow(Transcriptome_sim)*ncol(Transcriptome_sim), ncol = 2)
colnames(df_dimilarity) <- c('Transcriptome similarity', 'Projectome similarity')
df_dimilarity[,1] <- Transcriptome_sim$value
df_dimilarity[,2] <- Projectome_sim$value
df_dimilarity <- as.data.frame(df_dimilarity)

library(ggpubr)
cols <- densCols(df_dimilarity,colramp=colorRampPalette(c("Darkblue","blue","cyan","green","yellow","orange","red")),nbin=100)
ggplot(mapping = aes(x=df_dimilarity[,1], y=df_dimilarity[,2])) +
  geom_point(size=2,color=cols) +
  #geom_smooth(method = "lm", formula = y~x, color = "#756bb1", fill = "#cbc9e2")+
  theme_bw()+
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
        text=element_text(size=20))+
  labs(x='Transcriptome similarity', y='Projectome similarity') +
  stat_cor(size=5) +
  scale_y_continuous(limits=c(0,1)) +
  scale_x_continuous(limits=c(0,1))










