import os
from os.path import dirname
import re
import sys


def rep(text):
    return text.replace("\\", "/").rstrip("/")


def output(file, line):
    global file_printed
    if not file_printed:
        print('----', file)
        file_printed = 1
    print(line)


def is_dir_names_in_str(dir_name, str):
    for i in dir_name:
        if i in str:
            return True
    return False


def one(file):
    global cmd
    global proj
    global cur_file
    global url_name
    global exclude_md_name
    global include_md_ft
    global patt
    global dir_name

    if (
        rep(file).split("/")[-1].lower() in exclude_md_name
        or file.split(".")[-1].lower() not in include_md_ft
    ):
        return
    with open(file, "rb") as f:
        lines = f.readlines()

    if "show" not in cmd:
        f = open(file, "wb")

    url = b""
    for _ in re.findall("/", file[len(proj) + 1 :]):
        url += b"../"

    global file_printed
    file_printed = 0

    for i in range(len(lines)):
        line = lines[i]
        res = re.findall(patt, line)
        if "update" in cmd:
            if res:
                res = res[0]
                if not is_dir_names_in_str(dir_name, rep(res[2].decode("utf-8"))):
                    f.write(line)
                    continue
                temp = res[0]
                temp += res[1]
                temp += b"("
                temp += url
                temp += "/".join(rep(res[2].decode("utf-8")).split("/")[-2:]).encode(
                    "utf-8"
                )
                temp += b")"
                temp += res[3]
                temp += b"\n"
                f.write(temp)
                output(file, '%s %s' % (f'{i + 1:4d}', temp.strip().decode('utf-8')))
            else:
                f.write(line)
        elif "show" in cmd:
            if res:
                res = res[0]
                if not is_dir_names_in_str(dir_name, rep(res[2].decode("utf-8"))):
                    continue
                if 'under' in cmd:
                    if url_name in line:
                        output(file, '%s %s' % (f'{i + 1:4d}', line.strip().decode("utf-8")))
                else:
                    output(file, '%s %s' % (f'{i + 1:4d}', line.strip().decode("utf-8")))

    if "show" not in cmd:
        f.close()


if __name__ == "__main__":
    if len(sys.argv) < 3:
        os._exit(1)

    cmd = rep(sys.argv[1])
    proj = rep(sys.argv[2])
    cur_file = rep(sys.argv[3])
    url_name = rep(sys.argv[4]).encode('utf-8')
    exclude_md_name = sys.argv[5].split(",")
    include_md_ft = sys.argv[6].split(",")
    dir_name = sys.argv[7].split(",")
    patt = b"(.*)(!*\\[[^\\]]+\\])\\(([^\\)]+)\\)(.*)"

    print('====', cmd)

    if "cur" in cmd:
        one(cur_file)
    else:
        for root, _, files in os.walk(proj):
            for file in files:
                one(rep(os.path.join(root, file)))

    os.system("pause")
