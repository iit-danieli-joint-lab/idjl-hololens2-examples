# BasicXrAppWithVcpkgDependencies

This directory contains a modified version of the BasicXrApp, that is slightly modified to use a dependency (`open62541`) provided by vcpkg, even if msbuild is still used as a build system.

## Usage

First of all, you need to download the dependencies provided by vcpkg by opening a command prompt and executing:
~~~
cd vcpkg-deps
download-deps.bat
~~~

This will create a directory `vcpkg-deps\vcpkg-export-<***>-<***>`, that contains the libraries exported from vcpkg.

Once you do that, you can open the `BasicXrApp.sln` with Visual Studio and compiled the `BasicXrApp` for UWP for all the supported combinations of configurations (`Release`,`Debug`) and platforms (`ARM`,`ARM64`,`x86`,`x64`).

## Advanced Details

This section contains the advanced details on how this example was crated starting from `BasicXrApp`. It is not necessary to just compile the `BasicXrApp` example.


### Export from vcpkg installed libraries

The `vcpkg-export-<***>-<***>.zip` file that the `vcpkg-deps\download-deps.bat` script downloads and extracts is generates as follows:
~~~
git clone https://github.com/microsoft/vcpkg
cd vcpkg
# Other version could work, but this is the one used to generate the vcpkg-export-20210611-183728.zip archive
git checkout 7d472dd25830da92108eb76642c667aaa40512cb
# Boostrap vcpkg
.\bootstrap-vcpkg.bat
# Install open62541 for all the platforms we are intested in
.\vcpkg install open62541:x86-uwp open62541:x64-uwp open62541:arm-uwp open62541:arm64-uwp
# Export
.\vcpkg.exe export open62541:x64-uwp open62541:x86-uwp open62541:arm-uwp open62541:arm64-uwp --raw
~~~

This will create a `vcpkg-export-<***>-<***>.zip` file, that you can then upload in https://github.com/iit-danieli-joint-lab/idjl-hololens2-examples/releases/tag/storage . If more libraries or triplets are necessary, they just need to be added to the `vcpkg install` and `vcpkg export` invocations. This directory can be then 
added to the repo in `vcpkg-deps`, either directly or modifying the `vcpkg-deps\download-deps.bat` script.

### Modify the msbuild files to make use of the vcpkg-provided libraries

Once you have a `vcpkg-deps\vcpkg-export-<***>-<***>` directory, to include the libraries in it you need to properly include the `vcpkg-deps\vcpkg-export-<***>-<***>\scripts\buildsystems\msbuild\vcpkg.props` and `vcpkg-deps\vcpkg-export-<***>-<***>\scripts\buildsystems\msbuild\vcpkg.targets` in your Visual Studio project. 

To include the `vcpkg.props` file, follow the instruction in https://docs.microsoft.com/en-us/cpp/build/create-reusable-property-configurations?view=msvc-160 . This should result in something similar to the following lines being added in your `.vcproj` :
~~~
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|ARM'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|ARM64'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|Win32'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|Win32'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|ARM64'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|ARM'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
  <ImportGroup Label="PropertySheets" Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
    <Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.props" />
  </ImportGroup>
~~~

Instead, for including the `vcpkg.targets` file it turns out that **manually** adding a line such as:
~~~
<Import Project="..\..\vcpkg-deps\vcpkg-export-20210611-183728\scripts\buildsystems\msbuild\vcpkg.targets" /> 
~~~
as the last child element of the .vcproj  root <Project> does the trick. 


### Update existing project

If you already have a `.vcproj` with the correct modifications and you want to just update the vcpkg installed libraries
binary to point to a new version of the exported libraries as it is the case for the `samples\BasicXrApp\BasicXrApp_uwp.vcxproj`
contained in this directory, you just need to find the `vcpkg-deps\vcpkg-export-<***>-<***>` occurences in it and substitute them 
with the new version. You also need to do something similar to the `vcpkg-deps\download-deps.bat` script.
