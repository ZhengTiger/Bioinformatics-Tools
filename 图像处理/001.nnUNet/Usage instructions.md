[TOC]


## How to run nnU-Net on a new dataset

给定某个数据集，nnU-Net 会完全自动地配置一个与其属性匹配的完整分割流程。nnU-Net 涵盖整个流程，从预处理到模型配置、模型训练、后处理，一直到集成。运行 nnU-Net 之后，训练好的模型可以应用于测试案例进行推断。


### Dataset Format

nnU-Net 希望以结构化格式提供数据集。此格式受[医学分割十项全能](http://medicaldecathlon.com/)数据结构的启发。请阅读 this 以了解如何设置数据集以与 nnU-Net 兼容。

从版本 2 开始，我们支持多种图像文件格式（.nii.gz、.png、.tif 等）！阅读数据集格式文档以了解更多信息！

nnU-Net v1 的数据集可以通过运行 `nnUNetv2_convert_old_nnUNet_dataset INPUT_FOLDER OUTPUT_DATASET_NAME` 进行转换为 V2。请记住，v2 将数据集称为 DatasetXXX_Name（而不是Task），其中 XXX 是三位数字。请提供旧任务的路径，而不仅仅是任务名称。nnU-Net V2 不知道 v1 任务的位置！


### Experiment planning and preprocessing

给定一个新的数据集，nnU-Net 将提取一个 dataset fingerprint（一组数据集特定的属性，如图像大小、体素间距、强度信息等）。这些信息用于设计三个 U-Net 配置。每个管道都在其自己预处理的数据集版本上运行。

运行 fingerprint extraction, experiment planning, preprocessing 的最简单方法是使用：

```bash
nnUNetv2_plan_and_preprocess -d DATASET_ID --verify_dataset_integrity
```

其中 `DATASET_ID` 是数据集 ID（显而易见）。我们建议在首次运行此命令时使用 `--verify_dataset_integrity`。这将检查一些最常见的错误源！

您也可以通过给出 `-d 1 2 3 [...]` 来处理多个数据集。如果您已经知道需要哪个 U-Net 配置，您还可以使用 `-c 3d_fullres` 指定它（在这种情况下请确保调整 -np！）。有关所有可用选项的更多信息，请运行 `nnUNetv2_plan_and_preprocess -h`。

nnUNetv2_plan_and_preprocess 将在 nnUNet_preprocessed 文件夹中创建一个名为数据集的新子文件夹。一旦命令完成，将会有一个 dataset_fingerprint.json 文件以及一个 nnUNetPlans.json 文件供您查看（如果您感兴趣的话！）。还将有包含预处理数据的子文件夹，以供您的 U-Net 配置使用。

[可选] 如果您喜欢保持事物分开，您也可以依次使用 `nnUNetv2_extract_fingerprint`、`nnUNetv2_plan_experiment` 和 `nnUNetv2_preprocess`。


### Model training

#### Overview

您可以选择训练哪些配置（2D、3D_fullres、3D_lowres、3D_cascade_fullres）！如果您不知道哪种配置在您的数据上表现最佳，只需运行所有配置，让 nnU-Net 确定最佳配置。这取决于您！

nnU-Net 在训练样本的 5-fold cross-validation 中训练所有配置。这是为了让 nnU-Net 能够估计每种配置的性能，并告诉您哪种配置适用于您的分割问题，并且是获得良好模型集合（对这 5 个模型的输出进行平均以提高性能）的一种自然方式。

您可以影响 nnU-Net 用于 5-fold cross-validation 的拆分 (see [here](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/manual_data_splits.md))。如果您更喜欢在所有训练样本上训练单个模型，这也是可能的（请参见下文）。

请注意，并非所有 U-Net 配置都适用于所有数据集。在图像尺寸较小的数据集中，将省略 U-Net 级联（以及 3D_lowres 配置），因为全分辨率 U-Net 的块尺寸已经覆盖了输入图像的大部分区域。

使用 nnUNetv2_train 命令进行模型训练。命令的一般结构为：

```bash
nnUNetv2_train DATASET_NAME_OR_ID UNET_CONFIGURATION FOLD [additional options, see -h]
```

UNET_CONFIGURATION 是一个字符串，用于标识所请求的 U-Net 配置（默认为 2D、3D_fullres、3D_lowres、3D_cascade_lowres）。DATASET_NAME_OR_ID 指定应在其上进行训练的数据集，而 FOLD 指定要训练的 5-fold cross-validation 的哪一 fold。

nnU-Net 每 50 个 epoch 存储一个检查点。如果您需要继续以前的训练，请在训练命令中添加 --c。

重要提示：如果您计划使用 `nnUNetv2_find_best_configuration`（请参见下文），请添加 `--npz` 标志。这使 nnU-Net 在最终验证期间保存 softmax 输出。它们是必需的。导出的 softmax 预测非常大，因此可能占用大量磁盘空间，这就是为什么默认情况下未启用的原因。如果您最初没有使用 `--npz` 标志运行，但现在需要 softmax 预测，请使用以下命令重新运行验证：

```bash
nnUNetv2_train DATASET_NAME_OR_ID UNET_CONFIGURATION FOLD --val --npz
```

您可以使用 `-device DEVICE` 指定 nnU-Net 应使用的设备。DEVICE 只能是 cpu、cuda 或 mps。如果您有多个 GPU，请使用 `CUDA_VISIBLE_DEVICES=X nnUNetv2_train [...]` 选择 gpu id

See `nnUNetv2_train -h` for additional options.


### 2D U-Net

For FOLD in [0, 1, 2, 3, 4], run:

```bash
nnUNetv2_train DATASET_NAME_OR_ID 2d FOLD [--npz]
```


### 3D full resolution U-Net

For FOLD in [0, 1, 2, 3, 4], run:

```bash
nnUNetv2_train DATASET_NAME_OR_ID 3d_fullres FOLD [--npz]
```


### 3D U-Net cascade

#### 3D low resolution U-Net

For FOLD in [0, 1, 2, 3, 4], run:

```bash
nnUNetv2_train DATASET_NAME_OR_ID 3d_lowres FOLD [--npz]
```

#### 3D full resolution U-Net

For FOLD in [0, 1, 2, 3, 4], run:

```bash
nnUNetv2_train DATASET_NAME_OR_ID 3d_cascade_fullres FOLD [--npz]
```

**注意级联的 3D 全分辨率 U-Net 需要低分辨率 U-Net 的 five folds 才能完成！**

经过训练的模型将写入 nnUNet_results 文件夹。每次训练获得一个自动生成的输出文件夹名称：

nnUNet_results/DatasetXXX_MYNAME/TRAINER_CLASS_NAME__PLANS_NAME__CONFIGURATION/FOLD

例如，对于 Dataset002_Heart（来自 MSD），它看起来像这样：

    nnUNet_results/
    ├── Dataset002_Heart
        │── nnUNetTrainer__nnUNetPlans__2d
        │    ├── fold_0
        │    ├── fold_1
        │    ├── fold_2
        │    ├── fold_3
        │    ├── fold_4
        │    ├── dataset.json
        │    ├── dataset_fingerprint.json
        │    └── plans.json
        └── nnUNetTrainer__nnUNetPlans__3d_fullres
             ├── fold_0
             ├── fold_1
             ├── fold_2
             ├── fold_3
             ├── fold_4
             ├── dataset.json
             ├── dataset_fingerprint.json
             └── plans.json


请注意，这里不存在3d_lowres和3d_cascade_fullres，因为这个数据集没有触发级联。在每个模型训练输出文件夹（每个fold_x文件夹）中，将创建以下文件：

- debug.json：包含用于训练该模型的蓝图和推断参数以及一堆其他内容的摘要。阅读起来不容易，但对于调试非常有用;-)
- checkpoint_best.pth：在训练过程中识别出的最佳模型的检查点文件。除非您明确告诉nnU-Net要使用它，否则现在不会使用它。
- checkpoint_final.pth：最终模型（在训练结束后）的检查点文件。这用于验证和推理。
- network_architecture.pdf（仅在安装了hiddenlayer时！）：带有网络体系结构图的pdf文档。
- progress.png：显示训练过程中的损失、伪Dice、学习率和时期时间。在顶部是训练（蓝色）和验证（红色）损失的绘图。还显示了Dice的近似值（绿色）以及它的移动平均值（虚线绿色线）。这个近似值是前景类别的平均Dice分数。需要非常（！）谨慎地对待它，因为它是在每个时期末从验证数据中随机抽取的块上计算的，而用于Dice计算的TP、FP和FN的聚合将这些块视为来自同一个体积（'全局Dice'；我们不计算每个验证案例的Dice然后对所有案例进行平均，而是假装只有一个验证案例从中我们采样块）。原因是'全局Dice'在训练过程中很容易计算，并且仍然非常有用以评估模型是否在训练。正确的验证需要太长时间才能在每个时期完成。它在训练结束时运行。
- validation_raw：在这个文件夹中是在训练完成后预测的验证案例。这里的summary.json文件包含验证指标（文件开头提供了所有案例的平均值）。如果设置了--npz，则压缩的softmax输出（保存为.npz文件）也在这里。

