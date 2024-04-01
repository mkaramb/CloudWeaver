# george trammell
import os
import shutil

# this script processes repositories from terraform-google-modules and enforces cloudweaver database format
#
# process:
# 1. main wrapper -> process_terraform_directories()
# 2. removal -> remove_files_and_dirs()
# 3. renaming -> rename_directory()
# 4. licensing -> remove_license_block()
# 5. merging -> merge_extra_tf_files()
# 6. verification -> verify_directory_structure()
# 7. logging -> cleanlog.txt and mergelog.txt

def remove_files_and_dirs(root_dir):
    # direct targets to remove
    targets = [
        ".git", ".github", ".gitignore", ".dockerignore", "CHANGELOG.md", "files", "upgrades", "img", "watcher.tf",
        "CONTRIBUTING.md", "Makefile", "LICENSE", "CODEOWNERS", "test_outputs.tf", "terraform.tfvars.sample",
        "kitchen.yml", ".kitchen.yml", "helpers", "build", ".pre-commit-config.yaml", "Dockerfile", "output.tf",
        "test", "autogen", "docs", ".DS_Store", "versions.tf", "SECURITY.md", "provider.tf", "cache", "init_scripts",
        "scripts", "assets", "src", "config-root", "codelabs", "templates", "workflow_polling", "go.work",
        ".gcloudignore", "providers.tf", "entrypoint.sh", "CLOUDSHELL_TUTORIAL.md", "null_index", "version.tf"
    ]
    # indirect target extensions to remove
    target_extensions = {'.png', '.json', '.tfvars', '.yaml', '.yml', '.svg', '.tpl', '.sample', '.py'}

    for root, dirs, files in os.walk(root_dir, topdown=False):
        for name in dirs + files:
            if name in targets or name.endswith(tuple(target_extensions)):
                path = os.path.join(root, name)
                if os.path.isdir(path):
                    shutil.rmtree(path, ignore_errors=True)
                else:
                    os.remove(path)

def rename_directory(directory_path):
    # removes "terraform-google-" from product directory names for simplicity
    dir_name = os.path.basename(directory_path)
    if dir_name.startswith("terraform-google-"):
        new_dir_name = dir_name.replace("terraform-google-", "", 1)
        new_dir_path = os.path.join(os.path.dirname(directory_path), new_dir_name)
        os.rename(directory_path, new_dir_path)
        return new_dir_path
    return directory_path

def verify_directory_structure(dir_path, log_file, is_root=True):
    # verifies database architecture using sets and creates cleanlog.txt
    expected_files = {"main.tf", "README.md", "outputs.tf", "variables.tf"}
    necessary_files = {"main.tf", "README.md", "variables.tf"}
    if is_root:
        # expect examples and modules at root
        expected_dirs = {"examples", "modules"}
    else:
        expected_dirs = set()

    # set creation
    actual_files = {item for item in os.listdir(dir_path) if os.path.isfile(os.path.join(dir_path, item))}
    actual_dirs = {item for item in os.listdir(dir_path) if os.path.isdir(os.path.join(dir_path, item))}

    # set difference math
    missing_files = necessary_files - actual_files
    extra_files = actual_files - expected_files
    missing_dirs = expected_dirs - actual_dirs
    extra_dirs = actual_dirs - expected_dirs if is_root else set() # this only checks for expected dirs at root
    discrepancies = missing_files or extra_files or missing_dirs or extra_dirs

    # generate logging file
    if discrepancies:
        log_file.write(f"ISSUE WITH {dir_path[25:]}\n")
        for category, items in [("MISSING", missing_files), ("EXTRA", extra_files),
                                ("MISSING DIR", missing_dirs), ("EXTRA DIR", extra_dirs)]:
            if items:
                log_file.write(f"{category}: {', '.join(items)}\n")
        log_file.write("\n")

    # recursive verification of subdirectories
    if is_root:
        for subdir in expected_dirs & actual_dirs:
            for subitem in os.listdir(os.path.join(dir_path, subdir)):
                subitem_path = os.path.join(dir_path, subdir, subitem)
                if os.path.isdir(subitem_path):
                    verify_directory_structure(subitem_path, log_file, is_root=False)

def remove_license_block(file_path):
    # remove licensing from start of files
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    start_marker = "/**"
    end_marker = " */"

    if lines[0].strip() == start_marker:
        try:
            end = lines.index(end_marker + '\n') + 1
        except ValueError:
            return
        # write new lines after removing block
        lines = lines[end:]
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)

def remove_autogen_comment(file_path):
    # remove occasional autogen comment
    autogen_comment = "// This file was automatically generated from a template in ./autogen/main"
    with open(file_path, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # write new lines after removing comment
    new_lines = [line for line in lines if autogen_comment not in line]
    with open(file_path, 'w', encoding='utf-8') as file:
        file.writelines(new_lines)

def merge_extra_tf_files(dir_path, log_file):
    # merges important but unexpected .tf files to into main.tf
    for root, _, files in os.walk(dir_path):
        main_tf_path = os.path.join(root, "main.tf")

        if "main.tf" in files:
            # list to hold the names of extra .tf files
            extra_tf_files = [f for f in files if f.endswith('.tf') and f not in ["main.tf", "outputs.tf", "variables.tf"]]
            
            if extra_tf_files:
                # logging
                log_file.write(f"\nMerging files into {main_tf_path[26:]}: {', '.join(extra_tf_files)}\n")
                with open(main_tf_path, 'a', encoding='utf-8') as main_tf:
                    for tf_file in extra_tf_files:
                        tf_file_path = os.path.join(root, tf_file)
                        # merging
                        with open(tf_file_path, 'r', encoding='utf-8') as file:
                            # merge extra .tf files to main
                            main_tf.write("\n\n" + file.read())
                        # remove extra .tf file after merge
                        os.remove(tf_file_path)

########
# MAIN #
########
def process_terraform_directories(parent_dir):
    # renames product dirs for simplicity
    modified_directories = []
    for dir_name in os.listdir(parent_dir):
        dir_path = os.path.join(parent_dir, dir_name)
        if os.path.isdir(dir_path) and dir_name.startswith("terraform-google-"):
            remove_files_and_dirs(dir_path)
            new_dir_path = rename_directory(dir_path)
            modified_directories.append(new_dir_path)
    
    # license removal
    for dir_path in modified_directories:
        for root, dirs, files in os.walk(dir_path):
            for name in files:
                if name.endswith('.tf'):
                    file_path = os.path.join(root, name)
                    remove_license_block(file_path)
                    remove_autogen_comment(file_path)

    # extra .tf file merging
    with open("mergelog.txt", "a") as log_file:
        for dir_name in os.listdir(parent_directory):
            dir_path = os.path.join(parent_directory, dir_name)
            if os.path.isdir(dir_path):
                merge_extra_tf_files(dir_path, log_file)
    
    # verify final structure and log discrepancies
    with open("cleanlog.txt", "w") as log_file:
        for dir_path in modified_directories:
            verify_directory_structure(dir_path, log_file)

if __name__ == "__main__":
    parent_directory = "./terraform-google-modules"
    process_terraform_directories(parent_directory)
    print("Process complete. Check cleanlog.txt and mergelog.txt for details.")