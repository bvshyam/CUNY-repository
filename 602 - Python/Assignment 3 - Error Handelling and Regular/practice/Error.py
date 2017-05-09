f = open("C:\\Users\\Shyam\\Downloads\\music.mp3", "rb")
# print(f.name)
# print(f.seek(-128,2))
# print(f.tell())
tagData = f.read(128)
# print(tagData)
# print(f.tell())

import os
import sys
#for k, v in os.environ.items():
# print "%s=%s" %  (k,v)

print "\n".join(["%s=%s" % (k, v) for k, v in os.environ.items()])



print(sys.modules["os"])
