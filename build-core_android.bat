cd lib-core


set GOARCH=arm64
set GOOS=android
set CGO_ENABLED=1

set ANDROID_NDK_HOME=C:\Users\me\AppData\Local\Android\Sdk\ndk\23.1.7779620
set TOOLCHAIN=%ANDROID_NDK_HOME%/toolchains/llvm/prebuilt/windows-x86_64
set TARGET=aarch64-linux-android
set API=26

set CC=%TOOLCHAIN%/bin/%TARGET%%API%-clang

go build -buildmode=c-shared -o ../android/app/lib/arm64-v8a/libcore.so main.go

echo "Build arm64-v8a success"
cd ..
dart run ffigen