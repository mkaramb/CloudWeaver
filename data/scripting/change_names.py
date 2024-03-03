# george trammell
import os
import shutil

# func
def rename_tf_to_dir_name(parent_directory):
    for root, dirs, files in os.walk(parent_directory):
        for file in files:
            # check for 'main.tf' only
            if file == 'main.tf':

                dir_name = os.path.basename(root)
                new_file_name = f"{dir_name}.tf"
                old_file_path = os.path.join(root, file)
                new_file_path = os.path.join(root, new_file_name)

                # rename
                shutil.move(old_file_path, new_file_path)
                print(f"Renamed '{old_file_path}' to '{new_file_path}'")

# main
rename_tf_to_dir_name('./terraform_code_samples')