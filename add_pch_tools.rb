#  V2.0.1
#  Created by iPhuan on 2018/04/20.



puts "================================================================================"

require 'fileutils'
require 'xcodeproj'
require 'find'


def create_pch_file(pch_path)
    puts "准备创建主工程pch文件：#{pch_path}"

    if File.exist?(pch_path) == true
        puts "已存在#{pch_path}"
        else
        
        puts "开始创建主工程pch文件：#{pch_path}"
        Dir.mkdir("IPHObfuscationPrefixHeader")
        pch_file=File.new(File.join(pch_path),"w+")
        
        pch_file.puts "#ifndef IPHObfuscation_prefix_pch
\#define IPHObfuscation_prefix_pch
        
\#import \"IPHObfuscationSymbolsHeader.h\"
        
\#endif /* IPHObfuscation_prefix_pch */"
        pch_file.close
        puts "主工程pch文件IPHObfuscation-prefix.pch文件已创建成功！"
        
    end
end

def add_pch_to_project(project, target)
    
    file_ref_list = target.source_build_phase.files_references
    pch_ref_mark = false
    
    for file_ref_temp in file_ref_list
        if file_ref_temp.path.to_s.end_with?("IPHObfuscation-prefix.pch")
            pch_ref_mark = true
            break
        end
    end
    
    if pch_ref_mark
        puts "工程已包含IPHObfuscation-prefix.pch文件，请确认该pch文件是否已引用IPHObfuscationSymbolsHeader.h头文件"
        return
    end
        
        
        puts "创建Group IPHObfuscationPrefixHeader"
        pch_group = project.main_group.new_group("IPHObfuscationPrefixHeader","IPHObfuscationPrefixHeader")
        file_reference = pch_group.new_reference("IPHObfuscation-prefix.pch")
        
        puts "添加文件引用IPHObfuscation-prefix.pch"
        target.add_file_references([file_reference])
        puts "文件引用IPHObfuscation-prefix.pch添加成功！"
    end


def add_import_to_pch(prefix_header)
    puts "往已有的pch文件#{prefix_header}中写入import内容"

    temp_file=File.new(File.join("temp"),"w")
    
    endif_tag = false
    exist_tag = false
    
    File.foreach(prefix_header) do |line|
        # 如果已存在import引用则停止处理
        if line =~ /#import \"IPHObfuscationSymbolsHeader.h\"/
            exist_tag = true
            temp_file.close
            File.delete(temp_file)
            break
        end
        
        
        if line =~ /#endif/
            temp_file.puts "#import \"IPHObfuscationSymbolsHeader.h\"
            "
            endif_tag = true
        end
        
        temp_file.puts line
    end
    
    if exist_tag == true
        puts "#{prefix_header}文件中已包含IPHObfuscationSymbolsHeader.h头文件引用"
        return
    end
    
    
    
    if endif_tag == false
        temp_file.puts "#import \"IPHObfuscationSymbolsHeader.h\""
    end
    
    
    temp_file.close
    
    open(prefix_header,"w").write(open(temp_file).read)
    puts "写入IPHObfuscationSymbolsHeader.h头文件引用成功！"
    
    File.delete(temp_file)
end





cur_dir = Dir::pwd
puts "当前运行目录：#{cur_dir}"
Dirs = cur_dir.split("/")

cur_proj = Dirs.last
Find.find("#{cur_dir}") do |file|
    paths = file.split("/")
    if paths.last.include?(".xcodeproj")
        cur_proj = paths.last
    end
end

puts "当前工程：#{cur_proj}"



puts "打开#{cur_proj}"
project = Xcodeproj::Project.open(cur_proj)
target = project.targets.first


pch_path = "IPHObfuscationPrefixHeader/IPHObfuscation-prefix.pch"


puts "
>>>> 准备在Build Settings中设置Prefix Header"

target.build_configurations.each do |config|
    puts "
    >>>>>>>> #{config.name}设置"
    
        prefix_header = config.build_settings['GCC_PREFIX_HEADER']
        if prefix_header && prefix_header != ""
            
            puts "工程已包含Prefix Header选项：#{prefix_header}"
            
            add_import_to_pch prefix_header

            
            else
            
            # 保证只创建一次文件
            if config.name == "Debug"
                create_pch_file pch_path
                
                puts "准备添加pch文件：#{pch_path}到工程"
                add_pch_to_project project, target
            end

            puts "在Build Settings中设置Prefix Header"
            config.build_settings['GCC_PREFIX_HEADER'] ||= pch_path
            puts "设置Prefix Header成功！"
            
        end
        
        puts "完成#{config.name}设置！<<<<<<<<
        
        "
end

project.save
puts "Prefix Header设置操作完成！<<<<

"

puts "================================================================================"