在训练过程中，经常观察进度是有用的。因此，我们建议您在第一次训练时查看生成的progress.png。它将在每个时期后更新。

训练时间在很大程度上取决于GPU。我们建议用于训练的最小GPU是Nvidia RTX 2080ti。对于这一GPU，所有网络训练都需要不到2天的时间。请参考我们的[基准测试](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/benchmarking.md)，了解您的系统是否按预期执行。


### Using multiple GPUs for training

如果您可以使用多个 GPU，使用它们的最佳方式是一次训练多个 nnU-Net 训练，每个 GPU 一个。这是因为数据并行性永远不会完美地线性扩展，尤其是对于小型网络，例如 nnU-Net 使用的网络。

Example:

```bash
CUDA_VISIBLE_DEVICES=0 nnUNetv2_train DATASET_NAME_OR_ID 2d 0 [--npz] & # train on GPU 0
CUDA_VISIBLE_DEVICES=1 nnUNetv2_train DATASET_NAME_OR_ID 2d 1 [--npz] & # train on GPU 1
CUDA_VISIBLE_DEVICES=2 nnUNetv2_train DATASET_NAME_OR_ID 2d 2 [--npz] & # train on GPU 2
CUDA_VISIBLE_DEVICES=3 nnUNetv2_train DATASET_NAME_OR_ID 2d 3 [--npz] & # train on GPU 3
CUDA_VISIBLE_DEVICES=4 nnUNetv2_train DATASET_NAME_OR_ID 2d 4 [--npz] & # train on GPU 4
...
wait
```

