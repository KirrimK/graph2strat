# run this makefile from graph2strat/packaging/deb

BUILD_DIR := $$(readlink -f ..)/_build/packaging/deb/


deb: $(BUILD_DIR)/graph2strat-static.deb

$(BUILD_DIR)/graph2strat-static.deb: placefiles_deb docker_deb
	docker run --rm -v $(BUILD_DIR):/package:z g2s_build_deb

placefiles_deb: $(BUILD_DIR)/DEBIAN/control

$(BUILD_DIR)/DEBIAN/control: $(BUILD_DIR)/graph2strat-static static_build
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

$(BUILD_DIR)/graph2strat-static:
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/bin
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/doc/graph2strat-static/
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man1
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man5
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/usr/share/man/man7
	mkdir -m 0755 -p $(BUILD_DIR)/graph2strat-static/DEBIAN

docker_opam: ../_build/.built_opam_container

../_build/.built_opam_container: ../Dockerfile
	docker build .. -t g2s_build_opam
	@touch ../_build/.built_opam_container

docker_deb: ../_build/.built_deb_container

../_build/.built_deb_container: deb/Dockerfile
	docker build deb -t g2s_build_deb
	@touch ../_build/.built_deb_container

static_build: ../_build/default/bin/g2s

../_build/default/bin/g2s: docker_opam
	docker run --rm --user 1000:1000 -v $$(readlink -f ..):/home/opam/graph2strat:z g2s_build_opam
	cp ../_build/default/bin/main.exe ../_build/default/bin/g2s

clean:
	rm -rf ../_build
