# Seurat Tutorial

## 作者介绍

**通讯作者：**

<img src="https://as.nyu.edu/content/dam/nyu-as/faculty/images/satija-rahul-photo.jpg" width="200"/>\
**Rahul Satija (Oxford University)** \
<rsatija@nygenome.org>


## Seurat 介绍

Seurat 是一个 R 包，专为 single-cell RNA-seq 数据的质控、分析和探索而设计。Seurat 旨在使用户能够从单细胞转录组测量中识别和解释异质性来源，并整合不同类型的单细胞数据。

Seurat 的所有方法都强调清晰、有吸引力和可解释的可视化效果，旨在方便干实验室和湿实验室研究人员使用。

Seurat 发表的相关文献:
- [Hao*, Hao*, et al., Cell 2021](https://doi.org/10.1016/j.cell.2021.04.048) [Seurat V4]
- [Stuart*, Butler*, et al., Cell 2019](https://www.cell.com/cell/fulltext/S0092-8674(19)30559-8) [Seurat V3]
- [Butler* et al., Nat Biotechnol 2018](https://doi.org/10.1038/nbt.4096) [Seurat V2]
- [Satija*, Farrell*, et al., Nat Biotechnol 2015](https://doi.org/10.1038/nbt.3192) [Seurat V1]


## Seurat Tutorial

### 1 Introductory Vignettes

对于 Seurat 的新用户，建议从引导式浏览 10X Genomics 公开提供的 2,700 个外周血单核细胞 (PBMC) 数据集开始。本教程实现了标准无监督聚类工作流的主要组成部分，包括 QC 和数据过滤、高变异基因的计算、降维、基于图的聚类以及聚类标记的识别。

Seurat 为有兴趣分析多模式单细胞数据集（例如来自 CITE-seq 或 10x multiome 套件）或空间数据集（例如 10x Visium 或 Vizgen MERFISH）的用户提供额外教程。

#### 1.1 Seurat - Guided Clustering Tutorial
Seurat 的基本概述，包括对常见分析工作流程的介绍。 \
官网教程：<https://satijalab.org/seurat/articles/pbmc3k_tutorial.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/learn/blob/main/R/11.Seurat/Seurat%20-%20Guided%20Clustering%20Tutorial.nb.html>



### 2 Data Integration

最近，Seurat 开发了用于对跨不同条件、技术或物种的单细胞数据集进行整合分析的计算方法。教程中提供了一个指导性的演练，用于整合和比较在不同刺激条件下生成的 PBMC 数据集。教程中演示如何利用带注释的 scRNA-seq reference 来映射和标记 query cells，以及如何有效地整合大型数据集。

#### 2.1 Introduction to scRNA-seq integration
介绍如何整合 scRNA-seq 数据集以识别和比较实验中的共享细胞类型。\
官网教程：<https://satijalab.org/seurat/articles/integration_introduction.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/learn/blob/main/R/11.Seurat/Introduction%20to%20scRNA-seq%20integration.nb.html>

#### 2.2 Mapping and annotating query datasets
学习如何将 query scRNA-seq dataset 映射到 reference dataset 上，以便自动化注释和可视化 query cells。\
官网教程：<https://satijalab.org/seurat/articles/integration_mapping.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/learn/blob/main/R/11.Seurat/Mapping%20and%20annotating%20query%20datasets.nb.html>

#### 2.3 Fast integration using reciprocal PCA (RPCA)
使用 reciprocal PCA (RPCA) 工作流程识别 anchors，该工作流程执行更快、更保守的整合。 \
官网教程：<https://satijalab.org/seurat/articles/integration_rpca.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/learn/blob/main/R/11.Seurat/Fast%20integration%20using%20reciprocal%20PCA%20(RPCA).nb.html>

#### 2.4 Tips for integrating large datasets
整合非常大的 scRNA-seq 数据集（包括 >200,000 个细胞）的技巧和示例。 \
官网教程：<https://satijalab.org/seurat/articles/integration_large_datasets.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/learn/blob/main/R/11.Seurat/Tips%20for%20integrating%20large%20datasets.nb.html>