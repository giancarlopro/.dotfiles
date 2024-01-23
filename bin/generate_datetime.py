#!python3

import sys
from datetime import datetime

default = datetime.now().strftime("%Y%m%d000000")

date = sys.argv[1]
date = date + default[len(date) :]

print(datetime.strptime(date, "%Y%m%d%H%M%S").strftime("%Y-%m-%dT%H:%M:%SZ"))
