#  V2.0.2
#  Created by iPhuan on 2018/1/21.


CUR_DIR=$(pwd)
echo "当前目录：$CUR_DIR"


replaceProject()
{
echo "备份原有ObfuscationList.h"
cp "IPHCodeObfuscation/IPHObfuscationTools/ObfuscationList.h" "ObfuscationList.h"
echo "ObfuscationList.h已备份"

echo "开始删除IPHCodeObfuscation目录"
rm -rf IPHCodeObfuscation
echo "已删除IPHCodeObfuscation目录"
}


readChoose()
{
read -s -n 1 choose_result

if [[ $choose_result = "" ]]; then
replaceProject

else

case $choose_result in
[Yy]* ) replaceProject;;
[Nn]* ) echo "准备关闭脚本..."; exit;;
* ) echo "输入指令有误，请输入Y或者N"; readChoose;;
esac

fi
}



if [ -d "IPHCodeObfuscation" ]; then
echo "存在IPHCodeObfuscation工程目录，是否进行更新替换？(Y/N)"
readChoose
fi

echo "开始下载IPHCodeObfuscation"
git clone https://github.com/iPhuan/IPHCodeObfuscation.git
echo "已下载IPHCodeObfuscation"

cd IPHCodeObfuscation
echo "切换到IPHCodeObfuscation"

rm -rf .git
echo "移除.git"

cd ..
echo "切换到根目录$CUR_DIR"

obfuscationList="ObfuscationList.h"
if [ -f $obfuscationList ];then
echo "开始恢复ObfuscationList.h"
targetFile="IPHCodeObfuscation/IPHObfuscationTools/ObfuscationList.h"
rm $targetFile
mv $obfuscationList $targetFile
echo "ObfuscationList.h恢复成功"

fi


podfileFile=Podfile
grep "do_obfuscate" $podfileFile
if [ $? -eq 0 ]; then
echo "Podfile rb文件中已包含执行混淆的指令"

else
echo "往Podfile rb文件中添加执行混淆的指令"
echo -e "\n" >> $podfileFile
echo "# 处理代码混淆
pod 'IPHCodeObfuscation',           :path => './IPHCodeObfuscation'
require './IPHCodeObfuscation/IPHObfuscationTools/PodObfuscate.rb'
do_obfuscate" >> $podfileFile
echo "已添加Podfile混淆指令"

fi

echo ""
echo "执行pod install 添加IPHCodeObfuscation相关文件到工程"
echo "================================================================================"
pod install
echo ""
echo "================================================================================"
echo "pod install执行完毕，IPHCodeObfuscation相关文件已添加到工程"

echo ""
echo "开始执行add_pch_tools.rb"
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
ruby "$SHELL_FOLDER/add_pch_tools.rb"
echo "结束执行add_pch_tools.rb"
echo ""


echo "所有操作已完成！现在开始您可打开IPHCodeObfuscation工程参考README说明对您的工程代码进行混淆了"
echo ""

