import os
import re
import sys
import shutil

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
      if os.path.isfile(src):
        tgt = res[0][1].decode('utf-8')
        try:
          if not tgt:
            os.remove(src)
          elif tgt[-1] in '/\\':
            os.makedirs(tgt)
            shutil.move(src, tgt)
          else:
            parent = os.path.dirname(tgt)
            os.makedirs(parent)
            shutil.move(src, tgt)
        except Exception as e:
          pass

  os.system('pause')
