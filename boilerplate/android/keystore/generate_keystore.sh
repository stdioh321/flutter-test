#!/bin/bash
# Generete keystore
keytool -genkey -v -keystore my-release-key.keystore -alias mykey -keyalg RSA -keysize 2048 -validity 10000
keytool -exportcert -list -v -alias mykey -keystore my-release-key.keystore
