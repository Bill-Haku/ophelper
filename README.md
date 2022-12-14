# 原神披萨小助手

## 开发规范

- **鉴于各位开发SwiftUI程序的经验可能不多，为了提高代码质量，保证程序水平，各位可以参考这一份[Swift / SwiftUI开发代码规范](https://github.com/Bill-Haku/wiki/wiki/SwiftUI-Coding-Standards )**

- 其他例如Android开发等也有许多相似的经验和习惯，可以参考。

### 其他的一些注意事项

- 请在每一个文件的头部自动生成的注释的最后一行补充说明该文件内的代码的主要内容和目的，以便其他开发者了解阅读。

- Xcode左侧各文件夹内的文件已经按照字典序排列，在新添加文件时，请保持该顺序。

- 有关注释的使用等，再次不再赘述。可以参考前面提到的代码规范和其他业内习惯。

## Git使用说明

- **本仓库dev分支包含最新的已完成内容，main分支包含最新的已发布内容。dev分支原则上不允许直接Push commit进入；main分支不允许直接Push commit进入。应当使用提出PR的方式合并入dev，再合并入main.** 

- 使用Git时，遵循多Commit，多Branch，多PR的原则。

- PR原则上需要完成Code Review后才能合并。一般不由自己合并。合并的PR原则上应当在远端删除源分支。PR的comment中最好一并关闭相关的已解决的issue.

- 关于Commit和其他的命名和使用规范可以参考[这篇博客](https://jaeger.itscoder.com/dev/2018/09/12/using-git-in-project.html)。

## 关于项目的若干说明

### 版本号

目标版本号由开发组讨论决定。本Project包含3个target，应确保3个target的版本号和构建版本号相同。

### 构建版本号

一般来讲构建版本号应当每一次构建则自动+1，但是Xcode的自动+1的脚本会导致允许莫名其妙取消掉的bug，本项目中构建版本号改为到修改版本号后主分支所有commit的次数。一般来说会在合并到dev分支后再来单独更新构建版本号。

### Tag

在主要的功能完成时可以在最后合并的commit上打上tag. 将要发布测试版和正式版时必须打上Tag标记。Tag的格式为: `v<Version>-<Suffix (Optional)>-<Build>`, 例如:

`v2.0.0-Beta.1-258`: 2.0.0的第1个Beta版，build号为258

`v2.0.0-RC.2-308`: 2.0.0版本的第2个RC版(Release Candidate)，build号为308

`v2.0.0-309`: 2.0.0版本正式版，build号为309

使用Beta版标记或RC版标记提交TF测试的版本。使用RC版标记提交正式版审核的版本。提交正式版审核和TF测试的的版本时Tag中均不包含正式版本的tag。仅当正式版审核通过发布后再在对应的RC版上补上正式版的Tag.

关于版本号的更多标准，请参考这篇[规范](https://semver.org)。

## 关于国际化的若干说明

国际化主要翻译的内容为若干个`*.strings`文件。目前的国际化基于2.0版本的所有需要翻译的条目。

在开发过程中，除非是关键部分的UI测试，原则上不翻译只添加字符串。国际化工作在新版本发布前最后完成。

### 国际化对照表文件说明

- 国际化对照表的基本格式为`"<Original Text>" = "<Localized Text>";`.

- 应当注意分段和使用注释：注释的内容为代码相关的页面或所属的类型。

- 应当保证各语言的对照表文件除了翻译的内容外完全相同。最主要的是行数。应当保证各语言的行数完全一致，避免出现不同语言的漏译。为了便于检查，请保持空行和注释的位置和数量完全一致。

- 对于每个版本的新增的国际化内容，在文件末尾单独添加。使用注释声明接下来的内容的添加时的版本，然后按照第2点所述添加内容。示例如下：

    ``` swift
    // MARK: - 2.0 & above
    // View A
    "" = "";
    // ...
    // View B
    "" = "";
    // 2.0 Contents...
    
    // MARK: - 2.1
    // View A
    "" = "";
    // 2.1 Contents...
    
    // MARK: - 2.2
    // View C
    "" = "";
    // 2.2 Contents...
    ```
    

### 国际化工作流程介绍

1. 开发过程中，不添加国际化相关内容。

2. 版本全部开发结束后，切换测试语言为English，将新增的页面和修改的页面的内容添加到`Localizable(English).strings`文件中，然后复制到其他语言的国际化文件中。

3. 在`Localizable(English).strings`文件中完成英语内容的翻译。

4. 运行测试，检查翻译是否生效。如果是需要项目代码需要做国际化适配，则修改项目代码。如果是国际化对照表出现遗漏或错误，则修改国际化对照表文件。

5. 第4步检查无误后，完成其他语言的国际化翻译对照文件翻译。

6. 全部完成后，切换到对应的语言运行，检查翻译是否生效。（此时理论上不会有问题。）检查翻译内容是否有需要优化改进的地方。

## 开源工作备忘录

### 开源工作流程

1. 复制一遍源代码文件夹，删除.git和readme文件

2. 打开 WatchHelper WatchKit Extension/View/ContentView.swift 文件，删除cookie

3. 打开【】，修改salt为“Opensource Secret”（暂未生效）

4. 将所有文件移动覆盖到开源仓库文件夹

