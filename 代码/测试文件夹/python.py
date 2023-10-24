import os
import re

def remove_comments_and_empty_lines(file_path):
    with open(file_path, 'r') as file:
        content = file.read()
    
    # 正则表达式匹配注释
    pattern = r'\/\/.*|\/\*[\s\S]*?\*\/'
    content = re.sub(pattern, '', content)

    # 去掉空白行
    content = os.linesep.join([line for line in content.splitlines() if line.strip()])

    with open(file_path, 'w') as file:
        file.write(content)

def process_files(dir_path):
    for root, dirs, files in os.walk(dir_path):
        for file in files:
            if file.endswith('.swift') or file.endswith('.m') or file.endswith('.h'):
                file_path = os.path.join(root, file)
                remove_comments_and_empty_lines(file_path)

if __name__ == '__main__':
    project_path = '/Users/sansi/Desktop/文件夹3/20230731_项目学习/使用脚本语言删除注释/测试文件夹'
    process_files(project_path)
