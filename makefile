.PHONY: all
.DEFAULT_GOAL := all

all: linux windows

linux: \
	.output/x86.linux.uv-spawn \
	.output/x86-64.linux.uv-spawn
# .output/arm.linux.uv-spawn \
# .output/arm-64.linux.uv-spawn

windows: \
	.output/x86.windows.uv-spawn.exe \
	.output/x86-64.windows.uv-spawn.exe
# .output/arm.windows.uv-spawn.exe \
# .output/arm-64.windows.uv-spawn.exe

.output/x86.linux.uv-spawn: makefile build.zig main.c | .output libuv.1.48.0
	zig build --summary all -Dtarget=x86-linux-gnu
	cp zig-out/bin/uv-spawn $(@)

.output/x86-64.linux.uv-spawn: makefile build.zig main.c | .output libuv.1.48.0
	zig build --summary all -Dtarget=x86_64-linux-gnu
	cp zig-out/bin/uv-spawn $(@)

# .output/arm.linux.uv-spawn: makefile build.zig main.c | .output libuv.1.48.0
# 	zig build --summary all -Dtarget=arm-linux
# 	cp zig-out/bin/uv-spawn $(@)

# .output/arm-64.linux.uv-spawn: makefile build.zig main.c | .output libuv.1.48.0
# 	zig build --summary all -Dtarget=aarch64-linux
# 	cp zig-out/bin/uv-spawn $(@)

.output/x86.windows.uv-spawn.exe: makefile build.zig main.c | .output libuv.1.48.0
	zig build --summary all -Dtarget=x86-windows-gnu
	cp zig-out/bin/uv-spawn.exe $(@)

# .output/x86-64.windows.uv-spawn.exe: makefile build.zig main.c | .output libuv.1.48.0
# 	zig build --summary all -Dtarget=x86_64-windows-gnu
# 	cp zig-out/bin/uv-spawn.exe $(@)
# SHELL := pwsh
# .SHELLFLAGS := -Command

SHELL := powershell.exe
.SHELLFLAGS := -NoProfile -Command

export PATH := 'C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\bin\Hostx64\x64;$(PATH)'

# THIS WORKS FINALLY!
# NEEDS `uv.dll` to be beside .exe
# .output/x86-64.windows.uv-spawn.exe: main.c libuv.1.48.0/build/Debug/uv.lib | .output
# 	cl /utf-8 /std:c11 /Wall /W4 /we4013 \
# 		"/Fe$(@)" \
# 		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt" \
# 		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um" \
# 		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared" \
# 		"/IC:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\include" \
# 		/Ilibuv.1.48.0\\include \
# 		libuv.1.48.0\\build\\Debug\\uv.lib \
# 		main.c \
# 		/link \
# 		"/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64" \
# 		"/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64" \
# 		"/libpath:C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\lib\x64"
.output/x86-64.windows.uv-spawn.exe: main.c libuv.1.48.0/build/Debug/uv.lib | .output
	cl /utf-8 /std:c11 /Wall /W4 /we4013 <#\
		#> "/Fe$(@)" <#\
		#> "/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt" <#\
		#> "/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um" <#\
		#> "/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared" <#\
		#> "/IC:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\include" <#\
		#> /Ilibuv.1.48.0\include <#\
		#> main.c <#\
		#> /link <#\
		#> "/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64" <#\
		#> "/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64" <#\
		#> "/libpath:C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\lib\x64" <#\
		#> libucrt.lib <#\
		#> ws2_32.lib <#\
		#> libuv.1.48.0\build\Debug\libuv.lib

libuv.1.48.0/dist/uv_a.lib:
	New-Item -ItemType Directory -Force "$(@)\.."
	cd "$(@)\.."; cmake .. -DBUILD_SHARED_LIBS=OFF -DUV_BUILD_TESTS=OFF
	cd "$(@)\..\.."; cmake --build dist -j 12

