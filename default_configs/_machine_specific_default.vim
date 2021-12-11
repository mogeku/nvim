" please read through this file and change what you need to change

if g:os == 'win'
	let g:python_host_prog='D:/Program Files/Python/Python2.7.18/python.exe'
	let g:python3_host_prog='D:/Program Files/Python/Python3.9.0/python.exe'

	let g:mkdp_browser = 'C:/Users/12098/AppData/Local/Microsoft/WindowsApps/MicrosoftEdge.exe'
else
	let g:python_host_prog='/usr/bin/python2'
	let g:python3_host_prog='/usr/bin/python3'

	let g:mkdp_browser = 'chromium'
endif
let g:mkdp_browserfunc = 'open '

let g:flutter_default_device = 'iPhone\ 11\ Pro'
let g:flutter_run_args = "--flavor dev"

let g:mkdp_browserfunc = 'open '

let g:barbaric_ime = 'fcitx'
