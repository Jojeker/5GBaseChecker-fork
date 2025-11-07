#!/usr/bin/env python3
import argparse, os, re, sys, csv
from datetime import datetime
import matplotlib.pyplot as plt

pat = re.compile(r"afl_cov_(\d+)_(\d+)\.bin$")

def count_edges(data: bytes) -> int:
    # number of non-zero bytes
    return sum(1 for b in data if b)

def sum_hits(data: bytes) -> int:
    # total of the 8-bit counters
    return sum(data)

def main():
    ap = argparse.ArgumentParser(description="Build coverage graph from afl_cov_{TS}_{PID}.bin files")
    ap.add_argument("dir", nargs="?", default=".", help="directory containing afl_cov_*_*.bin files")
    ap.add_argument("--metric", choices=["edges","hits"], default="edges",
                    help="edges = non-zero byte count (default); hits = sum of 8-bit counters")
    ap.add_argument("--png", default="coverage.png", help="output PNG filename")
    ap.add_argument("--csv", default="coverage.csv", help="output CSV filename")
    args = ap.parse_args()

    files = []
    for name in os.listdir(args.dir):
        m = pat.match(name)
        if not m:
            continue
        ts = int(m.group(1))
        pid = int(m.group(2))
        path = os.path.join(args.dir, name)
        try:
            sz = os.path.getsize(path)
        except OSError:
            continue
        files.append((ts, pid, path, sz))

    if not files:
        print("No files matching afl_cov_{TS}_{PID}.bin found", file=sys.stderr)
        sys.exit(1)

    # sort by timestamp then pid for stability
    files.sort(key=lambda x: (x[0], x[1]))

    # map size from the largest file
    map_size = max(sz for _,_,_,sz in files)

    # error out if we have different sizes (invariant)
    for _,_,_,sz in files:
        if sz != map_size:
            print(f"We have different map sizes! {sz} and {map_size}")
            sys.exit(1)

    # cumulative bitmap for "edges" metric
    cumul = bytearray(map_size)
    cumul_count = 0

    rows = []
    for ts, pid, path, sz in files:
        with open(path, "rb") as f:
            data = f.read()

        if args.metric == "edges":
            # per-file edge count
            edges = count_edges(data)
            # update cumulative set
            # iterate once, add newly discovered edges
            added = 0
            # speed: use memoryview to avoid creating ints for every byte
            mv_data = memoryview(data)
            mv_cumul = memoryview(cumul)
            for i in range(map_size):
                if mv_data[i] and mv_cumul[i] == 0:
                    mv_cumul[i] = 1
                    added += 1
            cumul_count += added
            metric_value = edges
        else:
            # hits metric does not change cumulative; use cumulative "edges" as a secondary track
            metric_value = sum_hits(data)
            # still maintain cumulative edges for plotting meaningful graph over time
            added = 0
            mv_data = memoryview(data)
            mv_cumul = memoryview(cumul)
            for i in range(map_size):
                if mv_data[i] and mv_cumul[i] == 0:
                    mv_cumul[i] = 1
                    added += 1
            cumul_count += added

        rows.append({
            "timestamp": ts,
            "datetime": datetime.utcfromtimestamp(ts).isoformat() + "Z",
            "pid": pid,
            args.metric: metric_value,
            "cumulative_edges": cumul_count
        })

    # write CSV
    with open(args.csv, "w", newline="") as cf:
        w = csv.DictWriter(cf, fieldnames=["timestamp","datetime","pid",args.metric,"cumulative_edges"])
        w.writeheader()
        for r in rows:
            w.writerow(r)

    # plot cumulative edges over time
    x = [datetime.utcfromtimestamp(r["timestamp"]) for r in rows]
    y = [r["cumulative_edges"] for r in rows]

    plt.figure()
    plt.step(x, y, where="post")
    plt.xlabel("time (UTC)")
    plt.ylabel("cumulative unique edges")
    plt.title("Coverage over time")
    plt.gcf().autofmt_xdate()
    plt.tight_layout()
    plt.savefig(args.png, dpi=120)
    print(f"Wrote {args.csv} and {args.png}. Map size assumed: {map_size} bytes. Files: {len(rows)}")

if __name__ == "__main__":
    main()

