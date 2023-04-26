---
title: Monocle：An analysis toolkit for single-cell RNA-seq
date: 2022-12-04 09:51:09
permalink: /pages/b62f01/
categories: 
  - 生信学习
tags: 
  - 生信工具
---


<!-- more -->

## 作者介绍

| Cole Trapnell |
|:-------------:|
| <img src="https://www.gs.washington.edu/faculty/images/trapnell2.jpg" width="200"/> |
| University of Washington |
| <coletrap@uw.edu> |


## Monocle 3 介绍

Monocle 3 是一个用于分析单细胞数据的 R 工具包，可以完成以下三种主要类型的分析：
* **Clustering, classifying, and counting cells.** 单细胞聚类，识别不同的细胞亚型。
* **Constructing single-cell trajectories.** 拟时序分析。
* **Differential expression analysis.** 差异表达分析。

Monocle 发表的相关文献:
- [Cole Trapnell et al., Nat Biotechnol 2014](https://doi.org/10.1038/nbt.2859) [Monocle 1]
- [Qiu et al., Nat Methods 2017](https://doi.org/10.1038/nmeth.4150) [Monocle 2]
- [Cao et al., Nature 2019](https://doi.org/10.1038/s41586-019-0969-x) [Monocle 3]

GitHub: <https://github.com/cole-trapnell-lab/monocle3>  
官方文档: <http://cole-trapnell-lab.github.io/monocle3/>  



## Monocle 3 的主要更新

* 处理的细胞数增加很多（millions of cells）
* 针对发育生物学领域，做了一些重大改进：
  - 发育轨迹的研究流程优化
  - 支持UMAP推断发育轨迹
  - 支持具有多个 roots 的轨迹
  - 新增学习具有循环或收敛点的轨迹的方法
  - 新增自动划分细胞以学习不相交或平行轨迹的算法，该算法采用了 ["approximate graph abstraction"](https://www.biorxiv.org/content/early/2017/10/25/208819) 的思想
  - 更新了具有轨迹依赖性表达基因的统计测试，取代了旧的 `differentialGeneTest()` 和 `BEAM()` 函数。
  - 新增将 query data 投影到 reference 上的功能。
  - 新增将注释从 reference 转移到 query data 上的功能。
  - 新增保存和加载 Monocle objects 和 transformation models。
  - 新增 fit_models 的混合负二项分布。
  - 新增用于可视化轨迹和基因表达的 3D 界面。


## 安装 Monocle 3

安装 Bioconductor：
``` R
if (!requireNamespace("BiocManager", quietly = TRUE))
install.packages("BiocManager")
BiocManager::install()
```

安装 Bioconductor dependencies：
``` R
BiocManager::install(c('BiocGenerics', 'DelayedArray', 'DelayedMatrixStats',
                       'limma', 'lme4', 'S4Vectors', 'SingleCellExperiment',
                       'SummarizedExperiment', 'batchelor', 'HDF5Array',
                       'terra', 'ggrastr'))
```

安装 monocle3：
``` R
install.packages("devtools")
devtools::install_github('cole-trapnell-lab/monocle3')
```

测试 monocle3 是否安装成功：
``` R
library(monocle3)
```


## Monocle3 Tutorial --- Clustering and classifying your cells

官网教程：<https://cole-trapnell-lab.github.io/monocle3/docs/clustering/>

中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/008.Monocle3/Clustering%20and%20classifying%20your%20cells.nb.html>


## Monocle3 Tutorial --- Constructing single-cell trajectories

官网教程：<https://cole-trapnell-lab.github.io/monocle3/docs/trajectories/>

中文教程：<http://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/008.Monocle3/Constructing%20single-cell%20trajectories.nb.html>