#!/bin/bash

# 检查参数是否正确
if [ $# -ne 1 ]; then
    echo "Usage: $0 <ELF_FILE>"
    exit 1
fi

TARGET="$1"

# 基本校验函数
check_elf() {
    if [ ! -f "$TARGET" ]; then
        echo "Error: $TARGET does not exist."
        exit 1
    fi
    
    if ! file "$TARGET" | grep -q ELF; then
        echo "Error: $TARGET is not an ELF file."
        exit 1
    fi
}

# 检查依赖
check_deps() {
    if ! command -v patchelf &> /dev/null; then
        echo "Error: patchelf is required. Install with: sudo apt install patchelf"
        exit 1
    fi
}

# 查找glibc-all-in-one路径
find_glibc_root() {
    # 优先使用环境变量
    if [ -n "$GLIBC_ALL_IN_ONE_PATH" ] && [ -d "$GLIBC_ALL_IN_ONE_PATH" ]; then
        echo "$GLIBC_ALL_IN_ONE_PATH"
        return
    fi

    # 常见安装路径
    local possible_paths=(
        "$HOME/glibc-all-in-one"
        "$HOME/tools/glibc-all-in-one"
        "/opt/glibc-all-in-one"
    )

    for path in "${possible_paths[@]}"; do
        if [ -d "$path" ]; then
            echo "$path"
            return
        fi
    done

    # 手动输入
    while true; do
        read -p "Enter glibc-all-in-one path: " user_path
        if [ -d "$user_path" ]; then
            echo "$user_path"
            return
        else
            echo "Invalid path: $user_path"
        fi
    done
}

# 主程序
main() {
    check_elf
    check_deps

    local glibc_root
    glibc_root=$(find_glibc_root)
    local libs_dir="$glibc_root/libs"

    if [ ! -d "$libs_dir" ]; then
        echo "Error: Missing libs directory in $glibc_root"
        exit 1
    fi

    # 获取版本列表
    local versions=()
    mapfile -t versions < <(find "$libs_dir" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | sort)

    if [ ${#versions[@]} -eq 0 ]; then
        echo "Error: No glibc versions found in $libs_dir"
        exit 1
    fi

    # 显示版本菜单
    echo "choose glibc versions:"
    for i in "${!versions[@]}"; do
        printf "%2d) %s\n" $i "${versions[i]}"
    done

    # 获取用户选择
    local choice
    while true; do
        read -p "Select version (0-$((${#versions[@]}-1)): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt ${#versions[@]} ]; then
            break
        fi
        echo "Invalid selection!"
    done

    local selected_dir="$libs_dir/${versions[choice]}"
    
    # 验证关键文件
    local ld_path
    ld_path=$(find "$selected_dir" -name 'ld-*.so' -print -quit)
    if [ -z "$ld_path" ] || [ ! -f "$selected_dir/libc.so.6" ]; then
        echo "Error: Invalid glibc version directory"
        exit 1
    fi

    # 应用修改
    echo -e "\nPatching with:"
    echo "Interpreter: $ld_path"
    echo "RPATH:      $selected_dir"
    
    if patchelf --set-interpreter "$ld_path" --set-rpath "$selected_dir" "$TARGET"; then
        echo -e "\nPatch successful!"
        echo "Verify with:"
        echo "  file $TARGET"
        echo "  ldd $TARGET"
    else
        echo -e "\nError: Patching failed!"
        exit 1
    fi
}

# 执行主程序
main
