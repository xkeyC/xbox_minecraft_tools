package uproxy

import (
	"fmt"
	"net"
	"sync"
)

type Connection struct {
	ClientAddr *net.UDPAddr
	ServerConn *net.UDPConn
}

func newConnection(srvAddr, cliAddr *net.UDPAddr) *Connection {
	conn := new(Connection)
	conn.ClientAddr = cliAddr
	srvUdp, err := net.DialUDP("udp", nil, srvAddr)
	if checkReport(err) {
		return nil
	}
	conn.ServerConn = srvUdp
	return conn
}

var ProxyConn *net.UDPConn

var ServerAddr *net.UDPAddr

var ClientDict = make(map[string]*Connection)

var dMutex = new(sync.Mutex)

var logs = "---start---"

func setup(hostPort string, port int) bool {
	// Set up Proxy
	resolveUDPAddr, err := net.ResolveUDPAddr("udp", fmt.Sprintf(":%d", port))
	if checkReport(err) {
		return false
	}
	listenUDP, err := net.ListenUDP("udp", resolveUDPAddr)
	if checkReport(err) {
		return false
	}
	ProxyConn = listenUDP
	udpAddr, err := net.ResolveUDPAddr("udp", hostPort)
	if checkReport(err) {
		return false
	}
	ServerAddr = udpAddr
	return true
}

func dLock() {
	dMutex.Lock()
}

func dUnlock() {
	dMutex.Unlock()
}

func runConnection(conn *Connection) {
	var buffer [1500]byte
	for {
		// Read from server
		n, err := conn.ServerConn.Read(buffer[0:])
		if checkReport(err) {
			continue
		}
		// Relay it to client
		_, err = ProxyConn.WriteToUDP(buffer[0:n], conn.ClientAddr)
		if checkReport(err) {
			continue
		}
	}
}

var needStop = false

func runProxy() {
	var buffer [1500]byte
	for {
		if needStop {
			return
		}
		n, cliAddr, err := ProxyConn.ReadFromUDP(buffer[0:])
		if checkReport(err) {
			continue
		}
		sAddr := cliAddr.String()
		dLock()
		conn, found := ClientDict[sAddr]
		if !found {
			conn = newConnection(ServerAddr, cliAddr)
			if conn == nil {
				dUnlock()
				continue
			}
			ClientDict[sAddr] = conn
			dUnlock()
			// Fire up routine to manage new connection
			go runConnection(conn)
		} else {
			dUnlock()
		}
		// Relay to server
		_, err = conn.ServerConn.Write(buffer[0:n])
		if checkReport(err) {
			continue
		}
	}
}

func checkReport(err error) bool {
	if err == nil {
		return false
	}
	logs = logs + "\n" + err.Error()
	return true
}

func CloseConnect() {
	needStop = true
	ProxyConn.Close()
	for _, connection := range ClientDict {
		connection.ServerConn.Close()
	}
}

func Connect(hostPort string, port int) string {
	if setup(hostPort, port) {
		runProxy()
	}
	defer func() {
		CloseConnect()
		needStop = false
	}()
	if needStop {
		return "closed"
	}
	var oldLog = logs + "\n---stop---"
	logs = "---start---"
	return oldLog
}
