import os
import re
import sys
import shutil

patt = r'(.*)->([^\r]*)'
patt = re.compile(patt.encode('utf-8'))

def mkdir(dir):
  try:
    os.makedirs(dir)
  except:
    pass

def _move(src, tgt):
  os.system(f'git mv "{src}" "{tgt}"')
  shutil.move(src, tgt)

if __name__ == "__main__":
  if len(sys.argv) != 2:
    os._exit(1)

  with open(sys.argv[1], 'rb') as f:
    lines = f.readlines()

  for line in lines:
    res = re.findall(patt, line)
    if not res:
      continue
    src = res[0][0].decode('utf-8')
    if not os.path.isfile(src):
      continue
    tgt = res[0][1].decode('utf-8')
    try:
      if not tgt:
        os.remove(src)
        continue
      elif tgt[-1] in '/\\':
        mkdir(tgt)
      else:
        mkdir(os.path.dirname(tgt))
      _move(src, tgt)
    except Exception as e:
      pass
