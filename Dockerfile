# escape=`

FROM mcr.microsoft.com/windows:1903
RUN powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

RUN choco feature enable -n=allowGlobalConfirmation
RUN powershell -NoProfile -InputFormat None -Command `
    choco install svn cmake --installargs 'ADD_CMAKE_TO_PATH=""System""' visualstudio2017buildtools visualstudio2017-workload-vctools -y;

ARG svnUSERNAME
ARG svnPASSWORD
RUN svn checkout http://www.bci2000.org/svn/trunk --username %svnUSERNAME% --password %svnPASSWORD%

WORKDIR /trunk/build

RUN cmake .
RUN setx /M PATH "%PATH%;C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin"
RUN MSBuild CMakeFiles/core/Tools/cmdline/bci_dat2stream.vcxproj /p:Configuration=Release && `
    MSBuild CMakeFiles/core/Tools/cmdline/bci_stream2prm.vcxproj /p:Configuration=Release

CMD powershell Copy-Item -Path "CMakeFiles\core\tools\cmdline\Release\*" -Destination "C:\trunk\outputDirectory" -Recurse && `
    powershell Copy-Item "..\data\samplefiles\eeg1_1.dat" -Destination "C:\trunk\outputDirectory"

# mkdir data && docker run -it -v %CD%\data:C:\trunk\outputDirectory thebrainchain/bci2000:latest



