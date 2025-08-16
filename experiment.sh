#!/bin/bash

source /venv/bin/activate
source /opt/intel/oneapi/setvars.sh

export LC_ALL=C

REPS=10
PD=45

OPT_HW_PREF_CONFIG="--disable-l1-nlp --disable-l2-amp"
OPT_HW_PREF_CONFIG_SPMM="--disable-l1-nlp"

python kernel_on_suitesparse.py --re-use -c all --kernel spmv -1gb --rep-file no-opt-default.json -o no-opt --matrix-format csr benchmark --repetitions $REPS
python kernel_on_suitesparse.py --re-use -c all --kernel spmv -1gb $OPT_HW_PREF_CONFIG --rep-file no-opt.json -o no-opt --matrix-format csr benchmark --repetitions $REPS

python kernel_on_suitesparse.py --re-use -c all --kernel spmv -o pref-mlir -pd $PD -1gb --matrix-format csr --rep-file ./asap-default.json benchmark --repetitions $REPS
python kernel_on_suitesparse.py --re-use -c all --kernel spmv -o pref-mlir -pd $PD -1gb $OPT_HW_PREF_CONFIG --matrix-format csr --rep-file ./asap.json benchmark --repetitions $REPS

python kernel_on_suitesparse.py --re-use -c all --kernel spmv -o pref-ains -pd $PD -1gb --matrix-format csr --rep-file ./aj-default.json benchmark --repetitions $REPS
python kernel_on_suitesparse.py --re-use -c all --kernel spmv -o pref-ains -pd $PD -1gb $OPT_HW_PREF_CONFIG --matrix-format csr --rep-file ./aj.json benchmark --repetitions $REPS

python kernel_on_suitesparse.py --re-use -c spmm --kernel spmm -1gb --rep-file no-opt-spmm-default.json -o no-opt --matrix-format csr benchmark --repetitions $REPS
python kernel_on_suitesparse.py --re-use -c spmm --kernel spmm -1gb $OPT_HW_PREF_CONFIG_SPMM --rep-file no-opt-spmm.json -o no-opt --matrix-format csr benchmark --repetitions $REPS

python kernel_on_suitesparse.py --re-use -c spmm --kernel spmm -o pref-mlir -pd $PD -1gb --matrix-format csr --rep-file ./asap-spmm-default.json benchmark --repetitions $REPS
python kernel_on_suitesparse.py --re-use -c spmm --kernel spmm -o pref-mlir -pd $PD -1gb $OPT_HW_PREF_CONFIG_SPMM --matrix-format csr --rep-file ./asap-spmm.json benchmark --repetitions $REPS
