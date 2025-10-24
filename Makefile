# ================================
# Makefile: Lucio API Automation
# Author: Sai Kumar Mojjada
# ================================

NAME = Sai Kumar Mojjada
EMAIL = saikumarmsk7799@gmail.com
CLUB = lucio
DATE = $(shell date +"%Y-%m-%d %H:%M:%S")
TOKEN_FILE = token.txt
LOG_FILE = logs/output.json

define hash_values
$(eval RAW_INPUT := $(NAME)|$(EMAIL)|$(DATE)|$(CLUB))
$(eval HASH_HEX := $(shell echo -n "$(RAW_INPUT)" | sha256sum | awk '{print $$1}'))
$(eval HASH_B64 := $(shell echo -n "$(RAW_INPUT)" | sha256sum | xxd -r -p | base64 | tr '+/' '-_' | tr -d '='))
endef

all: run

begin:
	@echo "🔹 Sending /begin request..."
	@mkdir -p logs
	@curl -s -X POST https://workwithus.lucioai.com/begin \
		-H "Content-Type: application/json" \
		-d '{"name":"$(NAME)","email":"$(EMAIL)"}' \
		| jq -r '.token' > $(TOKEN_FILE)
	@echo "✅ Token saved to $(TOKEN_FILE)"

get-carded:
	$(call hash_values)
	@echo "🔹 Computing SHA256 hash..."
	@echo "   Input: $(RAW_INPUT)"
	@echo "   Hex: $(HASH_HEX)"
	@echo "   Base64: $(HASH_B64)"
	@echo "🔹 Sending /get-carded request..."
	@curl -s -X POST https://workwithus.lucioai.com/get-carded \
		-H "Authorization: Bearer $(shell cat $(TOKEN_FILE))" \
		-H "Content-Type: application/json" \
		-H "X-Stamp: $(HASH_B64)" \
		-H "X-Access-Code: $(HASH_HEX)" \
		-d '{"name":"$(NAME)","email":"$(EMAIL)"}' | tee $(LOG_FILE)

find-bar:
	@echo "🔹 Checking /find-the-bar..."
	@curl -s -X GET https://workwithus.lucioai.com/find-the-bar | tee -a $(LOG_FILE)

run: begin get-carded find-bar
	@echo "🎉 Pipeline completed. Logs stored in $(LOG_FILE)"

