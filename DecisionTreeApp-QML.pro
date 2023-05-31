QT += core-private quick network

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

HEADERS += \
    Modules/authhandler.h \
    Modules/decisionhandler.h

SOURCES += \
    Modules/decisionhandler.cpp \
    main.cpp \
    Modules/authhandler.cpp \

RESOURCES += qml.qrc

DISTFILES +=

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Link OpenSSl Libraries (Adjust SSL_PATH to your SDK android_openssl location)
!contains(QT.network_private.enabled_features, openssl-linked) {
    CONFIG(release, debug|release): SSL_PATH = D:/Qt/Android/android_openssl
                              else: SSL_PATH = D:/Qt/Android/android_openssl/no-asm

    if (versionAtLeast(QT_VERSION, 6.5.0)) {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_3/arm64-v8a/libcrypto_3.so \
            $$SSL_PATH/ssl_3/arm64-v8a/libssl_3.so \
            $$SSL_PATH/ssl_3/armeabi-v7a/libcrypto_3.so \
            $$SSL_PATH/ssl_3/armeabi-v7a/libssl_3.so \
            $$SSL_PATH/ssl_3/x86/libcrypto_3.so \
            $$SSL_PATH/ssl_3/x86/libssl_3.so \
            $$SSL_PATH/ssl_3/x86_64/libcrypto_3.so \
            $$SSL_PATH/ssl_3/x86_64/libssl_3.so
    } else {
        ANDROID_EXTRA_LIBS += \
            $$SSL_PATH/ssl_1.1/arm64-v8a/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/arm64-v8a/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/armeabi-v7a/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/armeabi-v7a/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/x86/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/x86/libssl_1_1.so \
            $$SSL_PATH/ssl_1.1/x86_64/libcrypto_1_1.so \
            $$SSL_PATH/ssl_1.1/x86_64/libssl_1_1.so
    }
}
