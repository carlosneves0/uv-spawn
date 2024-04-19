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

.output/x86-64.windows.uv-spawn.exe: makefile build.zig main.c | .output libuv.1.48.0
	zig build --summary all -Dtarget=x86_64-windows-gnu
	cp zig-out/bin/uv-spawn.exe $(@)

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