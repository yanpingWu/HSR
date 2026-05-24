# HSR

## Directory layout

```
HSR/
├── Makefile                 # builds all five algorithms
├── scripts/
│   └── run_exp1.sh          # one-command Exp-1 driver
├── algorithms/
│   ├── bbfs/                # BS-BiBFS
│   ├── asearch/             # BS-A*
│   ├── index/               # Index (writes Index_I_Exp1.txt — legacy filename)
│   ├── lvo_I/               # LVO-I
│   └── lvo_II/              # LVO-II
└── datasets/
    ├── bitcoin/
    ├── epinions/
    ├── slashdot/
    ├── wikiconflict/
    └── wikisign/
```

Each dataset folder ships exactly two files:

- `graph.txt`  — the signed graph (one edge per line: `source target sign`,
  with `sign ≥ 1` for a positive edge and `sign ≤ 0` for a negative edge).
- `query_exp1.txt` — the query workload used in Exp-1 of the paper
  (1000 queries; one per line: `source,target,sign`, where `sign = 1` is
  a positive-reachability query and `sign = 0` is a negative-reachability
  query).

## Build

A C++11-capable compiler is required (tested with `g++` ≥ 7).

```bash
make           # builds all five binaries
make clean     # removes them
```

The Makefile compiles with `-O3 -std=c++11`.

### Manual build (alternative to `make`)

If you prefer not to use `make`, run these five commands directly — they
are exactly what `make` invokes under the hood:

```bash
# BS-BiBFS
g++ -O3 -std=c++11 algorithms/bbfs/bbfs.cpp                   -o algorithms/bbfs/bbfs

# BS-A*
g++ -O3 -std=c++11 algorithms/asearch/asearch.cpp             -o algorithms/asearch/asearch

# Index
g++ -O3 -std=c++11 algorithms/index/SignedKReachability.cpp   -o algorithms/index/Index

# LVO-I
g++ -O3 -std=c++11 algorithms/lvo_I/SignedKReachability.cpp   -o algorithms/lvo_I/LVOI

# LVO-II
g++ -O3 -std=c++11 algorithms/lvo_II/SignedKReachability.cpp  -o algorithms/lvo_II/LVOII
```

## Reproduce Exp-1 (one command per dataset)

```bash
./scripts/run_exp1.sh <dataset> <k>
```

`<dataset>` is one of `bitcoin | epinions | slashdot | wikiconflict | wikisign`
and `<k>` is the hop limit (a positive integer). Each algorithm reads the
1000 queries in `datasets/<dataset>/query_exp1.txt` and **appends** its
per-run summary to `datasets/<dataset>/<ALGO>_Exp1.txt`:

| Algorithm | Output file (under `datasets/<dataset>/`) |
|-----------|--------------------------------------------|
| BS-BiBFS  | `BBFS_Exp1.txt`                            |
| BS-A*     | `Asearch_Exp1.txt`                         |
| Index     | `Index_I_Exp1.txt`                         |
| LVO-I     | `LVO_I_Exp1.txt`                           |
| LVO-II    | `LVO_II_Exp1.txt`                          |

Examples:

```bash
make
./scripts/run_exp1.sh bitcoin       6
./scripts/run_exp1.sh epinions      6
./scripts/run_exp1.sh slashdot      6
./scripts/run_exp1.sh wikiconflict  6
./scripts/run_exp1.sh wikisign      6
```

The output files are opened in append mode, so re-running the same
(dataset, k) pair leaves earlier results in place — delete the
`*_Exp1.txt` file first if you want a clean slate.

## Run a single algorithm manually

The driver script just shells out to the per-algorithm binaries. The
two baselines and the three indexed algorithms take slightly different
arguments because they were developed independently.

```bash
# BS-BiBFS (online baseline)
./algorithms/bbfs/bbfs        <dataset_dir> <k>

# BS-A* baseline
./algorithms/asearch/asearch  <dataset_dir> <k>

# Index
./algorithms/index/Index      <dataset_dir> index  <k> 1000

# LVO-I
./algorithms/lvo_I/LVOI       <dataset_dir> online <k> 1000

# LVO-II
./algorithms/lvo_II/LVOII     <dataset_dir> online <k> 1000
```

`<dataset_dir>` is a path such as `datasets/bitcoin`. All five binaries
read `query_exp1.txt` from that directory. The trailing `1000` on the
indexed binaries is the number of queries consumed; `query_exp1.txt`
contains exactly 1000 queries.

## Per-algorithm examples

Each block below shows how to build one algorithm and immediately run it
on the `bitcoin` dataset with `k=6` over the 1000 queries in
`query_exp1.txt`.

```bash
# Build the BS-BiBFS executable
g++ -O3 -std=c++11 algorithms/bbfs/bbfs.cpp -o algorithms/bbfs/bbfs
# Run BS-BiBFS on the bitcoin dataset, reading query_exp1.txt with k=6 (1000 queries)
./algorithms/bbfs/bbfs datasets/bitcoin 6

# Build the BS-A* executable
g++ -O3 -std=c++11 algorithms/asearch/asearch.cpp -o algorithms/asearch/asearch
# Run BS-A* on the bitcoin dataset, reading query_exp1.txt with k=6 (1000 queries)
./algorithms/asearch/asearch datasets/bitcoin 6

# Build the Index executable
g++ -O3 -std=c++11 algorithms/index/SignedKReachability.cpp -o algorithms/index/Index
# Run Index on the bitcoin dataset, reading query_exp1.txt with k=6 (1000 queries)
./algorithms/index/Index datasets/bitcoin index 6 1000

# Build the LVO-I executable
g++ -O3 -std=c++11 algorithms/lvo_I/SignedKReachability.cpp -o algorithms/lvo_I/LVOI
# Run LVO-I on the bitcoin dataset, reading query_exp1.txt with k=6 (1000 queries)
./algorithms/lvo_I/LVOI datasets/bitcoin online 6 1000

# Build the LVO-II executable
g++ -O3 -std=c++11 algorithms/lvo_II/SignedKReachability.cpp -o algorithms/lvo_II/LVOII
# Run LVO-II on the bitcoin dataset, reading query_exp1.txt with k=6 (1000 queries)
./algorithms/lvo_II/LVOII datasets/bitcoin online 6 1000
```
