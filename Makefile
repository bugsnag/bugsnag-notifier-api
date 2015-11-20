all: generate

output.html: notifier.apib
	@aglio -i notifier.apib --theme-variables flatly -o output.html

.PHONY:

bootstrap:
	@npm install -g aglio

generate: output.html

run: output.html
	@open output.html

