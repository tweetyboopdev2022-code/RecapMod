include NickelHook/nh.mk

PKG_NAME = recapmod
TARGET   = librecapmod.so

SRCS += src/recapmod.cc

koboroot: $(TARGET)
	mkdir -p KoboRoot/usr/local/recapmod
	cp $(TARGET) KoboRoot/usr/local/recapmod/
	tar -czf KoboRoot.tgz -C KoboRoot usr
	rm -rf KoboRoot

clean:
	rm -rf KoboRoot* $(TARGET) *.o *.moc
