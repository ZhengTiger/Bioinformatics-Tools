[TOC]


# Setting up Paths

nnU-Net 依靠环境变量来了解原始数据、预处理数据和训练模型权重的存储位置。要使用 nnU-Net 的全部功能，必须设置以下三个环境变量：

1. `nnUNet_raw`：这是放置原始数据集的地方。此文件夹将有一个子文件夹对应每个数据集名称 DatasetXXX_YYY，其中 XXX 是 3 位标识符（例如 001、002、043、999 等），YYY 是（唯一）数据集名称。数据集必须采用 nnU-Net 格式，请参见[此处](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format.md)。

    Example tree structure:
    ```
    nnUNet_raw/Dataset001_NAME1
    ├── dataset.json
    ├── imagesTr
    │   ├── ...
    ├── imagesTs
    │   ├── ...
    └── labelsTr
        ├── ...
    nnUNet_raw/Dataset002_NAME2
    ├── dataset.json
    ├── imagesTr
    │   ├── ...
    ├── imagesTs
    │   ├── ...
    └── labelsTr
        ├── ...
    ```

2. `nnUNet_preprocessed`: 这是将保存预处理数据的文件夹。训练期间也将从该文件夹中读取数据。重要的是，此文件夹位于具有低访问延迟和高吞吐量的驱动器上（例如 nvme SSD（PCIe gen 3 就足够了））。

3. `nnUNet_results`: 这指定了 nnU-Net 将保存模型权重的位置。如果下载了预训练模型，这就是保存它们的地方。


### How to set environment variables
See [here](set_environment_variables.md).