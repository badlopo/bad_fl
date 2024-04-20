$flutterCommand = "flutter"
$buildArgs = "build web --base-href /bad_fl/ --release"

Set-Location .\example\
Invoke-Expression -Command "$flutterCommand $buildArgs"