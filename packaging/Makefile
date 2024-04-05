# run this makefile from graph2strat/packaging/deb

BUILD_DIR := $$(readlink -f ..)/_build/packaging/deb/

deb: placefiles_deb docker_deb
	@echo "Finalising deb package"
	docker run --rm -v $(BUILD_DIR):/package:z g2s_build_deb

placefiles_deb: directory static_build
	@echo "Copying files to $(BUILD_DIR)"
	
	cp deb/control $(BUILD_DIR)/graph2strat-static/DEBIAN/
	chmod 0644 $(BUILD_DIR)/graph2strat-static/DEBIAN/control
	
	cp ../LICENSE $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/copyright
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/copyright

	cp deb/changelog $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static
	gzip -f --best -n $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/changelog
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/changelog.gz

	cp ../docs/manpages/g2s.1 $(BUILD_DIR)/graph2strat-static/usr/share/man/man1/
	cp ../docs/manpages/g2sdot.5 $(BUILD_DIR)/graph2strat-static/usr/share/man/man5/
	cp ../docs/manpages/g2spython.7 $(BUILD_DIR)/graph2strat-static/usr/share/man/man7/
	gzip -f --best -n $(BUILD_DIR)/graph2strat-static/usr/share/man/man1/g2s.1
	gzip -f --best -n $(BUILD_DIR)/graph2strat-static/usr/share/man/man5/g2sdot.5
	gzip -f --best -n $(BUILD_DIR)/graph2strat-static/usr/share/man/man7/g2spython.7
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/share/man/man1/g2s.1.gz
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/share/man/man5/g2sdot.5.gz
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/share/man/man7/g2spython.7.gz

	cp ../_build/default/bin/g2s $(BUILD_DIR)/graph2strat-static/usr/bin/g2s
	chmod 0644 $(BUILD_DIR)/graph2strat-static/usr/bin/g2s

directory:
	@echo "Creating directory $(BUILD_DIR)"

	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/bin
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man1
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man5
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man7
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/DEBIAN

docker_opam:
	@echo "Building opam build container"
	docker build .. -t g2s_build_opam

docker_deb:
	@echo "Building deb package container"
	docker build deb -t g2s_build_deb

static_build: docker_opam
	@echo "Compiling in alpine container using dune"
	docker run --rm --user 1000:1000 -v $$(readlink -f ..):/home/opam/graph2strat:z g2s_build_opam
	cp ../_build/default/bin/main.exe ../_build/default/bin/g2s
