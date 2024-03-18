import os
import shutil

def remove_files_and_dirs(root_dir):
    # targets
    targets = [
        ".git", ".github", ".gitignore", ".dockerignore", "CHANGELOG.md",
        "CONTRIBUTING.md", "Makefile", "LICENSE", "CODEOWNERS",
        "kitchen.yml", ".kitchen.yml", "helpers", "build", ".pre-commit-config.yaml",
        "test", "autogen", ".DS_Store"
    ]
    target_extensions = {'.png', '.json', '.tfvars'}
    removed_items = []

    for root, dirs, files in os.walk(root_dir, topdown=False):
        # remove target directories
        for name in dirs:
            dir_path = os.path.join(root, name)
            if name in targets:
                shutil.rmtree(dir_path, ignore_errors=True)
                removed_items.append(dir_path)

        # remove target files
        for name in files:
            file_path = os.path.join(root, name)
            if name in targets or name.endswith(tuple(target_extensions)) or (name.endswith('.yaml') and name != 'metadata.yaml'):
                os.remove(file_path)
                removed_items.append(file_path)

    # output text file of removals
    with open("removal_log_" + os.path.basename(root_dir) + ".txt", "w") as log_file:
        for item in removed_items:
            log_file.write(f"Removed: {item}\n")

def rename_directory_if_needed(directory_path):
    # remove if directory name starts with "terraform-"
    dir_name = os.path.basename(directory_path)
    if dir_name.startswith("terraform-"):
        parent_dir = os.path.dirname(directory_path)
        new_dir_name = dir_name.replace("terraform-", "", 1)
        new_dir_path = os.path.join(parent_dir, new_dir_name)
        os.rename(directory_path, new_dir_path)
        return new_dir_path  # return the new directory (if renamed)
    return directory_path  # return original (no need)

def relocate_files_to_main_folder(directory_path):
    # creates main folder by collecting leftover files
    main_folder_path = os.path.join(directory_path, "main")
    if not os.path.exists(main_folder_path):
        os.mkdir(main_folder_path)

    for item in os.listdir(directory_path):
        item_path = os.path.join(directory_path, item)
        if os.path.isfile(item_path):
            shutil.move(item_path, main_folder_path)

if __name__ == "__main__":
    directory_to_clean = input("Enter the path of the directory to clean: ")
    remove_files_and_dirs(directory_to_clean)
    new_directory_path = rename_directory_if_needed(directory_to_clean)
    relocate_files_to_main_folder(new_directory_path)
    print(f"Cleaning, renaming, and relocating process completed. Check 'removal_log_{os.path.basename(new_directory_path)}.txt' for details.")
