const std = @import("std");

// Note: focusing on a static-library build of libuv.
// Note: omitting tests.
// Note: omitting shared library configuration.
// Note: omitting Qemu build.
// Note: omitting ASan, MSan, TSan, etc.
// Note: omitting Android, OS390, OS400, GNU, SunOS, QNX, AIX, Haiku, and OpenBSD.
// Note: omitting Cygwin and MSYS.

// const targets: []const std.Target.Query = &.{
//     .{ .cpu_arch = .x86, .os_tag = .linux },
//     .{ .cpu_arch = .x86_64, .os_tag = .linux },
//     .{ .cpu_arch = .arm, .os_tag = .linux },
//     .{ .cpu_arch = .aarch64, .os_tag = .linux },
//     .{ .cpu_arch = .x86, .os_tag = .windows },
//     .{ .cpu_arch = .x86_64, .os_tag = .windows },
//     .{ .cpu_arch = .arm, .os_tag = .windows },
//     .{ .cpu_arch = .aarch64, .os_tag = .windows },
//     // .{ .cpu_arch = .aarch64, .os_tag = .macos },
//     // .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .gnu },
//     // .{ .cpu_arch = .x86_64, .os_tag = .linux, .abi = .musl },
// };

pub fn build(b: *std.Build) std.mem.Allocator.Error!void {
    const target = b.standardTargetOptions(.{});
    const target_isOpenBSD = false;
    // TO-DO: target_isOS390, target_isAndroid, ...
    const optimize = b.standardOptimizeOption(.{});

    // var cpu: []const u8 = "?";
    // if (target.cpu_arch == std.Target.Cpu.Arch.x86)
    //     cpu = "x86"
    // else if (target.cpu_arch == std.Target.Cpu.Arch.x86_64)
    //     cpu = "x86-64"
    // else if (target.cpu_arch == std.Target.Cpu.Arch.arm)
    //     cpu = "arm"
    // else if (target.cpu_arch == std.Target.Cpu.Arch.aarch64)
    //     cpu = "arm-64";
    // // TO-DO: else fail()
    // var os: []const u8 = "?";
    // if (target.os_tag == std.Target.Os.Tag.linux)
    //     os = "linux"
    // else if (target.os_tag == std.Target.Os.Tag.windows)
    //     os = "windows"
    // else if (target.os_tag == std.Target.Os.Tag.macos)
    //     os = "macos";
    // // TO-DO: else fail()
    // std.debug.print("target = \"{s}.{s}\"\n", .{ cpu, os });

    const libuv_root = "libuv.1.48.0/";
    var libuv_flags = std.ArrayList([]const u8).init(b.allocator);
    defer libuv_flags.deinit();
    try libuv_flags.appendSlice(&[_][]const u8{
        "-Wall",
        "-fno-strict-aliasing",
    });
    var libuv_libs = std.ArrayList([]const u8).init(b.allocator);
    defer libuv_libs.deinit();
    try libuv_libs.appendSlice(&[_][]const u8{
        "c",
    });
    var libuv_incs = std.ArrayList([]const u8).init(b.allocator);
    defer libuv_incs.deinit();
    try libuv_incs.appendSlice(&[_][]const u8{
        libuv_root ++ "include",
        libuv_root ++ "src",
    });
    var libuv_srcs = std.ArrayList([]const u8).init(b.allocator);
    defer libuv_srcs.deinit();
    try libuv_srcs.appendSlice(&[_][]const u8{
        libuv_root ++ "src/fs-poll.c",
        libuv_root ++ "src/idna.c",
        libuv_root ++ "src/inet.c",
        libuv_root ++ "src/random.c",
        libuv_root ++ "src/strscpy.c",
        libuv_root ++ "src/strtok.c",
        libuv_root ++ "src/thread-common.c",
        libuv_root ++ "src/threadpool.c",
        libuv_root ++ "src/timer.c",
        libuv_root ++ "src/uv-common.c",
        libuv_root ++ "src/uv-data-getter-setters.c",
        libuv_root ++ "src/version.c",
    });
    if (target.isGnuLibC()) {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-std=gnu99",
        });
    } else {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-std=c99",
        });
    }
    if (target.isWindows()) {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-DWIN32_LEAN_AND_MEAN",
            "-D_WIN32_WINNT=0x0602",
            "-D_CRT_DECLARE_NONSTDC_NAMES=0",
        });
        try libuv_libs.appendSlice(&[_][]const u8{
            "psapi",
            "user32",
            "advapi32",
            "iphlpapi",
            "userenv",
            "ws2_32",
            "dbghelp",
            "ole32",
            "shell32",
        });
        try libuv_incs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/win",
        });
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/win/dl.c",
            libuv_root ++ "src/win/pipe.c",
            libuv_root ++ "src/win/signal.c",
            libuv_root ++ "src/win/stream.c",
            libuv_root ++ "src/win/core.c",
            libuv_root ++ "src/win/thread.c",
            libuv_root ++ "src/win/tty.c",
            libuv_root ++ "src/win/udp.c",
            libuv_root ++ "src/win/winsock.c",
            libuv_root ++ "src/win/process.c",
            libuv_root ++ "src/win/async.c",
            libuv_root ++ "src/win/getaddrinfo.c",
            libuv_root ++ "src/win/util.c",
            libuv_root ++ "src/win/winapi.c",
            libuv_root ++ "src/win/poll.c",
            libuv_root ++ "src/win/tcp.c",
            libuv_root ++ "src/win/process-stdio.c",
            libuv_root ++ "src/win/error.c",
            libuv_root ++ "src/win/snprintf.c",
            libuv_root ++ "src/win/fs.c",
            libuv_root ++ "src/win/loop-watcher.c",
            libuv_root ++ "src/win/getnameinfo.c",
            libuv_root ++ "src/win/detect-wakeup.c",
            libuv_root ++ "src/win/fs-event.c",
            libuv_root ++ "src/win/handle.c",
        });
    } else {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-D_FILE_OFFSET_BITS=64",
            "-D_LARGEFILE_SOURCE",
            // "-pthreads",
        });
        try libuv_libs.appendSlice(&[_][]const u8{
            "pthread",
        });
        try libuv_incs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix",
        });
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/async.c",
            libuv_root ++ "src/unix/core.c",
            libuv_root ++ "src/unix/dl.c",
            libuv_root ++ "src/unix/fs.c",
            libuv_root ++ "src/unix/getaddrinfo.c",
            libuv_root ++ "src/unix/getnameinfo.c",
            libuv_root ++ "src/unix/loop-watcher.c",
            libuv_root ++ "src/unix/loop.c",
            libuv_root ++ "src/unix/pipe.c",
            libuv_root ++ "src/unix/poll.c",
            libuv_root ++ "src/unix/process.c",
            libuv_root ++ "src/unix/random-devurandom.c",
            libuv_root ++ "src/unix/signal.c",
            libuv_root ++ "src/unix/stream.c",
            libuv_root ++ "src/unix/tcp.c",
            libuv_root ++ "src/unix/thread.c",
            libuv_root ++ "src/unix/tty.c",
            libuv_root ++ "src/unix/udp.c",
        });
    }
    if (target.isDarwin() or target.isLinux()) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/proctitle.c",
        });
    }
    if (target.isDragonFlyBSD() or target.isFreeBSD()) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/freebsd.c",
        });
    }
    if (target.isDragonFlyBSD() or target.isFreeBSD() or target.isNetBSD() or target_isOpenBSD) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/posix-hrtime.c",
            libuv_root ++ "src/unix/bsd-proctitle.c",
        });
    }
    if (target.isDarwin() or target.isDragonFlyBSD() or target.isFreeBSD() or target.isNetBSD() or target_isOpenBSD) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/bsd-ifaddrs.c",
            libuv_root ++ "src/unix/kqueue.c",
        });
    }
    if (target.isFreeBSD()) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/random-getrandom.c",
        });
    }
    if (target.isDarwin() or target_isOpenBSD) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/random-getentropy.c",
        });
    }
    if (target.isDarwin()) {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-D_DARWIN_UNLIMITED_SELECT=1",
            "-D_DARWIN_USE_64_BIT_INODE=1",
        });
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/darwin-proctitle.c",
            libuv_root ++ "src/unix/darwin.c",
            libuv_root ++ "src/unix/fsevents.c",
        });
    }
    // if (target.isGnuLibC()) {
    //     try libuv_libs.appendSlice(&[_][]const u8{
    //         "dl",
    //     });
    //     try libuv_srcs.appendSlice(&[_][]const u8{
    //         libuv_root ++ "src/unix/bsd-ifaddrs.c",
    //         libuv_root ++ "src/unix/no-fsevents.c",
    //         libuv_root ++ "src/unix/no-proctitle.c",
    //         libuv_root ++ "src/unix/posix-hrtime.c",
    //         libuv_root ++ "src/unix/posix-poll.c",
    //         libuv_root ++ "src/unix/hurd.c",
    //     });
    // }
    if (target.isLinux()) {
        try libuv_flags.appendSlice(&[_][]const u8{
            "-D_GNU_SOURCE",
            "-D_POSIX_C_SOURCE=200112",
        });
        try libuv_libs.appendSlice(&[_][]const u8{
            "dl",
            "rt",
        });
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/linux.c",
            libuv_root ++ "src/unix/procfs-exepath.c",
            libuv_root ++ "src/unix/random-getrandom.c",
            libuv_root ++ "src/unix/random-sysctl-linux.c",
        });
    }
    if (target.isNetBSD()) {
        try libuv_libs.appendSlice(&[_][]const u8{
            "kvm",
        });
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/netbsd.c",
        });
    }
    if (target.isOpenBSD()) {
        try libuv_srcs.appendSlice(&[_][]const u8{
            libuv_root ++ "src/unix/openbsd.c",
        });
    }
    const libuv = b.addStaticLibrary(.{
        .name = "uv",
        .target = target,
        .optimize = optimize,
    });
    for (libuv_libs.items) |lib|
        libuv.linkSystemLibrary(lib);
    for (libuv_incs.items) |inc|
        libuv.addIncludePath(.{ .path = inc });
    libuv.addCSourceFiles(libuv_srcs.items, libuv_flags.items);
    b.installArtifact(libuv);

    const exe = b.addExecutable(.{
        .name = "uv-spawn",
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .path = libuv_root ++ "include" });
    exe.addCSourceFiles(&.{"main.c"}, &.{ "-std=gnu99", "-Wall" });
    exe.linkSystemLibrary("c");
    exe.linkLibrary(libuv);
    b.installArtifact(exe);

    const run_exe = b.addRunArtifact(exe);
    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_exe.step);
}
