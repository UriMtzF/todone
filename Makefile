.PHONY: slang-missing slang-generate

# Target to analyze missing translations
slang-missing:
	dart run slang analyze

# Target to generate and analyze translations
slang-generate:
	dart run slang apply
	dart run slang
	dart run slang analyze
