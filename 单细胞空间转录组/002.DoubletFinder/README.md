---
title: DoubletFinder：R package for detecting doublets in single-cell RNA sequencing data
categories: 
  - 生信学习
tags: 
  - 生信工具
permalink: /pages/a35823/
date: 2022-11-19 09:25:14
---

GitHub: <https://github.com/chris-mcginnis-ucsf/DoubletFinder>  
DOI: <https://doi.org/10.1016/j.cels.2019.03.003>  
Cite: McGinnis CS, Murrow LM, Gartner ZJ. DoubletFinder: Doublet Detection in Single-Cell RNA Sequencing Data Using Artificial Nearest Neighbors. *Cell Syst* 2019 Apr 24;8(4):329-337.e4.

<!-- more -->

## 作者介绍

| Zev Gartner |
|:-------------:|
| <img src="https://pharmacy.ucsf.edu/sites/pharmacy.ucsf.edu/files/styles/pharmacy_square_0_75x/public/person/photo/RS4183_Zev%20Gartner%2010-hpr.jpg?itok=H-3BF9Ki&timestamp=1528749447" width="200"/> |
| University of California, San Francisco |
| <zev.gartner@ucsf.edu> |

## DoubletFinder 原理
DoubletFinder 可以分为以下几个步骤:
![DoubletFinderOverview](https://cdn.staticaly.com/gh/zhenghu159/picx-images-hosting@master/03-生信学习/01-生信工具-单细胞空间组/02-DoubletFinder/1.DoubletFinderOverview.7eo5pfb5ssw0.webp)
* **Original Data:** 完成 Seurat 标准的聚类程序后，可能会存在一些中间状态的细胞 (图中？标注的蓝色和橙色细胞)，这些中间状态的细胞很可能就是双细胞。
* **Simulate Doublets:** DoubletFinder 会通过平均随机细胞对的基因表达谱，从现有的 scRNA-seq 数据中以确定的比例 (pN) 生成 artificial doublets (红色)。
* **PCA:** DoubletFinder 将生成的人工双细胞合并到原始数据中进行 PCA 降维。
* **Compute pANN:** DoubletFinder 检测 PC 空间中每个真实细胞的邻域大小 (pK) 内的邻近细胞 ，计算这些邻近细胞中人工双细胞的比率 (pANN)。
* **Threshold pANN:** DoubletFinder 将 pANN 值最高的前 n 个真实细胞预测为双细胞，n 值根据经验双细胞比率 (nExp) 参数指定。 
* **Doublets Removed:** 在 Seurat 对象中将 DoubletFinder 标记的双细胞去除。


## DoubletFinder 使用
DoubletFinder 使用以下参数:
* **seu:** 这是一个完整处理过的 Seurat 对象 (即，在 NormalizeData，FindVariableGenes，ScaleData，RunPCA，RunTSNE 全部运行之后)。
* **PCs:** 具有统计意义的主成分的数量，默认 PCs = 1:10 。
* **pN:** 定义生成人工双细胞的数目比例，默认 pN = 0.25，DoubletFinder 的性能受 pN 的影响较小。
* **pK:** 用于计算 pANN (proportion of artificial nearest neighbors) 的 PC 邻域大小。在数据分布中，BC (bimodality coefficient，双峰性系数) 用来衡量与单峰分布的偏离程度。DoubletFinder 通过 find.pK() 函数来计算 BC 值，BC 值最大时为最优 pK 值。
* **nExp:** 根据经验定义的双细胞的数目，参考 10X 平台的双细胞率，每 1000 个细胞双细胞比率增加 0.8% 。

使用示例：
``` R
library(Seurat)
library(dplyr)
library(DoubletFinder)

# 以Seurat官网的pbmc3k数据为例
seuratobject <- readRDS("pbmc3k_final.rds")
ncol(seuratobject) # 细胞数 2638
DimPlot(seuratobject, reduction='umap')

# pK Identification (no ground-truth) ------------------------------------------
sweep.res.list <- paramSweep_v3(seuratobject, PCs = 1:10, sct = FALSE)
sweep.stats <- summarizeSweep(sweep.res.list, GT = FALSE)
bcmvn <- find.pK(sweep.stats)
pK <- bcmvn$pK[which.max(bcmvn$BCmetric)] %>% as.character() %>% as.numeric()

# Homotypic Doublet Proportion Estimate ----------------------------------------
DoubletRate <- ncol(seuratobject)/1000*0.008  # DoubletRate为双细胞比率，参考10X平台的双细胞率，每1000个细胞双细胞比率增加0.8%
homotypic.prop <- modelHomotypic(seuratobject$seurat_clusters)
nExp_poi <- round(DoubletRate*nrow(seuratobject@meta.data))
nExp_poi.adj <- round(nExp_poi*(1-homotypic.prop))

## Run DoubletFinder with varying classification stringencies ------------------
seuratobject <- doubletFinder_v3(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi, reuse.pANN = FALSE, sct = FALSE)
seuratobject <- doubletFinder_v3(seuratobject, PCs = 1:10, pN = 0.25, pK = pK, nExp = nExp_poi.adj, reuse.pANN = FALSE, sct = FALSE)

# DoubletFinder结果
seuratobject@meta.data[,"DF_hi.lo"] <- seuratobject$DF.classifications_0.25_0.03_56
seuratobject@meta.data$DF_hi.lo[which(seuratobject@meta.data$DF_hi.lo == "Doublet" & 
                                      seuratobject@meta.data$DF.classifications_0.25_0.03_46 == "Singlet")] <- "Doublet-Low Confidience"
seuratobject@meta.data$DF_hi.lo[which(seuratobject@meta.data$DF_hi.lo == "Doublet" & 
                                      seuratobject@meta.data$DF.classifications_0.25_0.03_46 == "Doublet")] <- "Doublet-High Confidience"
table(seuratobject@meta.data$DF_hi.lo) # high:46, low:10, singlet:2582
DimPlot(seuratobject, group.by ="DF_hi.lo", cols =c("black","red","gold"),reduction = 'umap')
seuratobject <- subset(seuratobject, cells = rownames(seuratobject@meta.data)[which(seuratobject@meta.data$DF_hi.lo == 'Singlet')])
ncol(seuratobject) # 细胞数 2582，去除了56个双细胞
```
DoubletFinder结果:
![DoubletFinder](https://cdn.staticaly.com/gh/zhenghu159/picx-images-hosting@master/03-生信学习/01-生信工具-单细胞空间组/02-DoubletFinder/2.DoubletFinder_result.46lg08sivyg0.webp)


