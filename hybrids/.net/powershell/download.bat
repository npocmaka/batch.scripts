<# :
  @setlocal disabledelayedexpansion enableextensions
  @echo off
  powershell -nol -noni -nop -ex bypass -c "&{[ScriptBlock]::Create((cat '%~f0') -join [Char[]]10).Invoke(@(&{$args}%*))}"
  exit /b
#>

function filesize($length) {
  $gb = [math]::pow(2, 30)
  $mb = [math]::pow(2, 20)
  $kb = [math]::pow(2, 10)

  if($length -gt $gb) {
    "{0:n1} GB" -f ($length / $gb)
  } elseif($length -gt $mb) {
    "{0:n1} MB" -f ($length / $mb)
  } elseif($length -gt $kb) {
    "{0:n1} KB" -f ($length / $kb)
  } else {
    "$($length) B"
  }
}

function ftp_file_size($url) {
    $request = [net.ftpwebrequest]::create($url)
    $request.method = [net.webrequestmethods+ftp]::getfilesize
    $request.getresponse().contentlength
}

function url_remote_filename($url) {
  $uri = (new-object URI $url)
  $basename = split-path $uri.PathAndQuery -leaf
  If ($basename -match ".*[?=]+([\w._-]+)") {
    $basename = $matches[1]
  }
  If (($basename -notlike "*.*") -or ($basename -match "^[v.\d]+$")) {
    $basename = split-path $uri.AbsolutePath -leaf
  }
  If (($basename -notlike "*.*") -and ($uri.Fragment -ne "")) {
    $basename = $uri.Fragment.Trim('/', '#')
  }
  return $basename
}

function dl($url, $to, $progress) {
  [System.Net.ServicePointManager]::SecurityProtocol = 3072 -bor 768 -bor 192
  $reqUrl = ($url -split "#")[0]
  $wreq = [net.webrequest]::create($reqUrl)

  try {
    $wres = $wreq.GetResponse()
  } catch [System.Net.WebException] {
    $exc = $_.Exception
    $handledCodes = @(
      [System.Net.HttpStatusCode]::MovedPermanently,  # HTTP 301
      [System.Net.HttpStatusCode]::Found,       # HTTP 302
      [System.Net.HttpStatusCode]::SeeOther,      # HTTP 303
      [System.Net.HttpStatusCode]::TemporaryRedirect  # HTTP 307
    )

    $redirectRes = $exc.Response
    if ($handledCodes -notcontains $redirectRes.StatusCode) {
      throw $exc
    }

    if ((-not $redirectRes.Headers) -or ($redirectRes.Headers -notcontains 'Location')) {
      throw $exc
    }

    $newUrl = $redirectRes.Headers['Location']

    if ($url -like '*#/*') {
      $null, $postfix = $url -split '#/'
      $newUrl = "$newUrl#/$postfix"
    }
    dl $newUrl $to $progress
    return
  }

  if(-not $to) {
    $to = url_remote_filename $url
  }

  $total = $wres.ContentLength
  if($total -eq -1 -and $wreq -is [net.ftpwebrequest]) {
    $total = ftp_file_size($url)
  }

  if ($progress -and ($total -gt 0)) {
    [console]::CursorVisible = $false
    function dl_onProgress($read) {
      dl_progress $read $total $(split-path $to -leaf)
    }
  } else {
    if($total -gt 0) {
      write-host "Downloading $url ($(filesize $total))..."
    } else {
      write-host "Downloading $url ..."
    }
    function dl_onProgress {
      #no op
    }
  }

  try {
    $s = $wres.getresponsestream()
    $fs = [io.file]::openwrite($to)
    $buffer = new-object byte[] 2048
    $totalRead = 0
    $sw = [diagnostics.stopwatch]::StartNew()

    dl_onProgress $totalRead
    while(($read = $s.read($buffer, 0, $buffer.length)) -gt 0) {
      $fs.write($buffer, 0, $read)
      $totalRead += $read
      if ($sw.elapsedmilliseconds -gt 100) {
        $sw.restart()
        dl_onProgress $totalRead
      }
    }
    $sw.stop()
    dl_onProgress $totalRead
  } finally {
    if ($progress) {
      [console]::CursorVisible = $true
      write-host
    }
    if ($fs) {
      $fs.close()
    }
    if ($s) {
      $s.close();
    }
    $wres.close()
  }
}

function dl_progress_output($filename, $read, $total, $console) {
  $p = [math]::Round($read / $total * 100, 0)

  $left  = "$filename ($(filesize $total))"
  $right = [string]::Format("{0,3}%", $p)
  $midwidth  = $console.BufferSize.Width - ($left.Length + $right.Length + 8)
  $completed = [math]::Abs([math]::Round(($p / 100) * $midwidth, 0) - 1)

  if ($completed -gt 1) {
    $dashes = [string]::Join("", ((1..$completed) | ForEach-Object {"="}))
  }

  $dashes += switch($p) {
    100 {"="}
    default {">"}
  }

  $spaces = switch($dashes.Length) {
    $midwidth {[string]::Empty}
    default {
      [string]::Join("", ((1..($midwidth - $dashes.Length)) | ForEach-Object {" "}))
    }
  }

  "$left [$dashes$spaces] $right"
}

function dl_progress($read, $total, $filename) {
  $console = $host.UI.RawUI;
  $left  = $console.CursorPosition.X;
  $top   = $console.CursorPosition.Y;
  $width = $console.BufferSize.Width;

  if($read -eq 0) {
    $maxOutputLength = $(dl_progress_output $filename 100 $total $console).length
    if (($left + $maxOutputLength) -gt $width) {
      write-host
      $left = 0
      $top  = $top + 1
      if($top -gt $console.CursorPosition.Y) { $top = $console.CursorPosition.Y }
    }
  }

  write-host $(dl_progress_output $filename $read $total $console) -nonewline
  [console]::SetCursorPosition($left, $top)
}

if ($args.count -gt 0) {
  dl $args[0] $args[1] $(!([console]::isoutputredirected))
} else {
  write-host "Usage: download <url> [outfile]"
}
