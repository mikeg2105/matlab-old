GSOAP=/cygdrive/c/tools/gsoap/soapcpp2
SOAPH=/cygdrive/c/tools/gsoap/stdsoap2.h
SOAPC=/cygdrive/c/tools/gsoap/stdsoap2.c
SOAPCPP=/cygdrive/c/tools/gsoap/stdsoap2.cpp
CC=gcc
CPP=g++
LIBS=
COFLAGS=-O2
CWFLAGS=-Wall
CIFLAGS=-I/cygdrive/c/tools/gsoap
CMFLAGS=
CFLAGS= $(CWFLAGS) $(COFLAGS) $(CIFLAGS) $(CMFLAGS)
all:		calcclient calcserver
calcclient:	calc.h calcclient.c $(SOAPH) $(SOAPC)
		$(GSOAP) -c calc.h
		$(CC) $(CFLAGS) -o calcclient calcclient.c soapC.c soapClient.c $(SOAPC) $(LIBS)
calcserver:	calc.h calcserver.c $(SOAPH) $(SOAPC)
		$(GSOAP) -c calc.h
		$(CC) $(CFLAGS) -o calcserver calcserver.c soapC.c soapServer.c $(SOAPC) -lm $(LIBS)
clean:
		rm -f *.o soapH.h soapStub.h soapC.cpp soapC.c soapClient.cpp soapClient.c soapServer.cpp soapServer.c soap*Proxy.h
distclean:
		rm -f *.o *.wsdl *.xsd *.xml *.nsmap *.log soapH.h soapStub.h soapC.cpp soapC.c soapClient.cpp soapClient.c soapServer.cpp soapServer.c soap*Proxy.h calcclient calcserver
