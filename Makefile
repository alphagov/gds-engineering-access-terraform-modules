docs:
	@find * -type f -iname '*.tf' -maxdepth 2 -exec dirname {} \; | sort -u | while read -r dir; do \
		echo "--> Generating documentation for $${dir}"; \
		terraform-docs $$dir; \
	done
.PHONY: docs
