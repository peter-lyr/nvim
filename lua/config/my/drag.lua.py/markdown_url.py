import os
import re
import sys


def rep(text):
    return text.replace("\\", "/").rstrip("/")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        os._exit(1)

    cmd = rep(sys.argv[1])
    proj = rep(sys.argv[2])
    cur_file = rep(sys.argv[3])
    url_name = "/".join(rep(sys.argv[4]).split("/")[-2:])
    exclude_md_name = sys.argv[5].split(",")
    include_md_ft = sys.argv[6].split(",")

    url_file = rep(os.path.join(proj, url_name))
    if not os.path.exists(url_file):
        os._exit(2)

    url_name = url_name.encode("utf-8")

    F = {}

    for root, _, files in os.walk(proj):
        for file in files:
            if (
                file in exclude_md_name
                or file.split(".")[-1].lower() not in include_md_ft
            ):
                continue
            file = rep(os.path.join(root, file))
            if cmd != "show": # show read more
                F[file] = []
                break
            with open(file, "rb") as f:
                lines = f.readlines()
            for i in range(len(lines)):
                line = lines[i]
                if url_name not in line:
                    continue
                if file not in F:
                    F[file] = []
                F[file].append([i + 1, line.strip().decode("utf-8")])

    if cmd == "show":
        print(f'=========== {proj} ===========')
        for f, lines in F.items():
            print(f'     ------ {f} ------')
            print(f)
            for line in lines:
                print("  ", line)

    if cmd == "update_cur":
        print(f'=========== {proj} ===========')
        for f, _ in F.items():
            print(f'     ------ {f} ------')
            url = ''
            for _ in re.findall('/', f[len(proj)+1:]):
                url += '../'
            url += url_name.decode('utf-8')
            print('  ', url)

    os.system("pause")
