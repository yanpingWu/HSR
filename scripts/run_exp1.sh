#!/bin/bash
# Reproduce Exp-1: run all 5 algorithms on one dataset with the given k value.
#
# Usage:   ./scripts/run_exp1.sh <dataset> <k>
# Example: ./scripts/run_exp1.sh bitcoin 8
#
# Each algorithm reads <dataset>/query_exp1.txt (1000 queries) and APPENDS
# its timing/answer summary to <dataset>/<ALGO>_Exp1.txt.

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <dataset> <k>"
    echo "  <dataset>: bitcoin | epinions | slashdot | wikiconflict | wikisign"
    echo "  <k>:       hop limit (integer)"
    exit 1
fi

DATASET=$1
K=$2
QUERY_COUNT=1000

ROOT=$(cd "$(dirname "$0")/.." && pwd)
DATASET_DIR="$ROOT/datasets/$DATASET"

if [ ! -d "$DATASET_DIR" ]; then
    echo "Dataset directory not found: $DATASET_DIR"
    exit 1
fi

echo "===== Exp-1: dataset=$DATASET, k=$K, queries=$QUERY_COUNT ====="

echo
echo "--- [1/5] BBFS (online baseline) ---"
"$ROOT/algorithms/bbfs/bbfs" "$DATASET_DIR" "$K"

echo
echo "--- [2/5] A* search ---"
"$ROOT/algorithms/asearch/asearch" "$DATASET_DIR" "$K"

echo
echo "--- [3/5] Index ---"
"$ROOT/algorithms/index/Index" "$DATASET_DIR" index "$K" "$QUERY_COUNT"

echo
echo "--- [4/5] LVO-I ---"
"$ROOT/algorithms/lvo_I/LVOI" "$DATASET_DIR" online "$K" "$QUERY_COUNT"

echo
echo "--- [5/5] LVO-II ---"
"$ROOT/algorithms/lvo_II/LVOII" "$DATASET_DIR" online "$K" "$QUERY_COUNT"

echo
echo "===== Done. Per-algorithm summaries appended to: ====="
echo "  $DATASET_DIR/BBFS_Exp1.txt"
echo "  $DATASET_DIR/Asearch_Exp1.txt"
echo "  $DATASET_DIR/Index_I_Exp1.txt"
echo "  $DATASET_DIR/LVO_I_Exp1.txt"
echo "  $DATASET_DIR/LVO_II_Exp1.txt"
