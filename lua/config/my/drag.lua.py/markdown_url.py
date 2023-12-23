import os
import sys


def rep(text):
    return text.replace("\\", "/").rstrip("/")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        os._exit(1)

    cmd = rep(sys.argv[1])
    proj = rep(sys.argv[2])
    url_name = "/".join(rep(sys.argv[3]).split("/")[-2:])
    exclude_md_name = sys.argv[4].split(",")
    include_md_ft = sys.argv[5].split(",")

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
            with open(file, "rb") as f:
                lines = f.readlines()
            for i in range(len(lines)):
                line = lines[i]
                if url_name not in line:
                    continue
                if file not in F:
                    F[file] = []
                F[file].append([i, line.strip().decode("utf-8")])

    if cmd == "show":
        for f, lines in F.items():
            print(f)
            for line in lines:
                print("  ", line)

    os.system("pause")
