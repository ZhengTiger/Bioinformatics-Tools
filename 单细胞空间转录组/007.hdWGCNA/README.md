---
title: hdWGCNA：high dimensional WGCNA
date: 2023-05-04 08:25:04
permalink: /pages/649303/
categories:
  - 生信学习
  - 生信工具 - 单细胞空间组
tags:
  - 生信工具
---


::: note 相关阅读
1. [文献阅读 --- Single-nucleus chromatin accessibility and transcriptomic characterization of Alzheimer's disease](https://tigerz.online/pages/25c02b/)
:::

<!-- more -->

## 作者介绍

| Samuel Morabito | Vivek Swarup |
|:-------------:|:-------------:|
| <img src="https://smorabit.github.io/assets/img/sam_2022.jpg" width="200"/> | <img src="https://ccbs.uci.edu/wp-content/uploads/sites/3/2019/09/Swarup_jpeg-130x160.jpeg" width="200"/> |
| University of California Irvine(UCI) | University of California Irvine(UCI) |
| <smorabit@uci.edu> | <vswarup@uci.edu> |



## hdWGCNA 介绍

hdWGCNA 是一个 R 包，用于在 scRNA-seq 或空间转录组学等高维转录组学数据中执行`加权基因共表达网络分析(WGCNA)`。hdWGCNA 是高度模块化的，可以构建跨多尺度细胞和空间层次结构的共表达网络。hdWGNCA 识别出相互关联的基因的稳健模块，并通过各种生物学知识源为这些模块提供解释。hdWGCNA 需要格式化为 [Seurat](https://satijalab.org/seurat/index.html) 对象的数据，这是单细胞数据最普遍的格式之一。

WGCNA 发表的相关文献:

- [Morabito et al. bioRxiv 2022](https://doi.org/10.1101/2022.09.22.509094)
- [Morabito & Miyoshi et al. Nature Genetics 2021](https://doi.org/10.1038/s41588-021-00894-z)

GitHub: <https://github.com/smorabit/hdWGCNA/>  
官方文档：<https://smorabit.github.io/hdWGCNA/>  



## Installation

建议为 hdWGCNA 创建一个 R conda 环境

``` shell
# create new conda environment for R
conda create -n hdWGCNA -c conda-forge r-base r-essentials

# activate conda environment
conda activate hdWGCNA
```

接下来，打开 R 并安装所需的依赖项：

``` R
# install BiocManager
install.packages("BiocManager")

# install Bioconductor core packages
BiocManager::install()

# install additional packages:
install.packages(c("Seurat", "WGCNA", "igraph", "devtools"))
```

然后，使用 devtools 安装 hdWGCNA 软件包

``` R
devtools::install_github('smorabit/hdWGCNA', ref='dev')
```



## hdWGCNA Vignettes

### 1 Co-expression network analysis

这些教程涵盖了在单细胞转录组学数据中执行共表达网络分析的要点，以及可视化关键结果。

#### 1.1 hdWGCNA in single-cell data

本教程涵盖了使用 hdWGCNA 在单细胞转录组学数据中构建共表达网络的基本功能。\
官网教程：<https://smorabit.github.io/hdWGCNA/articles/basic_tutorial.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/007.hdWGCNA/hdWGCNA%20in%20single-cell%20data.nb.html>
::: center
![1.1](https://smorabit.github.io/hdWGCNA/articles/figures/basic_tutorial/Zhou_featureplot_hMEs_selected_wide.png)
:::

#### 1.2 hdWGCNA in spatial transcriptomics data

本教程涵盖了使用 hdWGCNA 在空间转录组学数据中构建共表达网络的基本功能。\
官网教程：<https://smorabit.github.io/hdWGCNA/articles/ST_basics.html>
::: center
![1.2](https://smorabit.github.io/hdWGCNA/articles/figures/ST_basics/spatial_clusters.png)
:::

#### 1.3 Isoform co-expression network analysis with PacBio MAS-Seq

本教程介绍了使用 hdWGCNA 和 PacBio-MAS-Seq 数据进行同源异构体共表达网络分析的基本知识。\
官网教程：<https://smorabit.github.io/hdWGCNA/articles/isoform_pbmcs.html>

#### 1.4 Network visualization

本教程重点介绍了几种可视化 hdWGCNA 共表达网络的方法。\
官网教程：<https://smorabit.github.io/hdWGCNA/articles/network_visualizations.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/007.hdWGCNA/Network%20Visualization.nb.html>
::: center
![1.4](https://smorabit.github.io/hdWGCNA/articles/figures/network_vis/hubgene_umap_igraph.png)
:::


### 2 Biological context for co-expression modules

这些教程将为我们的共表达模块提供进一步的生物学背景，有可能揭示这些模块所涉及的实验条件和生物学过程。

#### 2.1 Differential module eigengene (DME) analysis

本教程介绍了如何比较实验组之间的 module eigengenes。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/differential_MEs.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/007.hdWGCNA/Differential%20module%20eigengene%20(DME)%20analysis.nb.html>
::: center
![2.1](https://smorabit.github.io/hdWGCNA/articles/figures/DMEs/test_DME_volcano.png)
:::

#### 2.2 Module trait correlation

这篇教程介绍了如何使用 module eigengenes 或 module expression scores 来关联连续变量和分类变量，揭示哪些模块与不同的实验条件或协变量相关。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/module_trait_correlation.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/007.hdWGCNA/Module%20Trait%20Correlation.nb.html>
::: center
![2.2](https://smorabit.github.io/hdWGCNA/articles/figures/mt_correlation/ME_Trait_correlation_fdr.png)
:::

#### 2.3 Enrichment analysis

本教程展示了如何使用 Enrichr 将每个共表达模块的基因成员与策划的基因列表进行比较，从而指向共表达模块的生物学功能。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/enrichment_analysis.html> \
中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/007.hdWGCNA/Enrichment%20analysis.nb.html>
::: center
![2.3](https://smorabit.github.io/hdWGCNA/articles/figures/enrichment/GO_dotplot.png)
:::



### 3 Exploring modules in external datasets

#### 3.1 Projecting modules to new datasets

本教程介绍如何将共表达模块从 reference 投射到 query 数据集。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/projecting_modules.html>
::: center
![3.1](https://smorabit.github.io/hdWGCNA/articles/figures/projection/compare_umaps.png)
:::

#### 3.2 Module preservation and reproducibility

本教程介绍了使用外部数据集评估共表达网络保守性和可重复性的统计方法。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/module_preservation.html>
::: center
![3.2](https://smorabit.github.io/hdWGCNA/articles/figures/projection/module_preservation_summary.png)
:::

#### 3.3 Cross-species and cross-modality analysis

本教程介绍了如何在 reference 和 query 之间数据模态或物种不匹配的特殊情况下，将共表达模块从 reference 映射到 query 数据集。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/projecting_modules_cross.html>
::: center
![3.3](https://smorabit.github.io/hdWGCNA/articles/figures/projection/atac_umap_covplot.png)
:::



### 4 Advanced topics

#### 4.1 Consensus network analysis

在本教程中，我们使用 hdWGCNA 执行一致性共表达网络分析。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/consensus_wgcna.html>


#### 4.2 Co-expression module dynamics with pseudotime

本教程介绍了在具有拟时序信息的数据集中的共表达网络分析。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/pseudotime.html>


#### 4.3 Motif Analysis

官网教程：<https://smorabit.github.io/hdWGCNA/articles/motif_analysis.html>


#### 4.4 Alternative metacell algorithms

在本教程中，我们演示了一个高级分析，展示了如何使用替代 metacell 聚合算法进行共表达网络分析。



### 5 Other

#### 5.1 Module customization

本教程介绍如何更改 hdWGCNA 模块的默认名称和颜色。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/customization.html>
::: center
![5.1](https://smorabit.github.io/hdWGCNA/articles/figures/customization/featureplot.png)
:::


#### 5.2 Using SCTransform normalized data

本教程介绍如何在 hdWGCNA 中使用 SCTransform normalized 数据。 \
官网教程：<https://smorabit.github.io/hdWGCNA/articles/sctransform.html>
::: center
![5.2](https://smorabit.github.io/hdWGCNA/articles/figures/sctransform/dendro_SCT_compare.png)
:::


