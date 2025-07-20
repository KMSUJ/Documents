import re
import sys

def convert(path):
    with open(path, 'r', encoding='utf-8') as f:
        content : str = f.read()

    converted : str = re.sub(r"``", r",,", content)

    with open(path, 'w', encoding='utf-8') as f:
        f.write(converted)

    # print(f"File updated: {path}")

if __name__ == "__main__":
    convert(sys.argv[1])
    