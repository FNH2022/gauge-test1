download() {
  for file in $@; do
    # Verify the file exists
    response="$(curl -Lso /dev/null -w "%{http_code}" \
      "${TEST_DATA_URL}/${file}")"
    if [[ "${response}" = "200" ]]; then
      echo "DOWNLOAD: ${file}"
      # Handle subdirectories in the file path (such as pipeline files)
      if [[ "${file}" == *"/"* ]]; then
        subdir="$(dirname "${file}")"
        mkdir -p "${TEST_DATA_DIR}/${subdir}"
        (cd "${TEST_DATA_DIR}/${subdir}" && curl -OL "${TEST_DATA_URL}/${file}")
      else
        (cd "${TEST_DATA_DIR}" && curl -OL "${TEST_DATA_URL}/${file}")
      fi
    else
      echo "NOT FOUND: ${file}"
    fi
  done
}
function main() {

  download \
    "ssd_mobilenet_v2_coco_quant_postprocess_edgetpu.tflite" \
    "coco_labels.txt" \
    "grace_hopper.bmp"

}