test.exe: main.c libuv.1.48.0/dist/uv_a.lib | .output
	cl /utf-8 /std:c11 /Wall /W4 /we4013 \
		"/Fe$(@)" \
		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt" \
		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um" \
		"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared" \
		"/IC:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\include" \
		/Ilibuv.1.48.0\\include \
		main.c \
		libuv.1.48.0/dist/uv_a.lib \
		/link \
		"/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\ucrt\x64" \
		"/libpath:C:\Program Files (x86)\Windows Kits\10\Lib\10.0.22621.0\um\x64" \
		"/libpath:C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\lib\x64"

# /EHsc /TC /showIncludes
uv.obj: | .output libuv.1.48.0
	cl /utf-8 /std:c11 /Wall /W4 /we4013 \
		/c \
		/DWIN32_LEAN_AND_MEAN \
		/D_WIN32_WINNT=0x0602 \
		/D_CRT_DECLARE_NONSTDC_NAMES=0 \
		/I "C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt" \
		/I "C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um" \
		/I "C:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared" \
		/I "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\include" \
		/Ilibuv.1.48.0\\include \
		/Ilibuv.1.48.0\\src \
		/Ilibuv.1.48.0\\src\\win \
		libuv.1.48.0\\src\\fs-poll.c \
		libuv.1.48.0\\src\\idna.c \
		libuv.1.48.0\\src\\inet.c \
		libuv.1.48.0\\src\\random.c \
		libuv.1.48.0\\src\\strscpy.c \
		libuv.1.48.0\\src\\strtok.c \
		libuv.1.48.0\\src\\thread-common.c \
		libuv.1.48.0\\src\\threadpool.c \
		libuv.1.48.0\\src\\timer.c \
		libuv.1.48.0\\src\\uv-common.c \
		libuv.1.48.0\\src\\uv-data-getter-setters.c \
		libuv.1.48.0\\src\\version.c \
		libuv.1.48.0\\src\\win\\async.c \
		libuv.1.48.0\\src\\win\\core.c \
		libuv.1.48.0\\src\\win\\detect-wakeup.c \
		libuv.1.48.0\\src\\win\\dl.c \
		libuv.1.48.0\\src\\win\\error.c \
		libuv.1.48.0\\src\\win\\fs.c \
		libuv.1.48.0\\src\\win\\fs-event.c \
		libuv.1.48.0\\src\\win\\getaddrinfo.c \
		libuv.1.48.0\\src\\win\\getnameinfo.c \
		libuv.1.48.0\\src\\win\\handle.c \
		libuv.1.48.0\\src\\win\\loop-watcher.c \
		libuv.1.48.0\\src\\win\\pipe.c \
		libuv.1.48.0\\src\\win\\thread.c \
		libuv.1.48.0\\src\\win\\poll.c \
		libuv.1.48.0\\src\\win\\process.c \
		libuv.1.48.0\\src\\win\\process-stdio.c \
		libuv.1.48.0\\src\\win\\signal.c \
		libuv.1.48.0\\src\\win\\snprintf.c \
		libuv.1.48.0\\src\\win\\stream.c \
		libuv.1.48.0\\src\\win\\tcp.c \
		libuv.1.48.0\\src\\win\\tty.c \
		libuv.1.48.0\\src\\win\\udp.c \
		libuv.1.48.0\\src\\win\\util.c \
		libuv.1.48.0\\src\\win\\winapi.c \
		libuv.1.48.0\\src\\win\\winsock.c \
		/out:uv.obj


# .output/arm.windows.uv-spawn.exe: makefile build.zig main.c | .output libuv.1.48.0
# 	zig build --summary all -Dtarget=arm-windows
# 	cp zig-out/bin/uv-spawn.exe $(@)

# .output/arm-64.windows.uv-spawn.exe: makefile build.zig main.c | .output libuv.1.48.0
# 	zig build --summary all -Dtarget=aarch64-windows
# 	cp zig-out/bin/uv-spawn.exe $(@)

.output:
	mkdir $(@)

libuv.1.48.0:
	git clone --branch v1.48.0 --depth 1 https://github.com/libuv/libuv.git libuv.1.48.0