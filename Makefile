.PHONY: check format format-check lint test launcher-icon release-android release-web

LIB_DIR = lib/
TEST_DIR = test/

check: format-check lint test

format:
	@echo ">>> Flutter format"
	flutter format $(LIB_DIR) $(TEST_DIR)

format-check:
	@echo ">>> Check Dart format"
	flutter format --set-exit-if-changed $(LIB_DIR) $(TEST_DIR)

lint:
	@echo ">>> Flutter analyze"
	flutter analyze $(LIB_DIR) $(TEST_DIR)

test:
	@echo ">>> Flutter test"
	flutter test $(TEST_DIR)

release-android:
	@echo ">>> [Android] Flutter build release"
	flutter build appbundle
	@echo ">>> [Android] Fastlane upload to Play Store"
	cd android && bundle exec fastlane alpha

release-web:
	@echo ">>> [Web] Flutter build release"
	flutter build web
