#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <uv.h>

int uv_return_code;

void uv_handle_exit(uv_process_t *uv_child_process, int64_t exit_code, int exit_signal);

int main()
{
    fprintf(stderr, "uv_loop = uv_default_loop() -> ");
    uv_loop_t *uv_loop = uv_default_loop();
    if (uv_loop)
        fprintf(stderr, "OK.\n");
    else
    {
        fprintf(stderr, "ERROR: OOM.\n");
        return 1;
    }
    
    uv_process_t uv_child_process;
    uv_process_options_t uv_child_options = {0};
    char *argv[] = {"echo", "foo", "bar", NULL};
    uv_child_options.file = "echo";
    uv_child_options.args = argv;
    uv_child_options.stdio_count = 3;
    uv_stdio_container_t uv_child_stdio[3];
    uv_child_stdio[0].flags = UV_IGNORE;
    uv_child_stdio[1].flags = UV_INHERIT_FD;
    uv_child_stdio[1].data.fd = 1;
    uv_child_stdio[2].flags = UV_INHERIT_FD;
    uv_child_stdio[2].data.fd = 2;
    uv_child_options.stdio = uv_child_stdio;
    uv_child_options.exit_cb = uv_handle_exit;
    // uv_child_options.flags = UV_PROCESS_WINDOWS_VERBATIM_ARGUMENTS | UV_PROCESS_WINDOWS_HIDE | UV_PROCESS_WINDOWS_HIDE_CONSOLE | UV_PROCESS_WINDOWS_HIDE_GUI;
    fprintf(stderr, "uv_spawn(uv_loop, &uv_child_process, &uv_child_options) -> ");
    uv_return_code = uv_spawn(uv_loop, &uv_child_process, &uv_child_options);
    if (uv_return_code >= 0)
        fprintf(stderr, "OK: uv_child_process.pid=%d.\n", uv_child_process.pid);
    else
    {
        fprintf(stderr, "ERROR: %d.\n", uv_return_code);
        fprintf(stderr, "ERROR: %s (%d): %s.\n", uv_err_name(uv_return_code), uv_return_code, uv_strerror(uv_return_code));
        return 1;
    }
    
    fprintf(stderr, "uv_run(uv_loop, UV_RUN_DEFAULT) -> ...\n");
    uv_return_code = uv_run(uv_loop, UV_RUN_DEFAULT);
    if (uv_return_code >= 0)
        fprintf(stderr, "uv_run(uv_loop, UV_RUN_DEFAULT) -> OK.\n");
    else
    {
        fprintf(stderr, "uv_run(uv_loop, UV_RUN_DEFAULT) -> ERROR: %s (%d): %s.\n", uv_err_name(uv_return_code), uv_return_code, uv_strerror(uv_return_code));
        return 1;
    }
    
    fprintf(stderr, "uv_loop_close(uv_loop) -> ");
    uv_return_code = uv_loop_close(uv_loop);
    if (uv_return_code >= 0)
        fprintf(stderr, "OK.\n");
    else
    {
        fprintf(stderr, "ERROR: %s (%d): %s.\n", uv_err_name(uv_return_code), uv_return_code, uv_strerror(uv_return_code));
        return 1;
    }

    return 0;
}

void uv_handle_exit(uv_process_t *uv_child_process, int64_t exit_code, int exit_signal)
{
    fprintf(stderr, "Process exited with code %"PRId64", signal %d\n", exit_code, exit_signal);
    uv_close((uv_handle_t *) uv_child_process, NULL);
}