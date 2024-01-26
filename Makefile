.PHONY: all init validate inspect build help

PACKER_TEMPLATE_DIR := packer/centos8  # Replace with the actual path to your Packer template directory

all: init validate inspect build

init:
	@echo "Initializing Packer..."
	cd $(PACKER_TEMPLATE_DIR) && packer init .

validate:
	@echo "Validating Packer configuration..."
	cd $(PACKER_TEMPLATE_DIR) && packer validate .

inspect:
	@echo "Inspecting Packer configuration..."
	cd $(PACKER_TEMPLATE_DIR) && packer inspect .

build:
	@echo "Building custom workstation centos8-Stream image..."
	cd $(PACKER_TEMPLATE_DIR) && packer build .

build-debug:
	@echo "Building custom Linux machine image in debug mode..."
	cd $(PACKER_TEMPLATE_DIR) && packer build -debug .	


help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  init      - Initialize Packer"
	@echo "  validate  - Validate the Packer configuration"
	@echo "  inspect   - Inspect the Packer configuration"
	@echo "  build     - Build the custom Linux machine image"
	@echo "  help      - Display this help message"
