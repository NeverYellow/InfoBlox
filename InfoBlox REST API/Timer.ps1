  $timeout = new-timespan -Minutes 2 # max time
    $sw = [diagnostics.stopwatch]::StartNew()
    while ($sw.elapsed -lt $timeout) {
   }
