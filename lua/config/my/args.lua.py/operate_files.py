import os
import re
import sys

patt = r'(.*)->([^\r]*)'
patt = re.compile(patt.encode('utf-8'))

if __name__ == "__main__":
  if len(sys.argv) != 2:
    os._exit(1)

  with open(sys.argv[1], 'rb') as f:
    lines = f.readlines()

  for line in lines:
    res = re.findall(patt, line)
    if res:
      src = res[0][0].decode('utf-8')
      tgt = res[0][1].decode('utf-8')
      print(src, '->', tgt)

  os.system('pause')
