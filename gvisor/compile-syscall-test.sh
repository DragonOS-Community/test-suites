#!/bin/bash

GVISOR_DIR=$(pwd)/gvisor
ROOT_DIR=$(pwd)
RESULT_DIR=${ROOT_DIR}/results
RESULT_FILE=${RESULT_DIR}/gvisor-syscalls-tests.tar.xz

mkdir -p ${RESULT_DIR}

pushd .

# 检查目录是否存在
if [ ! -d "${GVISOR_DIR}/test/syscalls" ]; then
    echo "错误：目录 ${GVISOR_DIR}/test/syscalls 不存在！"
    exit 1
fi

cd ${GVISOR_DIR}/test/syscalls
bazel build --test_tag_filters=native //test/syscalls/...

cd ${GVISOR_DIR}
# 构建完成后进行打包
echo "正在打包测试文件..."

# 检查构建输出目录是否存在
if [ ! -d "bazel-bin/test/syscalls/linux" ]; then
    echo "错误：构建输出目录 bazel-bin/test/syscalls/linux 不存在！"
    exit 1
fi

# 检查是否有测试文件
TEST_FILES=$(ls bazel-bin/test/syscalls/linux/*_test 2>/dev/null)
if [ -z "$TEST_FILES" ]; then
    echo "错误：未找到测试文件 bazel-bin/test/syscalls/linux/*_test"
    exit 1
fi

# 创建临时目录用于打包
TEMP_DIR=$(mktemp -d)
mkdir -p "$TEMP_DIR/syscalls"

# 复制测试文件到临时目录
cp bazel-bin/test/syscalls/linux/*_test "$TEMP_DIR/syscalls/"

# 创建压缩包（使用 pixz 加速压缩）
cd "$TEMP_DIR"
# 检查是否安装了 pixz
if command -v pixz >/dev/null 2>&1; then
    echo "使用 pixz 并行压缩..."
    tar -cf - syscalls/ | pixz > ${RESULT_FILE}
else
    echo "未安装 pixz，使用标准 xz 压缩..."
    tar -cJf ${RESULT_FILE} syscalls/
fi

# 清理临时目录
rm -rf "$TEMP_DIR"

popd

echo "打包完成！压缩包已生成：${RESULT_FILE}"
echo "压缩包内目录结构：syscalls/*_test"
