# Makefile for running the QA Framework

PYTHON = python3

QA_TOOLBOX_DIR = qa-toolbox


all : run_tests build_documentation

run_tests :
	@echo run_tests
	@if [ -d $(QA_TOOLBOX_DIR) ]; then \
		echo Executing QA Framework Makefile; \
		$(MAKE) --directory=$(QA_TOOLBOX_DIR) DOC_DIR=${PWD}/docs/source all; \
		echo QA Framework Makefile done; \
	else \
		echo Directory $(QA_TOOLBOX_DIR) not found; \
	fi

build_documentation :
	@echo build_documentation