重要提示：出于速度原因，第一次运行训练时，nnU-Net 会将预处理数据提取到未压缩的 numpy 数组中！此操作必须在开始多次相同配置的训练之前完成！等待开始后续折叠，直到第一次训练使用 GPU！根据数据集大小和您的系统，这最多只需要几分钟。

如果您坚持运行 DDP 多 GPU 训练，我们可以满足您的要求：

`nnUNetv2_train DATASET_NAME_OR_ID 2d 0 [--npz] -num_gpus X`

再次注意，这比在单独的 GPU 上运行单独的训练要慢。仅当您手动干扰了 nnU-Net 配置并且正在训练具有更大补丁和/或批量大小的更大模型时，DDP 才有意义！

使用 `-num_gpus` 时很重要：
1. 如果您使用 2 个 GPU 进行训练，但系统中有更多 GPU，您需要通过 CUDA_VISIBLE_DEVICES=0,1（或任何您的 ID）指定应使用哪些 GPU。
2. 您指定的 GPU 数量不能超过小批量中的样本数量。如果 batch size 为 2，则最大为 2 个 GPU！
3. 确保您的批量大小可以被您使用的 GPU 数量整除，否则您将无法充分利用您的硬件。


### Automatically determine the best configuration

一旦所需的配置得到训练（完全交叉验证），您可以告诉 nnU-Net 自动为您识别最佳组合：

