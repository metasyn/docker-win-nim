#escape=`
FROM microsoft/windowsservercore
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV chocolateyUseWindowsCompression false

RUN iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')); `
    choco feature disable --name showDownloadProgress

RUN choco install git mingw -y

RUN git clone https://github.com/nim-lang/Nim.git
RUN cd Nim; `
    git clone --depth 1 https://github.com/nim-lang/csources.git; `
    cd csources; `
    Start-Process ./build64.bat; `
    cd ..; `
    bin\nim c koch; `
    koch boot -d:release; `
    koch tools
