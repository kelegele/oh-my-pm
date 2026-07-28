#!/usr/bin/env python3
"""Oh-My-PM context contract validator.

仅用 Python 标准库实现的轻量 JSON Schema 校验器（不依赖 jsonschema）。
校验内容：schema 声明的顶层 required 字段存在性 + 顶层字段类型
（object / array / string / number / boolean），不深入嵌套结构。

用法：
  python3 tests/validate_contracts.py                  校验 contracts/examples/ 全部示例
  python3 tests/validate_contracts.py <json-file>      单文件模式：按文件 basename 在
                                                       contracts/ 中查找 <name>.schema.json

退出码：全部通过为 0；任一校验失败或文件/schema 缺失为非 0。
"""

import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent.parent
CONTRACTS_DIR = PROJECT_ROOT / "contracts"
EXAMPLES_DIR = CONTRACTS_DIR / "examples"
SCHEMA_SUFFIX = ".schema.json"

_TYPE_CHECKS = {
    "object": lambda v: isinstance(v, dict),
    "array": lambda v: isinstance(v, list),
    "string": lambda v: isinstance(v, str),
    # bool 是 int 的子类，number 必须显式排除 True/False
    "number": lambda v: isinstance(v, (int, float)) and not isinstance(v, bool),
    "boolean": lambda v: isinstance(v, bool),
}


def json_type_name(value):
    """返回值的 JSON 类型名，用于错误信息。"""
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "boolean"
    if isinstance(value, (int, float)):
        return "number"
    if isinstance(value, str):
        return "string"
    if isinstance(value, list):
        return "array"
    if isinstance(value, dict):
        return "object"
    return type(value).__name__


def load_json(path):
    """读取并解析 JSON 文件；失败时打印错误并退出（非零）。"""
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except FileNotFoundError:
        print(f"ERROR - file not found: {path}")
        sys.exit(2)
    except json.JSONDecodeError as e:
        print(f"ERROR - invalid JSON in {path}: {e}")
        sys.exit(2)


def validate(instance, schema):
    """对照 schema 校验实例，返回错误信息列表（空列表 = 通过）。

    只做轻量检查：根类型、顶层 required 存在性、顶层字段类型。
    """
    errors = []

    if schema.get("type") == "object" and not isinstance(instance, dict):
        return [f"root: expected type object, got {json_type_name(instance)}"]

    for field in schema.get("required", []):
        if field not in instance:
            errors.append(f"missing required field: '{field}'")

    for field, spec in schema.get("properties", {}).items():
        expected = spec.get("type")
        if expected is None or field not in instance:
            continue
        check = _TYPE_CHECKS.get(expected)
        if check is None:
            # 未支持的类型关键字跳过，保持校验器轻量
            continue
        if not check(instance[field]):
            errors.append(
                f"field '{field}': expected type {expected}, "
                f"got {json_type_name(instance[field])}"
            )

    return errors


def schema_path_for(json_path):
    """按 JSON 文件的 basename 推导对应 schema 路径：xxx.json -> contracts/xxx.schema.json。"""
    name = Path(json_path).name
    if name.endswith(".json"):
        name = name[: -len(".json")]
    return CONTRACTS_DIR / f"{name}{SCHEMA_SUFFIX}"


def display_path(path):
    """用于输出的路径：仓库内显示相对路径，仓库外原样显示。"""
    path = Path(path)
    try:
        return path.relative_to(PROJECT_ROOT)
    except ValueError:
        return path


def check_one(json_path, schema_path):
    """校验单个文件，打印结果；返回是否通过。"""
    schema = load_json(schema_path)
    instance = load_json(json_path)
    errors = validate(instance, schema)
    rel_json = display_path(json_path)
    if errors:
        print(f"[FAIL] {rel_json}")
        for err in errors:
            print(f"       - {err}")
        return False
    print(f"[PASS] {rel_json}  (schema: {display_path(schema_path)})")
    return True


def run_single(json_file):
    """单文件模式：供 bin/validate-context.sh 运行期自检调用。"""
    json_path = Path(json_file)
    if not json_path.is_file():
        print(f"ERROR - file not found: {json_file}")
        return 2
    schema_path = schema_path_for(json_path)
    if not schema_path.is_file():
        print(
            f"ERROR - no contract schema for '{json_path.name}': "
            f"expected {schema_path.relative_to(PROJECT_ROOT)}"
        )
        return 2
    return 0 if check_one(json_path, schema_path) else 1


def run_all():
    """全量模式：contracts/*.schema.json 与 contracts/examples/*.json 必须一一对应且全部通过。"""
    schemas = sorted(CONTRACTS_DIR.glob(f"*{SCHEMA_SUFFIX}"))
    if not schemas:
        print(f"ERROR - no schemas found under {CONTRACTS_DIR}")
        return 2

    passed = 0
    failed = 0

    for schema_path in schemas:
        name = schema_path.name[: -len(SCHEMA_SUFFIX)]
        example_path = EXAMPLES_DIR / f"{name}.json"
        if not example_path.is_file():
            print(f"[FAIL] {example_path.relative_to(PROJECT_ROOT)}")
            print(f"       - missing example for schema: {schema_path.relative_to(PROJECT_ROOT)}")
            failed += 1
            continue
        if check_one(example_path, schema_path):
            passed += 1
        else:
            failed += 1

    # 反向检查：存在示例但无对应 schema
    schema_names = {p.name[: -len(SCHEMA_SUFFIX)] for p in schemas}
    for example_path in sorted(EXAMPLES_DIR.glob("*.json")):
        if example_path.stem not in schema_names:
            print(f"[FAIL] {example_path.relative_to(PROJECT_ROOT)}")
            print("       - example has no matching schema in contracts/")
            failed += 1

    print("")
    print(f"Contract validation: {passed} passed, {failed} failed")
    return 0 if failed == 0 else 1


def main(argv):
    if len(argv) == 1:
        return run_all()
    if len(argv) == 2:
        return run_single(argv[1])
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
