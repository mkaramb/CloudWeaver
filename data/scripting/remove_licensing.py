# george trammell
import os

# func
def remove_license_comment(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    # find licensing block
    if lines[0].startswith('/**'):
        end_of_comment_index = None
        for i, line in enumerate(lines):
            if line.strip().endswith('*/'):
                end_of_comment_index = i
                break
        
        # remove licensing block and whitespace
        if end_of_comment_index is not None:
            lines = lines[end_of_comment_index + 1:]
            while lines and lines[0].strip() == '':
                lines.pop(0)
        # error handling
        else:
            print(f"No end of comment found in {file_path}.")
    else:
        print(f"No licensing comment found at the start of {file_path}.")
    
    # write contents back to file
    with open(file_path, 'w') as file:
        file.writelines(lines)

def remove_license_comments_in_directory(directory_path):
    for root, dirs, files in os.walk(directory_path):
        for file in files:
            if file.endswith('.tf'):
                file_path = os.path.join(root, file)
                remove_license_comment(file_path)
                print(f"Processed {file_path}")

# main
remove_license_comments_in_directory('./terraform_code_samples')
