#!/bin/bash

module load Singularity/3.6.4;

R_HOME=$( dirname $0 )
BABS_PROJECT_HOME=`readlink -f $PWD`
RENV_PATHS_ROOT=/camp/stp/babs/working/software/renv
ADDITIONAL_PATHS=/nemo/stp/babs/working/eastp/projects/downwardj/sophie.decarne/138_flow/experiments/cells/env/bin/python3.12,${PWD}:/project
CONDA_INSTALL_HOME=/camp/apps/eb/software/Anaconda3

RSERVER_CORES_DEFAULT=4
RSERVER_MEM_DEFAULT="50G"
RSERVER_TIME_DEFAULT="8:00:00"

TMP=/tmp
PYTHON_PATH=$( readlink -f ${PWD}/env/bin )

MOUNTS=${BABS_PROJECT_HOME},${RENV_PATHS_ROOT},${CONDA_INSTALL_HOME}
if [ ! -z "$ADDITIONAL_PATHS" ]; then
	MOUNTS=$MOUNTS,$ADDITIONAL_PATHS
fi

MOUNTS=${MOUNTS},${TMP}

export SINGULARITY_ENVS="BABS_PROJECT_HOME=${BABS_PROJECT_HOME},PREPEND_PATH=${PYTHON_PATH}"

singularity exec \
	--bind ${MOUNTS} \
	--pwd ${BABS_PROJECT_HOME} \
	--containall \
	--cleanenv \
	--env ${SINGULARITY_ENVS} \
	./rockerimage.sif quarto render $1 --profile=live
