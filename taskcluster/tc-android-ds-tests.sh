#!/bin/bash

set -xe

arm_flavor=$1
api_level=$2

source $(dirname "$0")/tc-tests-utils.sh

bitrate=$3
set_ldc_sample_filename "${bitrate}"

model_source=${DEEPSPEECH_TEST_MODEL//.pb/.tflite}
model_name=$(basename "${model_source}")
export DATA_TMP_DIR=${ANDROID_TMP_DIR}/ds

if [ "${arm_flavor}" = "armeabi-v7a" ]; then
    export DEEPSPEECH_ARTIFACTS_ROOT=${DEEPSPEECH_ARTIFACTS_ROOT_ARMV7}
fi

if [ "${arm_flavor}" = "arm64-v8a" ]; then
    export DEEPSPEECH_ARTIFACTS_ROOT=${DEEPSPEECH_ARTIFACTS_ROOT_ARM64}
fi

download_material "${TASKCLUSTER_TMP_DIR}/ds"

android_start_emulator "${arm_flavor}" "${api_level}"

android_setup_ndk_data

run_tflite_basic_inference_tests

run_android_hotword_tests

android_stop_emulator
