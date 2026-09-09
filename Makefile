CXX = arm-linux-gnueabihf-g++
MOC = moc

INCLUDES = -I. -INickelHook \
           -I/usr/include/arm-linux-gnueabihf/qt5 \
           -I/usr/include/arm-linux-gnueabihf/qt5/QtWidgets \
           -I/usr/include/arm-linux-gnueabihf/qt5/QtGui \
           -I/usr/include/arm-linux-gnueabihf/qt5/QtCore

CXXFLAGS = -fPIC -Wall -Wextra -std=c++11 -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB

all: librecapmod.so

recapmod.moc: src/recapmod.cc
	$(MOC) $(INCLUDES) src/recapmod.cc -o recapmod.moc

librecapmod.so: recapmod.moc src/recapmod.cc
	$(CXX) $(CXXFLAGS) $(INCLUDES) -shared -o librecapmod.so src/recapmod.cc

koboroot: librecapmod.so
	mkdir -p KoboRoot/usr/local/recapmod
	cp librecapmod.so KoboRoot/usr/local/recapmod/
	tar -czf KoboRoot.tgz -C KoboRoot usr
	rm -rf KoboRoot

clean:
	rm -rf KoboRoot* librecapmod.so recapmod.moc
