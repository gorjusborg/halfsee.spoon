SPOON_NAME = Halfsee
BUILD_DIR = build
SPOON_DIR = ${SPOON_NAME}.spoon
ZIP_FILE = ${SPOON_DIR}.zip

.PHONY: clean

all: ${ZIP_FILE}

${SPOON_DIR}:
	mkdir -p ${BUILD_DIR}/${SPOON_DIR}

${ZIP_FILE}: ${SPOON_DIR}
	cp init.lua ${BUILD_DIR}/${SPOON_DIR}/
	cp README.md ${BUILD_DIR}/${SPOON_DIR}/
	cd ${BUILD_DIR} && zip -r ${ZIP_FILE} ${SPOON_DIR}

clean:
	rm -r ${BUILD_DIR}

