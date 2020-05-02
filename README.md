# Description:

A Windows 10 container containing the BCI2000 trunk source code and necessary Visual Studio 2017 Build Tools as well as the VC Tools Workload.

The current example will download and install all source code and packages and then build two of BCI2000's command line tools bci_dat2stream and bci_stream2prm. It will then move them to the BCI2000\outputDirectory which is mounted onto the host system.

# Instructions

+ `git clone https://github.com/thebrainchain/BCI2000_Docker .`
+ `docker build -t bci2000:latest --build-arg svnUSERNAME=%svnUSERNAME% --build-arg svnPASSWORD=%svnPASSWORD% .`
    - Replace %svnUSERNAME% and %svnPASSWORD% with your bci2000.org credentials
+ `mkdir data && docker run -v %CD%\data:C:\trunk\outputDirectory bci2000:latest`

# To test:
From the host machine (not container)
- `cd data && bci_dat2stream.exe < eeg1_1.dat | bci_stream2prm > eeg1_1.prm`

# Notes
    - Currently doesn't support building any projects that have QT dependencies
    - Tested with BCI2000 R6113 on a Windows 10 machine

# To modify the solutions that are generated:
>   - Enter the container:
>       - `docker run -it -v %CD%\data:C:\trunk\outputDirectory bci2000:latest`
>   - modify the CMakeLists.txt
>   - `cmake .`
>   - `MSBuild CMakeFiles/.../%VCXPROJ_to_be_built%`
>   - `powershell Copy-Item "CMakeFiles/.../%VCXPROJ_that_was_built%" -Destination "C:\trunk\outputDirectory"`