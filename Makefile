MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:
.PHONY: create-ebook

# Directories
DOWNLOAD_DIR ?= download
OUTPUT_DIR ?= output

# URLs
GER_VIE_DICT_URL ?= https://www.informatik.uni-leipzig.de/~duc/Dict/DucViet.zip
VIE_GER_DICT_URL ?= https://www.informatik.uni-leipzig.de/~duc/Dict/VietDuc.zip

download:
	# Download the raw dictionary data
	mkdir -p $(DOWNLOAD_DIR)
	curl -L -o $(DOWNLOAD_DIR)/viet-duc.zip $(VIE_GER_DICT_URL)
	curl -L -o $(DOWNLOAD_DIR)/duc-viet.zip $(GER_VIE_DICT_URL)

# stardicttools (for stardict2txt)
unzip: download
	# Unzip the raw dictionary data
	unzip -o $(DOWNLOAD_DIR)/viet-duc.zip -d $(DOWNLOAD_DIR)
	unzip -o $(DOWNLOAD_DIR)/duc-viet.zip -d $(DOWNLOAD_DIR)

	# Unzip the compressed dictionary data
	dictzip -d $(DOWNLOAD_DIR)/data/GV/dv45K.dict.dz
	dictzip -d $(DOWNLOAD_DIR)/data/GV/vd12K.dict.dz

	# Move the dictionary data to the download directory
	mv $(DOWNLOAD_DIR)/data/GV/dv45K.dict $(DOWNLOAD_DIR)
	mv $(DOWNLOAD_DIR)/data/GV/dv45K.index $(DOWNLOAD_DIR)
	mv $(DOWNLOAD_DIR)/data/GV/vd12K.dict $(DOWNLOAD_DIR)
	mv $(DOWNLOAD_DIR)/data/GV/vd12K.index $(DOWNLOAD_DIR)

	# Remove the temporary data
	rm -r $(DOWNLOAD_DIR)/data
	rm $(DOWNLOAD_DIR)/*.zip

prepare-ebook:
	# Prepare the ebook
	deno run --unstable --allow-read --allow-write scripts/prepare-books.ts

create-ebook:
	# Create ZIP version of ebooks
	zip -r $(OUTPUT_DIR)/devn.zip -j $(OUTPUT_DIR)/devn/*
	zip -r $(OUTPUT_DIR)/vnde.zip -j $(OUTPUT_DIR)/vnde/*

	# Create mobi ebooks
	scripts/create-ebook $(shell pwd)/$(OUTPUT_DIR)/devn.zip mobi
	scripts/create-ebook $(shell pwd)/$(OUTPUT_DIR)/vnde.zip mobi
