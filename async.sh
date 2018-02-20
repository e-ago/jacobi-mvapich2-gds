#!/bin/bash


function run() {
    local A=$1
    local B=$2
    local C=$3
    local D=$4
    local NP=$5
    local FL=$6
    local COMM=$7
    local ASYNC=$8
    local KI=$9
    shift 9
    local PAR=$@
    ( date; \
        echo; echo; \
        set -x; \
        ../../scripts/run.sh  -n $NP \
        -x MP_ENABLE_DEBUG=1 \
        -x COMM_ENABLE_DEBUG=1 \
        -x GDS_ENABLE_DEBUG=1 \
        -x MLX5_DEBUG_MASK=0 \
        -x ENABLE_DEBUG_MSG=0 \
        \
        -x MP_DBREC_ON_GPU=0 \
        -x MP_RX_CQ_ON_GPU=0 \
        -x MP_TX_CQ_ON_GPU=0 \
        \
        -x MP_EVENT_ASYNC=0 \
        -x MP_GUARD_PROGRESS=0 \
        \
        -x GDS_DISABLE_WRITE64=0           \
        -x GDS_SIMULATE_WRITE64=$A         \
        -x GDS_DISABLE_INLINECOPY=$B       \
        -x GDS_DISABLE_WEAK_CONSISTENCY=$C \
        -x GDS_DISABLE_MEMBAR=$D           \
        -x MLX5_FREEZE_ON_ERROR_CQE=0 \
	-x GPU_ENABLE_DEBUG=0 \
	-x GDRCOPY_ENABLE_LOGGING=1 \
	-x GDRCOPY_LOG_LEVEL=1 \
        -x GDS_FLUSHER_TYPE=$FL \
        -x COMM_USE_COMM=$COMM  -x COMM_USE_ASYNC=$ASYNC -x COMM_USE_GPU_COMM=$KI \
	../../scripts/wrapper.sh ./jacobi $PAR ) 2>&1 | tee -a gpp.log

}

common=""

# inlcopy seems to be worse if S==1024, better if S==0
run 0 1 1 1 $@