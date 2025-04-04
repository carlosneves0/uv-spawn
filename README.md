# uv-spawn

libuv spawn child-process

## Building libuv on windows with cmake

```
mkdir build
cd build
cmake ..
cmake --build . --config Release
```

## Dependencies...

### stdlib.h
"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\ucrt"

### winsock2.h
"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\um" \

### vcruntime.h (needed by stdlib.h)
"/IC:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.39.33519\include" \

### winapifamily.h (included by winsock2.h)
"/IC:\Program Files (x86)\Windows Kits\10\Include\10.0.22621.0\shared"

## windows/cl

SRC: https://stackoverflow.com/a/77258913

```
"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\bin\Hostx86\x86\cl.exe"
/I "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\ATLMFC\include"
/I "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\include"
/I "C:\Program Files (x86)\Windows Kits\10\include\10.0.19041.0\ucrt"
/I "C:\Program Files (x86)\Windows Kits\10\include\10.0.19041.0\shared"
/I "C:\Program Files (x86)\Windows Kits\10\include\10.0.19041.0\um"
/D "WIN32"
/D "_USRDLL"
/D "_WINDLL"
/D "_UNICODE"
/D "UNICODE"
/D "NDEBUG"
/D "MYDLL_EXPORTS"
/permissive-
/W4
/WX
/Zc:wchar_t
/Zc:inline
/Zc:forScope
/fp:precise
/GS
/Gy
/O2
/Gd
/Oy-
/Oi
/MD
/FC
/EHsc
/diagnostics:column
/analyze-
/LD
/Fo"test.obj"
/Fe"MyDLL.dll" "test.cpp"
/link
/LIBPATH:"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\ATLMFC\lib\x86"
/LIBPATH:"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\lib\x86"
/LIBPATH:"C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\lib\x86\store\references"
/LIBPATH:"C:\Program Files (x86)\Windows Kits\10\References\10.0.19041.0"
/LIBPATH:"C:\Program Files (x86)\Windows Kits\10\lib\10.0.19041.0\ucrt\x86"
/LIBPATH:"C:\Program Files (x86)\Windows Kits\10\lib\10.0.19041.0\um\x86"
"kernel32.lib"
"user32.lib"
"gdi32.lib"
"advapi32.lib"
```