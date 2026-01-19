#!/usr/bin/env python3
import os, glob, csv, argparse
import numpy as np
import matplotlib.pyplot as plt

def read_csv(path):
    t, y = [], []
    with open(path) as f:
        r = csv.DictReader(f)
        for row in r:
            t.append(int(row["timestamp"]))
            y.append(int(row["cumulative_edges"]))
    t = np.array(t, dtype=float)
    y = np.array(y, dtype=float)
    order = np.argsort(t)
    t = t[order]
    y = y[order]
    t -= t[0]           # normalize to 0
    return t, y

def step_interp(t, y, tg):
    idx = np.searchsorted(t, tg, side="right") - 1
    idx = np.clip(idx, 0, len(y)-1)
    return y[idx]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", nargs="?", default=".")
    ap.add_argument("--outdir", default="total")
    args = ap.parse_args()

    paths = sorted(glob.glob(os.path.join(args.root, "*", "coverage.csv")))
    print(f"curr={os.getcwd()}, paths={paths}, root={args.root}")

    if not paths:
        raise SystemExit("no coverage.csv found")

    runs = [read_csv(p) for p in paths]

    # unified grid = union of all normalized timestamps
    grid = np.unique(np.concatenate([t for t,_ in runs]))

    Y = np.vstack([step_interp(t, y, grid) for t,y in runs])

    y_min = Y.min(axis=0)
    y_max = Y.max(axis=0)
    y_avg = Y.mean(axis=0)
    y_med = np.median(Y, axis=0)

    os.makedirs(args.outdir, exist_ok=True)
    out_csv = os.path.join(args.outdir, "coverage_total.csv")
    out_png = os.path.join(args.outdir, "coverage_total.png")

    with open(out_csv, "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["t_s","avg","min","max","median"])
        for i in range(len(grid)):
            w.writerow([grid[i], y_avg[i], y_min[i], y_max[i], y_med[i]])

    plt.figure()
    plt.title("5GBaseChecker Coverage")
    plt.fill_between(grid, y_min, y_max, alpha=0.2)
    plt.plot(grid, y_avg, label="avg")
    #plt.plot(grid, y_med, label="median")
    plt.xlabel("time since start (s)")
    plt.ylabel("cumulative edges")
    plt.legend()
    plt.tight_layout()
    plt.savefig(out_png, dpi=140)

if __name__ == "__main__":
    main()

