#!python3

from bson import ObjectId
from datetime import datetime
import sys

default = datetime.now().strftime('%Y%m%d000000')

date = sys.argv[1]
date = date + default[len(date):]

print(ObjectId.from_datetime(datetime.strptime(date, '%Y%m%d%H%M%S')))
