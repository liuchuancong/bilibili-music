import os
import argparse
from pathlib import Path

def generate_inno_setup_entries(path, output_file):
    """
    生成 Inno Setup 安装脚本的文件条目，支持文件或目录路径
    
    参数:
    path (str): 源文件或目录路径
    output_file (str): 输出文本文件路径
    """
    # 处理可能的路径问题
    path = path.strip()
    
    # 检查路径是否存在
    if not os.path.exists(path):
        print(f"错误：路径 '{path}' 不存在")
        print("提示：请确保路径正确，避免转义字符问题。")
        print("  - 使用双反斜杠：D:\\path\\to\\file")
        print("  - 使用原始字符串：r'D:\\path\\to\\file'")
        print("  - 使用正斜杠：D:/path/to/file")
        return
    
    try:
        # 收集所有要处理的文件
        file_list = []
        
        if os.path.isfile(path):
            # 如果是文件，直接添加
            normalized_path = os.path.normpath(path)
            file_list.append(normalized_path)
        else:
            # 如果是目录，收集所有文件
            for item in os.listdir(path):
                item_path = os.path.join(path, item)
                if os.path.isfile(item_path):
                    normalized_path = os.path.normpath(item_path)
                    file_list.append(normalized_path)
        
        # 如果没有找到文件，提示并返回
        if not file_list:
            print(f"路径 '{path}' 中没有找到文件")
            return
        
        # 生成 Inno Setup 条目 - 使用原始字符串避免转义问题
        inno_entries = []
        for file_path in file_list:
            # 关键修改：使用原始字符串并手动处理引号
            current_directory = os.getcwd()
            escaped_path = current_directory + '\\' + file_path.replace('\\', '\\\\').replace('"', '\"').replace("\\\\", "\\")
            entry = f'Source: "{escaped_path}"; DestDir: "{{app}}"; Flags: ignoreversion'
            inno_entries.append(entry)
        
        # 写入到文本文件
        with open(output_file, 'w', encoding='utf-8') as f:
            # 直接写入字符串，不进行额外转义
            f.write('\n'.join(inno_entries))
        
        print(f"成功生成 {len(inno_entries)} 个文件条目到 {output_file}")
        print(f"你可以用文本编辑器打开 {output_file} 查看实际内容")
        
    except Exception as e:
        print(f"发生错误: {e}")

if __name__ == "__main__":
    generate_inno_setup_entries(r'./build/windows/x64/runner/Release', 'nno_setup_files.txt')    