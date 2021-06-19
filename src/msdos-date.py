#!/usr/bin/env python3

# MS-DOS date: https://docs.microsoft.com/en-gb/windows/win32/api/winbase/nf-winbase-dosdatetimetofiletime?redirectedfrom=MSDN

import argparse
import time
from datetime import datetime

def main():
  parser = argparse.ArgumentParser(description='transform a date/time from ISO standard to MS-DOS binary format')
  parser.add_argument('--mode', choices=['time', 'date'], required=True)
  parser.add_argument('--thing', required=True)
  args = parser.parse_args()

  if args.mode == 'time':
    parsed = time.strptime(args.thing, '%H:%M:%S')

    high = 0
    high |= (parsed.tm_hour & 0b0001_1111) << 3
    high |= (parsed.tm_min & 0b0011_1000) >> 3

    low = 0
    low |= (parsed.tm_min & 0b0000_0111) << 3
    low |= int(parsed.tm_sec / 2) & 0b0001_1111

    res = (high << 8) | low
    print((f'{res:#x}'))

  elif args.mode == 'date':
    parsed = datetime.strptime(args.thing, '%Y-%m-%d')

    high = 0
    high |= ((parsed.year - 1980) & 0b0111_1111) << 1
    high |= (parsed.month & 0b1000) >> 3

    low = 0
    low |= (parsed.month & 0b0111) << 5
    low |= parsed.day & 0b0001_1111

    res = (high << 8) | low
    print((f'{res:#x}'))

  else:
    raise ValueError(f'unknown mode: {args.mode}')


if __name__ == '__main__':
  main()
