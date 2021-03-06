#!/bin/bash

set -e

SPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $SPATH/init

MODELP="${RESULTD}/wt10/model"

LOGP="${RESULTD}/wt10/test/log"
SCOREP="${RESULTD}/wt10/test/score"
RUNP="${RESULTD}/wt10/test/run"
EVALP="${RESULTD}/wt10/test/eval"
CACHEP="${SCRATCHD}/.cache"
QRELSF=${QRELD}/10.qrels.adhoc

mkdir -p $LOGP $SCOREP $RUNP $EVALP

name=ndcg@10.20.lambdarank.gbdt.lr0.1.le16.colsamp1.0.estop40.maxpos30.mdleaf100.sigmoid1.0
te=$DATASETD/10.test.svm

$SPATH/lgb_evaluate.py \
  --log_dir $LOGP \
  --score_dir $SCOREP \
  --cache_name $CACHEP \
  $te \
  $MODELP/${name}.pkl

$SPATH/score_svm2run.sh $te $SCOREP/${name}.txt > $RUNP/${name}.run
$SPATH/eval.sh $QRELSF $RUNP/${name}.run > $EVALP/${name}.txt
echo $name
cat $EVALP/${name}.txt
