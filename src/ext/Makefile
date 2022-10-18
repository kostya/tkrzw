VERSION := 1.0.24

.PHONY: package
package: ./tkrzw-c/libtkrzw.a

./tkrzw-c:
	wget https://dbmx.net/tkrzw/pkg/tkrzw-$(VERSION).tar.gz
	tar -xzvf tkrzw-$(VERSION).tar.gz
	mv tkrzw-$(VERSION) tkrzw-c
	rm tkrzw-$(VERSION).tar.gz

./tkrzw-c/libtkrzw.a: ./tkrzw-c
	cd tkrzw-c && ./configure --enable-opt-native --enable-most-features
	cd tkrzw-c && make libtkrzw.a -j4 && rm *.o

.PHONY: clean
clean:
	rm -rf ./tkrzw-c
