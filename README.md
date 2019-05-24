IPHCodeObfuscationTool
=============================================================
`IPHCodeObfuscationTool.sh`是一个自动化的脚本，意在帮助开发者将`IPHCodeObfuscation`工具工程添加到需要进行代码混淆的的工程。

<br />
<br />


使用说明：
-------------------------------------------------------------
1、下载 `IPHCodeObfuscationTool`目录（需要 `IPHCodeObfuscationTool.sh`和`add_pch_tools`脚本工具在同一目录）

2、打开终端，cd到你的工程根目录，如：

```shell
    cd /Users/iPhuan/Desktop/CodeConfusionTest
```

3、将`IPHCodeObfuscationTool.sh`拖入终端执行脚本，如有提示根据提示操作选择

4、参考[IPHCodeObfuscation](https://github.com/iPhuan/IPHCodeObfuscation.git)说明对代码进行混淆

<br />
<br />



手动添加IPHCodeObfuscation：
-------------------------------------------------------------
1、下载[IPHCodeObfuscation](https://github.com/iPhuan/IPHCodeObfuscation.git)，将其拷贝到主工程目录
>注意需要移除`IPHCodeObfuscation`目录中git信息

2、打开你的工程，在Podfile文件的结尾添加以下代码并执行`pod install`命令

```ruby
    pod 'IPHCodeObfuscation',           :path => './IPHCodeObfuscation'
    require './IPHCodeObfuscation/IPHObfuscationTools/PodObfuscate.rb'
    do_obfuscate
```

3、在主工程创建Prefix Header头文件，文件中需要包含`IPHObfuscationSymbolsHeader.h`头文件的引用，并在`Build Settings`的`Prefix Header`选项关联该pch文件

4、参考[IPHCodeObfuscation](https://github.com/iPhuan/IPHCodeObfuscation.git)说明对代码进行混淆




**`注意：`**
-------------------------------------------------------------
:warning: 本工具适用于通过CocoaPods管理的项目工程；



<br />
<br />

版本记录：
-------------------------------------------------------------
### V1.0.0
更新日期：2018年1月22日  
更新说明：  
> * 发布`IPHCodeObfuscationTool`第一个版本。  

-------------------------------------------------------------    


### V2.0.0
更新日期：2018年4月24日  
更新说明：  
> * 新增自动添加pch文件操作；
> * 新增`ObfuscationList.h`文件备份操作，`IPHCodeObfuscation`可通过脚本进行更新。

-------------------------------------------------------------  


### V2.0.1
更新日期：2018年5月10日  
更新说明：  
> * 更新Git域名。  

-------------------------------------------------------------    

