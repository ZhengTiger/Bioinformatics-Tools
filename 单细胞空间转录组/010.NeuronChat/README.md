---
title: NeuronChat：Inferring neuron-neuron communications from single-cell transcriptomics
date: 2023-04-26 20:22:25
permalink: /pages/7a726f/
categories:
  - 生信学习
  - 生信工具 - 单细胞空间组
tags:
  - 生信工具
---

::: note 相关阅读
1. [文献阅读 --- Inferring neuron-neuron communications from single-cell transcriptomics through NeuronChat](https://tigerz.online/pages/794f06/)
:::

<!-- more -->

## 作者介绍

| Qing Nie |
|:-------------:|
| <img src="https://faculty.sites.uci.edu/qnie/files/2016/04/QN2015.jpg" width="200"/> |
| University of California, Irvine |
| <qnie@uci.edu> |

## NeuronChat 介绍

NeuronChat 的目标是从单细胞转录组学或空间分辨转录组学数据中推断、可视化和分析神经特异性细胞间通信。

NeuronChat 发表的相关文献:
- [Zhao et al., Nat Commun 2023](https://doi.org/10.1038/s41467-023-36800-w) [NeuronChat]

GitHub: <https://github.com/Wei-BioMath/NeuronChat>



## NeuronChat 安装
您可以安装 NeuronChat 的开发版本，如下所示：
``` r
devtools::install_github("Wei-BioMath/NeuronChat")
```



## Usage & Tutorial

### Basic usage of NeuronChat

``` r
library(NeuronChat)
# creat NeuronChat object 
x <- createNeuronChat(normalized_count_mtx,DB='mouse',group.by = cell_group_vector) # use DB='human' for human data
# calculation of communication networks  
x <- run_NeuronChat(x,M=100)
# aggregating networks over interaction pairs
net_aggregated_x <- net_aggregation(x@net,method = 'weight')
# visualization
netVisual_circle_neuron(net_aggregated_x)
```

### Full tutorials

NeuronChat 的一套教程如下：

#### 1.推理、可视化和分析神经特异性通信网络

官网教程：<https://htmlpreview.github.io/?https://github.com/Wei-BioMath/NeuronChat/blob/main/vignettes/NeuronChat-Tutorial.html>  
中文教程：<https://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/010.NeuronChat/Inference%20visualization%20and%20analysis%20of%20neural-specific%20communication%20network.nb.html>

#### 2.空间数据集分析与空间约束通信网络计算

官网教程：<https://htmlpreview.github.io/?https://github.com/Wei-BioMath/NeuronChat/blob/main/vignettes/Spatial_analysis.html>

#### 3.更新 NeuronChat 交互数据库

官网教程：<https://htmlpreview.github.io/?https://github.com/Wei-BioMath/NeuronChat/blob/main/vignettes/Update_NeuronChat_database.html>

#### 4.NeuronChat predicting neural connectivity

中文教程：<https://htmlpreview.github.io/?https://github.com/zhenghu159/Bioinformatics-Tools/blob/main/%E5%8D%95%E7%BB%86%E8%83%9E%E7%A9%BA%E9%97%B4%E8%BD%AC%E5%BD%95%E7%BB%84/010.NeuronChat/NeuronChat%20predicting%20neural%20connectivity.nb.html>