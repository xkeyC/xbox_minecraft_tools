package main

import "C"

//export Ping
func Ping(str *C.char) *C.char {
	goStr := C.GoString(str)
	if goStr == "PONG" {
		return str
	}
	return C.CString("ERROR")
}

func main() {

}
