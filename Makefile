PREFIX ?= $(HOME)/.local
BIN_DIR := $(PREFIX)/bin
SYSTEMD_DIR := $(HOME)/.config/systemd/user

SCRIPT_SRC := ./bin/media-broadcast
SCRIPT_DST := $(BIN_DIR)/media-broadcast

SERVICE_SRC := ./systemd/media-broadcast.service
SERVICE_DST := $(SYSTEMD_DIR)/media-broadcast.service

SERVICE_NAME := media-broadcast.service

.PHONY: install uninstall

install:
	install -Dm755 $(SCRIPT_SRC) $(SCRIPT_DST)
	install -Dm644 $(SERVICE_SRC) $(SERVICE_DST)
	systemctl --user daemon-reload
	systemctl --user enable --now $(SERVICE_NAME)

uninstall:
	systemctl --user disable --now $(SERVICE_NAME) || true
	rm -f $(SCRIPT_DST)
	rm -f $(SERVICE_DST)
	systemctl --user daemon-reload