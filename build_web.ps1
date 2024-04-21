$flutterCommand = "flutter"
$buildArgs = "build web --base-href /bad_fl/ --release"

Set-Location .\docs\
Invoke-Expression -Command "$flutterCommand $buildArgs"