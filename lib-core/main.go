package main

import "C"
import (
	"lib-core/uproxy"
)

//export Ping
func Ping(str *C.char) *C.char {
	goStr := C.GoString(str)
	if goStr == "PONG" {
		return str
	}
	return C.CString("ERROR")
}

//export StartUDPProxy
func StartUDPProxy(host *C.char, port *C.char) *C.char {
	hostGO := C.GoString(host)
	portGO := C.GoString(port)
	result := uproxy.Connect(hostGO+":"+portGO, 19132)
	return makeCChar(result)
}

//export StopUDPProxy
func StopUDPProxy() {
	uproxy.CloseConnect()
}

func makeCChar(str string) *C.char {
	return C.CString(str)
}

func main() {}
