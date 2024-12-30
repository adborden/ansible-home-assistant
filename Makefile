.PHONY: setup

setup:
	pipenv install
	pipenv run ansible-galaxy install -r requirements.yaml
