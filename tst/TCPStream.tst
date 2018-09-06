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
gap> ReadLine(stream);
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
gap> ReadByte(stream) = IntChar('H');
true
gap> ReadLine(stream);
"TTP/1.0 200 OK\r\n"
gap> string := ReadAllIoTCPStream(stream, 21000);;
gap> Length(string) <= 21000;
true
gap> string := ReadAll(stream, 21000);;
gap> Length(string) <= 21000;
true

# Serve a local client
gap> sock := IO_socket(IO.PF_INET, IO.SOCK_STREAM, "tcp");;
gap> lookup := IO_gethostbyname("localhost");;
gap> port := 26133;;
gap> res := IO_bind( sock, IO_make_sockaddr_in(lookup.addr[1], port));
true
gap> IO_listen(sock, 5);
true
gap> out := "";;
gap> child := IO_fork();;
gap> if child = 0 then
>   clientstream := InputOutputTCPStream("localhost",26133);;
>   WriteLine(clientstream, "12345");;
>   if ReadLine(clientstream){[1..5]} = "54321" then 
>     WriteAll(clientstream, "Read successfully!");;
>   fi;
>   CloseStream(clientstream);
>   QUIT_GAP(0);
> fi;
gap> socket_descriptor := IO_accept(sock, IO_MakeIPAddressPort("0.0.0.0", 0));;
gap> serverstream := InputOutputTCPStream(socket_descriptor);;
gap> FileDescriptorOfStream(serverstream) = socket_descriptor;
true
gap> ReadLine(serverstream);
"12345\n"
gap> WriteLine(serverstream, "54321");
6
gap> ReadLine(serverstream);
"Read successfully!"
gap> wait := IO_WaitPid(child, true);;
gap> wait.pid = child;
true
gap> wait.status;
0
gap> CloseStream(serverstream);

# Errors
gap> stream := InputOutputTCPStream("www.google.com", 80);;
gap> ReadAll(stream, -1);
Error, ReadAll: negative limit not allowed
gap> WriteByte(stream, -1);
Error, <byte> must an integer between 0 and 255
gap> WriteByte(stream, 256);
Error, <byte> must an integer between 0 and 255

# Vandalise a stream to cause IO to fail
gap> stream := InputOutputTCPStream("www.google.com", 80);;
gap> stream![1]!.wbufsize := 0;;
gap> stream![1]!.fd := "terrible input!";;
gap> WriteLine(stream, "GET");
fail
gap> WriteAll(stream, "GET");
fail
gap> WriteByte(stream, IntChar('G'));
fail