```commandline
nnUNetv2_find_best_configuration DATASET_NAME_OR_ID -c CONFIGURATIONS 
```

`CONFIGURATIONS` 特此列出了您想要探索的配置。默认情况下，启用集成意味着 nnU-Net 将生成所有可能的集成组合（每个集成 2 个配置）。这需要包含验证集预测概率的 .npz 文件存在（使用带有 `--npz` 标志的 `nnUNetv2_train`，见上文）。您可以通过设置 `--disable_ensembling` 标志来禁用集成。

有关更多选项，请参阅 `nnUNetv2_find_best_configuration -h`。

nnUNetv2_find_best_configuration 也会自动确定应该使用的后处理。 nnU-Net 中的后处理仅考虑去除预测中除最大成分以外的所有成分（一次用于前景与背景，一次用于每个标签/区域）。

完成后，该命令将准确地向您的控制台打印出您需要运行哪些命令来进行预测。它还将在 `nnUNet_results/DATASET_NAME` 文件夹中创建两个文件供您检查：

- `inference_instructions.txt` 再次包含您需要用于预测的确切命令
- 可以检查 `inference_information.json` 以查看所有配置和集成的性能，以及后处理的效果和一些调试信息。


### Run inference 运行推理

请记住，位于输入文件夹中的数据的文件结尾必须与您训练模型的数据集相同，并且必须遵守图像文件的 nnU-Net 命名方案（请参阅[数据集格式](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format.md)和[推理数据格式](https://github.com/MIC-DKFZ/nnUNet/blob/master/documentation/dataset_format_inference.md)！）

`nnUNetv2_find_best_configuration`（见上文）将使用您需要使用的推理命令将字符串打印到终端。运行推理的最简单方法是简单地使用这些命令。

如果您希望手动指定用于推理的配置，请使用以下命令：

#### Run prediction 运行预测
对于每个所需的配置，运行：

```
nnUNetv2_predict -i INPUT_FOLDER -o OUTPUT_FOLDER -d DATASET_NAME_OR_ID -c CONFIGURATION --save_probabilities
```

`--save_probabilities` 将使命令保存预测概率以及需要大量磁盘空间的预测分割掩码。

请为每个配置选择一个单独的 `OUTPUT_FOLDER`！

请注意，默认情况下，将使用来自交叉验证的所有 5 折作为一个整体进行推理。我们强烈建议您使用所有 5 折。因此，必须在运行推理之前训练所有 5 折。

如果您希望使用单个模型进行预测，请训练所有折叠并在 `nnUNetv2_predict` 中使用 `-f all` 指定它

#### Ensembling multiple configurations

If you wish to ensemble multiple predictions (typically form different configurations), you can do so with the following command:

```bash
nnUNetv2_ensemble -i FOLDER1 FOLDER2 ... -o OUTPUT_FOLDER -np NUM_PROCESSES
```

You can specify an arbitrary number of folders, but remember that each folder needs to contain npz files that were
generated by `nnUNetv2_predict`. Again, `nnUNetv2_ensemble -h` will tell you more about additional options.

#### Apply postprocessing 应用后处理

最后，将先前确定的后处理应用于（集成的）预测：

```commandline
nnUNetv2_apply_postprocessing -i FOLDER_WITH_PREDICTIONS -o OUTPUT_FOLDER --pp_pkl_file POSTPROCESSING_FILE -plans_json PLANS_FILE -dataset_json DATASET_JSON_FILE
```

`nnUNetv2_find_best_configuration` (or its generated `inference_instructions.txt` file) 会告诉你在哪里可以找到后处理文件。如果没有，您可以在结果文件夹中查找它 (it's creatively named `postprocessing.pkl`)。如果您的源文件夹来自合奏，您还需要指定应该使用的 `-plans_json` 文件和 `-dataset_json` 文件（对于单一配置预测，这些是从各自的训练中自动复制的）。您可以从任何合奏成员中挑选这些文件。

## How to run inference with pretrained models
See [here](run_inference_with_pretrained_models.md)