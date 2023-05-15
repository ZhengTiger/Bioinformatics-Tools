[TOC]


# nnU-Net dataset format

将数据导入 nnU-Net 的唯一方法是以特定格式存储数据。由于 nnU-Net 起源于 [Medical Segmentation Decathlon](http://medicaldecathlon.com/) (MSD)，其数据集深受启发，但此后与 MSD 中使用的格式有所不同(see also [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format.md#how-to-use-decathlon-datasets))。

数据集由三个部分组成：原始图像、相应的分割图和指定一些元数据的 dataset.json 文件。

如果您正在从 nnU-Net v1 迁移，请[阅读此内容](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format.md#how-to-use-nnu-net-v1-tasks)以转换您现有的任务。


## What do training cases look like?

每个训练案例都与一个标识符（identifier，a unique name for that case）相关联。nnU-Net 使用此标识符将图像与正确的分割连接起来。

训练案例由图像及其相应的分割组成。

**Images** 是复数，因为 nnU-Net 支持任意多个输入通道。为了尽可能灵活，nnU-Net 要求每个输入通道都必须存储在单独的图像中（唯一的例外是 RGB 自然图像）。因此，这些图像可以是 T1 和 T2  MRI（或任何其他你想要的图像）。不同的输入通道必须具有相同的几何形状（相同的形状、间距等），并且必须共同注册（如果适用）。nnU-Net 通过文件结尾的四位数字来标识输入通道：这是文件名的最后部分。因此，图像文件必须遵循以下命名约定： {CASE_IDENTIFIER}_{XXXX}.{FILE_ENDING}。在此，XXXX 是四位模态/通道标识符（对于每个模态/通道应该是唯一的，例如，T1 为“0000”，T2 MRI 为“0001”等），而 FILE_ENDING 是图像格式使用的文件扩展名（.png，.nii.gz 等）。具体示例请参见下文。数据集的 JSON 文件将通道名称与“channel_names”键中的通道标识符连接起来（有关详细信息，请参见下文）。

旁注：通常，每个通道/模态都需要存储在单独的文件中，并使用 XXXX 通道标识符进行访问。自然图像 (RGB; .png) 除外，其中三个颜色通道都可以存储在一个文件中（例如[道路分割数据集](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion/Dataset120_RoadSegmentation.py)）。

**Segmentations** 必须与相应的图像具有相同的几何形状（相同的形状等）。分割是整数映射，每个值表示一个语义类。背景必须为 0。如果没有背景，则不要将标签 0 用于其他目的！你的语义类的整数值必须是连续的（0、1、2、3、...）。当然，并不是每个训练样本中都必须出现所有标签。Segmentations 保存为 {CASE_IDENTIFER}.{FILE_ENDING}。

在训练案例中，所有图像几何形状（输入通道、相应的分割）必须匹配。在训练案例之间，它们当然可以不同。nnU-Net 负责这个。

Important: 输入通道必须一致！具体来说，所有图像都需要相同顺序的相同输入通道，并且每次都必须存在所有输入通道。推理也是如此！


## Supported file formats

nnU-Net 期望 images 和 segmentations 具有相同的文件格式！这些也将用于推断。因此，现在无法在 .png 上进行训练，然后在 .jpg 上运行推断。

nnU-Net V2 的一个重大变化是支持多种输入文件类型。不再需要将所有内容转换为 .nii.gz 了！这是通过通过 BaseReaderWriter 将 images + segmentations 的输入和输出进行抽象化实现的。nnU-Net 带有广泛的读取器和编写器集合，你甚至可以添加自己的内容以支持你的数据格式！See [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/imageio/readme.md)。

作为一个不错的奖励，nnU-Net 现在还原生支持 2D 输入图像，你不再需要费力地转换为伪 3D Niftis了。恶心。那真是太恶心了。

请注意，内部（用于存储和访问预处理图像）nnU-Net 将使用其自己的文件格式，而不管原始数据是以什么方式提供的！这是出于性能原因。

默认情况下，支持以下文件格式：

- NaturalImage2DIO：.png、.bmp、.tif
- NibabelIO：.nii.gz、.nrrd、.mha
- NibabelIOWithReorient：.nii.gz、.nrrd、.mha。此读取器将重新定向图像到 RAS！
- SimpleITKIO：.nii.gz、.nrrd、.mha
- Tiff3DIO：.tif、.tiff。3D tif 图像！由于TIF没有标准化存储间距信息的方式，因此 nnU-Net 希望每个 TIF 文件都附带一个相同命名的 .json 文件，其中包含三个数字（无单位，无逗号。只用空格分隔），分别为每个维度提供一个。

文件扩展名列表不是详尽无遗的，它取决于后端支持的内容。例如，nibabel 和 SimpleITK 支持的不仅仅是这里给出的三个。这里给出的文件扩展名仅是我们测试过的！

重要提示：nnU-Net 只能与使用无损（或无）压缩的文件格式一起使用！因为文件格式是为整个数据集定义的（而不是分别为图像和分割定义的，这可能是未来的任务），我们必须确保没有压缩伪影破坏分割图。所以不要使用 .jpg 等压缩格式！


## Dataset folder structure

数据集必须位于 `nnUNet_raw` 文件夹中（您可以在安装 nnU-Net 时定义它，或在每次运行 nnU-Net 命令时进行导出/设置！）。每个 segmentation 数据集都存储为单独的 'Dataset'。数据集与 dataset ID（三位整数）和 dataset name（您可以自由选择）相关联：例如，Dataset005_Prostate 其中“Prostate”是 dataset name，dataset ID 为 5。数据集存储在 `nnUNet_raw` 文件夹中，如下所示：

    nnUNet_raw/
    ├── Dataset001_BrainTumour
    ├── Dataset002_Heart
    ├── Dataset003_Liver
    ├── Dataset004_Hippocampus
    ├── Dataset005_Prostate
    ├── ...

在每个数据集文件夹中，应具有以下结构：

    Dataset001_BrainTumour/
    ├── dataset.json
    ├── imagesTr
    ├── imagesTs  # optional
    └── labelsTr


在添加自定义数据集时，请查看 [dataset_conversion](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion) 文件夹，并选择尚未被使用的 ID。 ID 001-010 用于医学分割十项全能赛。

- imagesTr 包含属于 training cases 的图像。nnU-Net 将使用这些数据执行管道配置、交叉验证的训练以及找到后处理和最佳集合。
- imagesTs（可选）包含属于 test cases 的图像。nnU-Net 不使用它们！这只是您存储这些图像的一个方便的位置。是医学分割十项全能赛文件夹结构的遗留物。
- labelsTr 包含带有 training cases 的 ground truth segmentation maps。
- dataset.json 包含数据集的 metadata。

上述方案导致以下文件夹结构。以 MSD 的第一个数据集 BrainTumour 为例。该数据集有四个输入通道：FLAIR（0000），T1w（0001），T1gd（0002）和 T2w（0003）。请注意，imagesTs 文件夹是可选的，不一定要存在。

    nnUNet_raw/Dataset001_BrainTumour/
    ├── dataset.json
    ├── imagesTr
    │   ├── BRATS_001_0000.nii.gz
    │   ├── BRATS_001_0001.nii.gz
    │   ├── BRATS_001_0002.nii.gz
    │   ├── BRATS_001_0003.nii.gz
    │   ├── BRATS_002_0000.nii.gz
    │   ├── BRATS_002_0001.nii.gz
    │   ├── BRATS_002_0002.nii.gz
    │   ├── BRATS_002_0003.nii.gz
    │   ├── ...
    ├── imagesTs
    │   ├── BRATS_485_0000.nii.gz
    │   ├── BRATS_485_0001.nii.gz
    │   ├── BRATS_485_0002.nii.gz
    │   ├── BRATS_485_0003.nii.gz
    │   ├── BRATS_486_0000.nii.gz
    │   ├── BRATS_486_0001.nii.gz
    │   ├── BRATS_486_0002.nii.gz
    │   ├── BRATS_486_0003.nii.gz
    │   ├── ...
    └── labelsTr
        ├── BRATS_001.nii.gz
        ├── BRATS_002.nii.gz
        ├── ...

这是 MSD 的第二个数据集的另一个示例，它只有一个输入通道：

    nnUNet_raw/Dataset002_Heart/
    ├── dataset.json
    ├── imagesTr
    │   ├── la_003_0000.nii.gz
    │   ├── la_004_0000.nii.gz
    │   ├── ...
    ├── imagesTs
    │   ├── la_001_0000.nii.gz
    │   ├── la_002_0000.nii.gz
    │   ├── ...
    └── labelsTr
        ├── la_003.nii.gz
        ├── la_004.nii.gz
        ├── ...

请记住：对于每个 training case，所有图像都必须具有相同的几何形状，以确保它们的像素阵列对齐。还要确保您的所有数据都是共同注册的！

See also [dataset format inference](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format_inference.md)!!


## dataset.json

dataset.json 包含 nnU-Net 训练所需的 metadata。自版本 1 以来，我们大大减少了必填字段的数量！

以下是来自 MSD 的 Dataset005_Prostate 示例中的 dataset.json 应该是什么样子：

    { 
     "channel_names": {  # formerly modalities
       "0": "T2", 
       "1": "ADC"
     }, 
     "labels": {  # THIS IS DIFFERENT NOW!
       "background": 0,
       "PZ": 1,
       "TZ": 2
     }, 
     "numTraining": 32, 
     "file_ending": ".nii.gz"
     "overwrite_image_reader_writer": "SimpleITKIO"  # optional! If not provided nnU-Net will automatically determine the ReaderWriter
     }

channel_names 决定了 nnU-Net 使用的归一化方式。如果一个通道标记为“CT”，则将使用基于前景像素强度的全局归一化。如果是其他内容，则将使用每个通道的 z-score 标准化。有关更多详细信息，请参阅我们[论文](https://www.nature.com/articles/s41592-020-01008-z)中的方法部分。nnU-Net v2 引入了几种可供选择的归一化方案，并允许您定义自己的方案，请参见[此处](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/explanation_normalization.md)以获取更多信息。

与 nnU-Net v1 相比的重要更改：

- “modality”现在称为“channel_names”，以消除对医学图像的强烈偏见；
- 标签的结构不同（名称->整数，而不是整数->名称）。这是为了支持基于区域的训练；
- 添加了“file_ending”以支持不同的输入文件类型；
- “overwrite_image_reader_writer”是可选的！可用于指定应与此数据集一起使用的特定（自定义）ReaderWriter类。如果未提供，nnU-Net将自动确定ReaderWriter；
- “regions_class_order”仅用于基于区域的训练。

有一个实用程序可以自动生成 dataset.json。You can find it [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion/generate_dataset_json.py)。请查看我们在 [dataset_conversion](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion) 中的示例以了解如何使用它。并阅读其文档！


## How to use nnU-Net v1 Tasks
如果您从旧的 nnU-Net 迁移，请使用 `nnUNetv2_convert_old_nnUNet_dataset` 转换您现有的数据集！

迁移 nnU-Net v1 任务的示例：

```bash
nnUNetv2_convert_old_nnUNet_dataset /media/isensee/raw_data/nnUNet_raw_data_base/nnUNet_raw_data/Task027_ACDC Dataset027_ACDC 
```

使用 `nnUNetv2_convert_old_nnUNet_dataset -h` 获取详细的使用说明。


## How to use decathlon datasets

See [convert_msd_dataset.md](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/convert_msd_dataset.md)


## How to use 2D data with nnU-Net
现在原生支持 2D（耶！）。See [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format.md#supported-file-formats) as well as the example dataset in this [script](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion/Dataset120_RoadSegmentation.py)。


## How to update an existing dataset

更新数据集时，最佳做法是删除 `nnUNet_preprocessed/DatasetXXX_NAME` 中的预处理数据，以确保重新开始。然后替换 `nnUNet_raw` 中的数据并重新运行 `nnUNetv2_plan_and_preprocess`。或者，也可以删除旧训练的结果。



# Example dataset conversion scripts

在 `dataset_conversion` 文件夹中 (see [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/nnunetv2/dataset_conversion))，有多个示例脚本可将数据集转换为 nnU-Net 格式。这些脚本不能直接运行（您需要打开它们并更改一些路径），但它们是您学习如何将自己的数据集转换为 nnU-Net 格式的绝佳示例。只需选择与您最接近的数据集作为起点。数据集转换脚本列表会不断更新。如果您发现一些公开数据集缺失，请随时打开 PR 添加！
