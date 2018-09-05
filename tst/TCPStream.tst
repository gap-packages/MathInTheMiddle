# Contact a server (1)
gap> stream := InputOutputTCPStream("www.google.com", 80);
<input/output TCP stream to www.google.com:80>
gap> IsInputOutputTCPStream(stream);
true
gap> WriteLine(stream, "GET");
4
gap> ReadLine(stream);
"HTTP/1.0 200 OK\r\n"
gap> CloseStream(stream);
gap> stream;
<closed input/output TCP stream to www.google.com:80>
gap> Print(stream, "\n");
<closed input/output TCP stream to www.google.com:80>

# Contact a server (2)
gap> stream := InputOutputTCPStream("www.google.com", 80);
<input/output TCP stream to www.google.com:80>
gap> WriteAll(stream, "DELE");
true
gap> WriteLine(stream, "TE");
3
gap> ReadAllIoTCPStream(stream, 40);
"HTTP/1.0 400 Bad Request\r\nContent-Type: "
gap> ReadAllIoTCPStream(stream, 40);
"text/html; charset=UTF-8\r\nReferrer-Polic"
gap> IsEndOfStream(stream);
false
gap> all := ReadAll(stream);;
gap> Length(all) > 500;
true
gap> ReadByte(stream);
fail
gap> ReadAllIoTCPStream(stream, 40);
fail
gap> CloseStream(stream);
gap> IsEndOfStream(stream);
Error, Tried to check for data on closed file.
gap> ReadAllIoTCPStream(stream, 40);
Error, Tried to read from closed file.

# Contact a server (3)
gap> stream := InputOutputTCPStream("www.google.com", 80);;
gap> WriteByte(stream, IntChar('G'));;
gap> WriteByte(stream, IntChar('E'));;
gap> WriteByte(stream, IntChar('T'));
true
gap> WriteLine(stream, "");
1
gap> ReadLine(stream);
"HTTP/1.0 200 OK\r\n"
gap> string := ReadAllIoTCPStream(stream, 21000);;
gap> Length(string) <= 21000;
true
gap> string := ReadAll(stream, 21000);;
gap> Length(string) <= 21000;
true

# Serve a local client
gap> sock := IO_socket( IO.PF_INET, IO.SOCK_STREAM, "tcp" );;
gap> lookup := IO_gethostbyname( "localhost" );;
gap> port := 26133;;
gap> res := IO_bind( sock, IO_make_sockaddr_in( lookup.addr[1], port ) );
true
gap> IO_listen( sock, 5 );
true
gap> cmd := "echo \'";;
gap> Append(cmd, "LoadPackage(\"MathInTheMiddle\");;");
gap> Append(cmd, "clientstream := InputOutputTCPStream(\"localhost\",26133);;");
gap> Append(cmd, "WriteLine(clientstream, \"12345\");;");
gap> Append(cmd, "CloseStream(clientstream);");
gap> Append(cmd, "quit; quit;");
gap> Append(cmd, "\' | ");
gap> Append(cmd, GAPInfo.SystemEnvironment._);
gap> Append(cmd, " --quitonbreak -q -a 500M -m 500M -A &");
gap> Exec(cmd);
gap> socket_descriptor := IO_accept( sock, IO_MakeIPAddressPort("0.0.0.0",0) );;
gap> serverstream := InputOutputTCPStream(socket_descriptor);;
gap> FileDescriptorOfStream(serverstream) = socket_descriptor;
true
gap> ReadLine(serverstream);
"12345\n"
gap> CloseStream(serverstream);
