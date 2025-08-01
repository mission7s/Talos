REM kill any running Salvo Monitor or any "dangling" SalvoMonitor.exe process
..\..\StartUtils\kill SalvoMonitor.ex
REM wait for SalvoMonitor.exe process to terminate (if already running)
sleep 1
REM start OUI
C:\OmniBus\WatchDog\Rel\WatchDog.exe C:\OmniBus\Sharer3\RelNtMt\Sharer3.exe,C:\OmniBus\SalvoMonitor\SalvoMonitor.exe
exit